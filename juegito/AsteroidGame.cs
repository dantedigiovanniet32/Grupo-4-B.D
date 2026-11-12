using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using MySqlConnector;

namespace Asteroides;

internal sealed class AsteroidGame : Game
{
    private const int InitialLives = 6;
    private const int PointsPerExtraLife = 5000;
    private const int MaxHitsPerLife = 4;
    private const float CameraZoom = 2f;
    private const int HudScale = 3;
    private const int GlyphWidth = 14;
    private const int GlyphAdvance = 13;
    private const float HitInvulnerabilityDuration = 1.2f;
    private const float DamageDuration = 0.45f;
    private const float DeathDuration = 4f;
    private const float RestartDuration = 0.8f;
    private const float ShipSpeed = 300f;
    private const float BackgroundScrollSpeed = 90f;
    private const int LeaderboardSize = 10;
    private const string BackgroundMusicFile = "Chaos_Angel_Zone_Act_3_-_Sonic_Advance_3_Remastered.wav";

    private readonly GraphicsDeviceManager graphics;
    private SpriteBatch spriteBatch = null!;
    private readonly Random random = new();
    private readonly List<Asteroid> asteroids = [];
    private readonly List<Projectile> projectiles = [];
    private readonly List<Debris> debris = [];
    private readonly List<SoundEffectInstance> activeSounds = [];
    private readonly Dictionary<char, Rectangle> glyphs = [];
    private readonly List<LeaderboardEntry> leaderboard = [];

    private Texture2D background = null!;
    private Texture2D pixel = null!;
    private Texture2D[] shipFrames = [];
    private Texture2D[] damageFrames = [];
    private Texture2D deathShip = null!;
    private Texture2D largeAsteroid = null!;
    private Texture2D mediumAsteroid = null!;
    private Texture2D smallAsteroid = null!;
    private Texture2D[] largeDebris = [];
    private Texture2D[] smallDebris = [];
    private Texture2D fontAtlas = null!;

    private SoundEffect damageSound = null!;
    private SoundEffect explosionSound = null!;
    private SoundEffect largeAsteroidSound = null!;
    private SoundEffect smallAsteroidSound = null!;
    private SoundEffect? backgroundMusicEffect;
    private SoundEffectInstance? backgroundMusic;
    private GameDatabase? database;

    private Vector2 shipPosition;
    private RunState state = RunState.Playing;
    private float stateTime;
    private float spawnTimer;
    private float shotTimer;
    private float survivalTime;
    private float explosionTimer;
    private float invulnerabilityTimer;
    private float backgroundOffset;
    private int score;
    private int lives = InitialLives;
    private int hitsRemaining = MaxHitsPerLife;
    private int awardedLives;
    private KeyboardState previousKeyboard;
    private DateTime sessionStartedAt = DateTime.Now;
    private DateTime sessionFinishedAt;
    private string playerName = string.Empty;
    private string databaseStatus = string.Empty;

    private Rectangle WorldBounds => new(0, 0, background.Width * 4, background.Height);

    public AsteroidGame()
    {
        graphics = new GraphicsDeviceManager(this)
        {
            PreferredBackBufferWidth = 960,
            PreferredBackBufferHeight = 540,
            SynchronizeWithVerticalRetrace = true
        };
        Content.RootDirectory = "Content";
        IsMouseVisible = true;
        Window.Title = "Asteroides";
        Window.AllowUserResizing = true;
    }

    protected override void Initialize()
    {
        shipPosition = new Vector2(110, graphics.PreferredBackBufferHeight / 2f);
        sessionStartedAt = DateTime.Now;
        base.Initialize();
    }

    protected override void LoadContent()
    {
        spriteBatch = new SpriteBatch(GraphicsDevice);
        background = LoadTexture("bg.png");
        shipPosition.Y = background.Height / 2f;
        pixel = new Texture2D(GraphicsDevice, 1, 1);
        pixel.SetData([Color.White]);
        shipFrames = [LoadTexture(@"Assets\ship_0.png"), LoadTexture(@"Assets\ship_1.png")];
        damageFrames = [LoadTexture(@"Assets\ship_damage_0.png"), LoadTexture(@"Assets\ship_damage_1.png")];
        deathShip = LoadTexture("navemuerteycaida.png");
        largeAsteroid = LoadTexture("ast.png");
        mediumAsteroid = LoadTexture("mid_ast.png");
        smallAsteroid = LoadTexture("mini_ast.png");
        largeDebris = [LoadTexture("parts1.png"), LoadTexture("parts2.png")];
        smallDebris = [LoadTexture("mini_parts1.png"), LoadTexture("mini_parts2.png")];
        fontAtlas = LoadTexture(@"Assets\font_atlas.png");
        BuildGlyphMap();

        damageSound = LoadSound("da\u00f1osonido.wav");
        explosionSound = LoadSound("sonidofondoexplosion.wav");
        largeAsteroidSound = LoadSound("destruccionmeteoritos.wav");
        smallAsteroidSound = LoadSound("destruccionmeteoritoNormal.wav");
        var musicPath = Path.Combine(AppContext.BaseDirectory, BackgroundMusicFile);
        if (File.Exists(musicPath))
        {
            using var stream = File.OpenRead(musicPath);
            backgroundMusicEffect = SoundEffect.FromStream(stream);
            backgroundMusic = backgroundMusicEffect.CreateInstance();
            backgroundMusic.IsLooped = true;
            backgroundMusic.Volume = 0.5f;
            backgroundMusic.Play();
        }
        else
        {
            Console.Error.WriteLine($"No se encontro la musica de fondo: {musicPath}");
        }
    }

    protected override void Update(GameTime gameTime)
    {
        var keyboard = Keyboard.GetState();
        if (keyboard.IsKeyDown(Keys.Escape))
            Exit();

        var elapsed = (float)gameTime.ElapsedGameTime.TotalSeconds;
        backgroundOffset = (backgroundOffset + BackgroundScrollSpeed * elapsed) % background.Width;
        UpdateSounds();

        var testingEndRequested = state is RunState.Playing or RunState.Damaged
            && (IsKeyPressed(keyboard, Keys.Back) || IsKeyPressed(keyboard, Keys.Delete));
        if (testingEndRequested)
            FinishRunForTesting();
        else
        {
            switch (state)
            {
                case RunState.Playing:
                    UpdatePlaying(elapsed);
                    break;
                case RunState.Damaged:
                    UpdatePlaying(elapsed);
                    stateTime += elapsed;
                    if (stateTime >= DamageDuration)
                    {
                        if (hitsRemaining == 0)
                            BeginDeath();
                        else
                        {
                            state = RunState.Playing;
                            stateTime = 0;
                        }
                    }
                    break;
                case RunState.Dying:
                    UpdateDeath(elapsed);
                    break;
                case RunState.Restarting:
                    stateTime += elapsed;
                    if (stateTime >= RestartDuration)
                        ResetLevel();
                    break;
                case RunState.NameEntry:
                    if (IsKeyPressed(keyboard, Keys.Space))
                        RestartGame();
                    else
                        UpdateNameEntry(keyboard);
                    break;
                case RunState.PersonalScore:
                    if (IsKeyPressed(keyboard, Keys.Space))
                        RestartGame();
                    else if (IsKeyPressed(keyboard, Keys.Enter))
                        ShowLeaderboard();
                    break;
                case RunState.Leaderboard:
                    if (IsKeyPressed(keyboard, Keys.Space))
                        RestartGame();
                    else if (IsKeyPressed(keyboard, Keys.Enter))
                        state = RunState.PersonalScore;
                    break;
            }
        }

        previousKeyboard = keyboard;
        base.Update(gameTime);
    }

    private void UpdateNameEntry(KeyboardState keyboard)
    {
        if (IsKeyPressed(keyboard, Keys.Back) && playerName.Length > 0)
            playerName = playerName[..^1];

        foreach (var key in keyboard.GetPressedKeys())
        {
            if (!IsKeyPressed(keyboard, key) || playerName.Length >= 3)
                continue;

            var letter = key.ToString();
            if (letter.Length == 1 && letter[0] is >= 'A' and <= 'Z')
                playerName += letter;
        }

        if (IsKeyPressed(keyboard, Keys.Enter) && playerName.Length == 3)
            SaveFinalScore();
    }

    private bool IsKeyPressed(KeyboardState keyboard, Keys key) =>
        keyboard.IsKeyDown(key) && previousKeyboard.IsKeyUp(key);

    private void SaveFinalScore()
    {
        try
        {
            database ??= new GameDatabase();
            database.SaveFinalResult(
                playerName,
                sessionStartedAt,
                sessionFinishedAt,
                (int)survivalTime,
                score);
            databaseStatus = "PUNTAJE GUARDADO EN SQL";
            state = RunState.PersonalScore;
        }
        catch (InvalidOperationException exception)
        {
            ShowDatabaseError("CONFIGURACION", exception);
        }
        catch (MySqlException exception)
        {
            ShowDatabaseError("GUARDADO", exception);
        }
        catch (ArgumentException exception)
        {
            ShowDatabaseError("CONEXION", exception);
        }
    }

    private void ShowLeaderboard()
    {
        try
        {
            database ??= new GameDatabase();
            leaderboard.Clear();
            leaderboard.AddRange(database.GetLeaderboard(LeaderboardSize));
            databaseStatus = "PUNTAJES CONSULTADOS EN SQL";
            state = RunState.Leaderboard;
        }
        catch (InvalidOperationException exception)
        {
            ShowDatabaseError("CONFIGURACION", exception);
        }
        catch (MySqlException exception)
        {
            ShowDatabaseError("CONSULTA", exception);
        }
        catch (ArgumentException exception)
        {
            ShowDatabaseError("CONEXION", exception);
        }
    }

    private void ShowDatabaseError(string operation, Exception exception)
    {
        Console.Error.WriteLine($"Error SQL ({operation}): {exception}");
        databaseStatus = $"ERROR SQL {operation} - REVISA LA CONSOLA";
    }

    private void UpdatePlaying(float elapsed)
    {
        invulnerabilityTimer = Math.Max(0, invulnerabilityTimer - elapsed);
        var keyboard = Keyboard.GetState();
        var movement = Vector2.Zero;
        if (keyboard.IsKeyDown(Keys.W)) movement.Y -= 1;
        if (keyboard.IsKeyDown(Keys.S)) movement.Y += 1;
        if (keyboard.IsKeyDown(Keys.A)) movement.X -= 1;
        if (keyboard.IsKeyDown(Keys.D)) movement.X += 1;
        if (movement != Vector2.Zero)
            movement.Normalize();

        shipPosition += movement * ShipSpeed * elapsed;
        var worldBounds = WorldBounds;
        shipPosition.X = MathHelper.Clamp(shipPosition.X, worldBounds.Left + 42, worldBounds.Right - 42);
        shipPosition.Y = MathHelper.Clamp(shipPosition.Y, worldBounds.Top + 32, worldBounds.Bottom - 32);

        survivalTime += elapsed;
        score = (int)(survivalTime * 100) + scoreFromDestroyedAsteroids;
        var earnedLives = score / PointsPerExtraLife;
        while (awardedLives < earnedLives)
        {
            lives++;
            awardedLives++;
        }

        shotTimer -= elapsed;
        if (state == RunState.Playing && keyboard.IsKeyDown(Keys.Space) && shotTimer <= 0)
        {
            projectiles.Add(new Projectile(shipPosition + new Vector2(32, 0)));
            shotTimer = 0.24f;
        }

        spawnTimer -= elapsed;
        if (spawnTimer <= 0)
        {
            SpawnAsteroid(GetVisibleWorldBounds(worldBounds));
            spawnTimer = (float)(0.75 + random.NextDouble() * 0.55);
        }

        for (var index = asteroids.Count - 1; index >= 0; index--)
        {
            var asteroid = asteroids[index];
            asteroid.Position += asteroid.Velocity * elapsed;
            asteroid.Rotation += asteroid.RotationSpeed * elapsed;
            if (asteroid.Position.X < -64)
                asteroids.RemoveAt(index);
        }

        for (var index = projectiles.Count - 1; index >= 0; index--)
        {
            var projectile = projectiles[index];
            projectile.Position = new Vector2(
                projectile.Position.X + 580 * elapsed,
                projectile.Position.Y);
            if (projectile.Position.X > GetVisibleWorldBounds(worldBounds).Right + 12)
                projectiles.RemoveAt(index);
        }

        UpdateDebris(elapsed);
        CheckProjectileCollisions();
        if (state == RunState.Playing && invulnerabilityTimer <= 0)
            CheckShipCollision();
    }

    private int scoreFromDestroyedAsteroids;

    private void UpdateDeath(float elapsed)
    {
        stateTime += elapsed;
        explosionTimer -= elapsed;
        if (explosionTimer <= 0 && stateTime < DeathDuration)
        {
            PlaySound(explosionSound);
            explosionTimer = 0.58f;
        }

        if (stateTime >= DeathDuration)
        {
            StopAllSounds();
            lives--;
            if (lives <= 0)
            {
                playerName = string.Empty;
                databaseStatus = string.Empty;
                sessionFinishedAt = DateTime.Now;
                state = RunState.NameEntry;
            }
            else
            {
                state = RunState.Restarting;
            }
            stateTime = 0;
        }
    }

    private void SpawnAsteroid(Rectangle bounds)
    {
        var roll = random.Next(100);
        var size = roll < 50
            ? AsteroidSize.Large
            : roll < 80
                ? AsteroidSize.Medium
                : AsteroidSize.Small;
        var top = Math.Max(bounds.Top + 38, WorldBounds.Top + 38);
        var bottom = Math.Min(bounds.Bottom - 38, WorldBounds.Bottom - 38);
        var y = random.Next(top, Math.Max(top + 1, bottom));
        var speed = 155 + (float)random.NextDouble() * 125;
        asteroids.Add(new Asteroid(
            size,
            new Vector2(bounds.Right + 55, y),
            new Vector2(-speed, 0),
            (float)(random.NextDouble() * 4 - 2)));
    }

    private void CheckShipCollision()
    {
        var shipBounds = new Rectangle((int)shipPosition.X - 27, (int)shipPosition.Y - 19, 54, 38);
        foreach (var asteroid in asteroids)
        {
            var radius = asteroid.Size switch
            {
                AsteroidSize.Large => 29,
                AsteroidSize.Medium => 21,
                _ => 15
            };
            if (shipBounds.Intersects(new Rectangle(
                    (int)asteroid.Position.X - radius,
                    (int)asteroid.Position.Y - radius,
                    radius * 2,
                    radius * 2)))
            {
                PlaySound(damageSound);
                hitsRemaining--;
                invulnerabilityTimer = HitInvulnerabilityDuration;
                state = RunState.Damaged;
                stateTime = 0;
                break;
            }
        }
    }

    private void CheckProjectileCollisions()
    {
        for (var bulletIndex = projectiles.Count - 1; bulletIndex >= 0; bulletIndex--)
        {
            var bullet = projectiles[bulletIndex];
            var hitIndex = asteroids.FindIndex(asteroid =>
            {
                var radius = asteroid.Size switch
                {
                    AsteroidSize.Large => 32,
                    AsteroidSize.Medium => 22,
                    _ => 16
                };
                return Vector2.DistanceSquared(asteroid.Position, bullet.Position) < radius * radius;
            });
            if (hitIndex < 0)
                continue;

            var hit = asteroids[hitIndex];
            asteroids.RemoveAt(hitIndex);
            projectiles.RemoveAt(bulletIndex);
            DestroyAsteroid(hit);
        }
    }

    private void DestroyAsteroid(Asteroid asteroid)
    {
        var isLarge = asteroid.Size == AsteroidSize.Large;
        PlaySound(isLarge ? largeAsteroidSound : smallAsteroidSound);

        scoreFromDestroyedAsteroids += asteroid.Size switch
        {
            AsteroidSize.Large => 100,
            AsteroidSize.Medium => 250,
            _ => 400
        };

        var debrisTextures = isLarge ? largeDebris : smallDebris;
        var debrisCount = random.Next(4, 6);
        for (var i = 0; i < debrisCount; i++)
        {
            var angle = (float)(random.NextDouble() * MathHelper.TwoPi);
            var speed = 45 + (float)random.NextDouble() * 90;
            debris.Add(new Debris(
                debrisTextures[random.Next(debrisTextures.Length)],
                asteroid.Position,
                new Vector2(MathF.Cos(angle), MathF.Sin(angle)) * speed));
        }

        if (asteroid.Size == AsteroidSize.Large)
        {
            SpawnChildAsteroids(asteroid.Position, AsteroidSize.Medium, 2);
        }
        else if (asteroid.Size == AsteroidSize.Medium)
        {
            SpawnChildAsteroids(asteroid.Position, AsteroidSize.Small, 2);
        }

        var earnedLives = (survivalTime * 100 + scoreFromDestroyedAsteroids) / PointsPerExtraLife;
        while (awardedLives < earnedLives)
        {
            lives++;
            awardedLives++;
        }
    }

    private void SpawnChildAsteroids(Vector2 position, AsteroidSize size, int count)
    {
        for (var i = 0; i < count; i++)
        {
            var direction = new Vector2(-1, (float)(random.NextDouble() * 1.2 - 0.6));
            direction.Normalize();
            var speed = 180 + (float)random.NextDouble() * 90;
            asteroids.Add(new Asteroid(
                size,
                position,
                direction * speed,
                (float)(random.NextDouble() * 4 - 2)));
        }
    }

    private void UpdateDebris(float elapsed)
    {
        for (var i = debris.Count - 1; i >= 0; i--)
        {
            debris[i].Update(elapsed);
            if (debris[i].Age >= 0.65f)
                debris.RemoveAt(i);
        }
    }

    private void BeginDeath()
    {
        StopAllSounds();
        state = RunState.Dying;
        stateTime = 0;
        explosionTimer = 0;
    }

    private void FinishRunForTesting()
    {
        StopAllSounds();
        sessionFinishedAt = DateTime.Now;
        playerName = string.Empty;
        databaseStatus = "FIN DE PRUEBA";
        asteroids.Clear();
        projectiles.Clear();
        debris.Clear();
        stateTime = 0;
        state = RunState.NameEntry;
    }

    private void RestartGame()
    {
        StopAllSounds();
        lives = InitialLives;
        hitsRemaining = MaxHitsPerLife;
        awardedLives = 0;
        survivalTime = 0;
        scoreFromDestroyedAsteroids = 0;
        score = 0;
        sessionStartedAt = DateTime.Now;
        sessionFinishedAt = default;
        playerName = string.Empty;
        databaseStatus = string.Empty;
        ResetLevel();
    }

    private void ResetLevel()
    {
        asteroids.Clear();
        projectiles.Clear();
        debris.Clear();
        shipPosition = new Vector2(110, WorldBounds.Height / 2f);
        hitsRemaining = MaxHitsPerLife;
        invulnerabilityTimer = 0;
        spawnTimer = 0.5f;
        stateTime = 0;
        state = RunState.Playing;
    }

    protected override void Draw(GameTime gameTime)
    {
        GraphicsDevice.Clear(Color.Black);
        if (state is RunState.Restarting or RunState.NameEntry or RunState.PersonalScore or RunState.Leaderboard)
        {
            spriteBatch.Begin();
            if (state != RunState.Restarting)
                DrawPostDeathScreen(GraphicsDevice.Viewport.Width, GraphicsDevice.Viewport.Height);
            spriteBatch.End();
            base.Draw(gameTime);
            return;
        }

        var viewport = GraphicsDevice.Viewport;
        var cameraCenter = GetCameraCenter(WorldBounds);
        var cameraTransform =
            Matrix.CreateTranslation(-cameraCenter.X, -cameraCenter.Y, 0) *
            Matrix.CreateScale(CameraZoom) *
            Matrix.CreateTranslation(viewport.Width / 2f, viewport.Height / 2f, 0);

        spriteBatch.Begin(samplerState: SamplerState.LinearClamp, transformMatrix: cameraTransform);
        DrawScrollingBackground(GetVisibleWorldBounds(WorldBounds));

        foreach (var asteroid in asteroids)
        {
            var texture = asteroid.Size switch
            {
                AsteroidSize.Large => largeAsteroid,
                AsteroidSize.Medium => mediumAsteroid,
                _ => smallAsteroid
            };
            spriteBatch.Draw(texture, asteroid.Position, null, Color.White, asteroid.Rotation,
                new Vector2(texture.Width / 2f, texture.Height / 2f), 1f, SpriteEffects.None, 0);
        }

        foreach (var shot in projectiles)
            spriteBatch.Draw(pixel, new Rectangle((int)shot.Position.X, (int)shot.Position.Y, 12, 4), Color.Cyan);

        foreach (var item in debris)
        {
            var fade = 1f - item.Age / 0.65f;
            spriteBatch.Draw(item.Texture, item.Position, null, Color.White * fade, item.Rotation,
                new Vector2(item.Texture.Width / 2f, item.Texture.Height / 2f), 1f, SpriteEffects.None, 0);
        }

        DrawShip(gameTime);
        spriteBatch.End();

        spriteBatch.Begin(samplerState: SamplerState.LinearClamp);
        DrawHud(viewport.Width);
        spriteBatch.End();

        base.Draw(gameTime);
    }

    private void DrawPostDeathScreen(int screenWidth, int screenHeight)
    {
        switch (state)
        {
            case RunState.NameEntry:
                DrawCenteredText("FIN DEL JUEGO", screenWidth, 44, 3);
                DrawCenteredText($"PUNTAJE {score}", screenWidth, 120, 3);
                DrawCenteredText($"TIEMPO {survivalTime:F0} SEGUNDOS", screenWidth, 192, 2);
                DrawCenteredText("ESCRIBE TU NOMBRE DE 3 LETRAS", screenWidth, 260, 2);
                DrawCenteredText(playerName.PadRight(3, '_'), screenWidth, 310, 3);
                DrawCenteredText("ENTER GUARDAR PUNTAJE", screenWidth, 390, 2);
                DrawCenteredText(databaseStatus, screenWidth, 432, 1, Color.Orange);
                DrawCenteredText("ESPACIO VOLVER AL JUEGO", screenWidth, 474, 1);
                break;
            case RunState.PersonalScore:
                DrawCenteredText("PUNTAJE PERSONAL", screenWidth, 64, 3);
                DrawCenteredText($"NOMBRE {playerName}", screenWidth, 158, 2);
                DrawCenteredText($"PUNTOS {score}", screenWidth, 218, 3);
                DrawCenteredText($"SUPERVIVENCIA {survivalTime:F0} SEGUNDOS", screenWidth, 294, 2);
                DrawCenteredText(databaseStatus, screenWidth, 330, 1, Color.LightGreen);
                DrawCenteredText("ENTER VER LEADERBOARD", screenWidth, screenHeight - 84, 2);
                DrawCenteredText("ESPACIO VOLVER AL JUEGO", screenWidth, screenHeight - 40, 2);
                break;
            case RunState.Leaderboard:
                DrawCenteredText("LEADERBOARD TOP 10", screenWidth, 30, 3);
                for (var index = 0; index < leaderboard.Count; index++)
                {
                    var entry = leaderboard[index];
                    var row = $"{index + 1}. {entry.Name}  {entry.Score} PTS  {entry.SurvivalSeconds}S";
                    DrawCenteredText(row, screenWidth, 112 + index * 34, 1);
                }
                if (leaderboard.Count == 0)
                    DrawCenteredText("AUN NO HAY PUNTAJES GUARDADOS", screenWidth, 150, 1);
                DrawCenteredText(databaseStatus, screenWidth, screenHeight - 92, 1, Color.LightGreen);
                DrawCenteredText("ENTER VOLVER  ESPACIO REINICIAR", screenWidth, screenHeight - 40, 1);
                break;
        }
    }

    private void DrawScrollingBackground(Rectangle visibleBounds)
    {
        var tileWidth = background.Width;
        var tileHeight = background.Height;
        var startX = MathF.Floor((visibleBounds.Left + backgroundOffset) / tileWidth) * tileWidth - backgroundOffset;
        var startY = MathF.Floor((float)visibleBounds.Top / tileHeight) * tileHeight;

        for (var y = startY; y < visibleBounds.Bottom; y += tileHeight)
        {
            for (var x = startX; x < visibleBounds.Right; x += tileWidth)
                spriteBatch.Draw(background, new Vector2(x, y), Color.White);
        }
    }

    private void DrawCenteredText(string text, int screenWidth, int y, int scale, Color? color = null)
    {
        var x = (screenWidth - GetTextWidth(text, scale)) / 2;
        DrawText(text, x, y, scale, color ?? Color.White);
    }

    private void DrawShip(GameTime gameTime)
    {
        var texture = shipFrames[(int)(gameTime.TotalGameTime.TotalSeconds * 8) % shipFrames.Length];
        var position = shipPosition;
        if (state == RunState.Damaged)
        {
            texture = damageFrames[(int)(gameTime.TotalGameTime.TotalSeconds * 10) % damageFrames.Length];
        }
        else if (state == RunState.Dying)
        {
            texture = deathShip;
            var rise = Math.Min(stateTime / 0.8f, 1f);
            var fallTime = Math.Max(0, stateTime - 0.8f);
            position.Y += -MathF.Sin(rise * MathHelper.Pi) * 18 + fallTime * fallTime * 32;
        }

        spriteBatch.Draw(texture, position, null, Color.White, 0,
            new Vector2(texture.Width / 2f, texture.Height / 2f), 1f, SpriteEffects.None, 0);
    }

    private void DrawHud(int screenWidth)
    {
        DrawText($"PUNTAJE {score}", 18, 14, HudScale);
        var livesText = $"VIDAS {lives}";
        DrawText(livesText, screenWidth - GetTextWidth(livesText, HudScale) - 18, 14, HudScale);
        var hitsText = $"GOLPES {MaxHitsPerLife - hitsRemaining}/{MaxHitsPerLife}";
        DrawText(hitsText, screenWidth - GetTextWidth(hitsText, HudScale) - 18, 82, HudScale);
        DrawText("WASD MOVER", 18, 82, HudScale);
        DrawText("ESPACIO DISPARAR", 18, 150, HudScale);
    }

    private Vector2 GetCameraCenter(Rectangle worldBounds)
    {
        var halfViewWidth = worldBounds.Width / (CameraZoom * 2);
        var halfViewHeight = worldBounds.Height / (CameraZoom * 2);
        return new Vector2(
            MathHelper.Clamp(shipPosition.X, worldBounds.Left + halfViewWidth, worldBounds.Right - halfViewWidth),
            MathHelper.Clamp(shipPosition.Y, worldBounds.Top + halfViewHeight, worldBounds.Bottom - halfViewHeight));
    }

    private Rectangle GetVisibleWorldBounds(Rectangle worldBounds)
    {
        var center = GetCameraCenter(worldBounds);
        var width = (int)(worldBounds.Width / CameraZoom);
        var height = (int)(worldBounds.Height / CameraZoom);
        return new Rectangle(
            (int)(center.X - width / 2f),
            (int)(center.Y - height / 2f),
            width,
            height);
    }

    private void BuildGlyphMap()
    {
        for (var value = 32; value <= 126; value++)
        {
            var index = value - 32;
            glyphs[(char)value] = new Rectangle((index % 16) * 48, (index / 16) * 64, 48, 64);
        }
    }

    private void DrawText(string text, int x, int y, int scale, Color? color = null)
    {
        foreach (var character in text)
        {
            if (!glyphs.TryGetValue(character, out var source))
                continue;
            spriteBatch.Draw(fontAtlas, new Rectangle(x, y, GlyphWidth * scale, 20 * scale), source, color ?? Color.White);
            x += GlyphAdvance * scale;
        }
    }

    private static int GetTextWidth(string text, int scale) =>
        text.Length == 0 ? 0 : (text.Length * GlyphAdvance - (GlyphAdvance - GlyphWidth)) * scale;

    private Texture2D LoadTexture(string name)
    {
        using var stream = File.OpenRead(Path.Combine(AppContext.BaseDirectory, name));
        return Texture2D.FromStream(GraphicsDevice, stream);
    }

    private SoundEffect LoadSound(string name)
    {
        using var stream = File.OpenRead(Path.Combine(AppContext.BaseDirectory, name));
        return SoundEffect.FromStream(stream);
    }

    private void PlaySound(SoundEffect sound)
    {
        var instance = sound.CreateInstance();
        activeSounds.Add(instance);
        instance.Play();
    }

    private void UpdateSounds()
    {
        for (var i = activeSounds.Count - 1; i >= 0; i--)
        {
            if (activeSounds[i].State != SoundState.Stopped)
                continue;
            activeSounds[i].Dispose();
            activeSounds.RemoveAt(i);
        }
    }

    private void StopAllSounds()
    {
        foreach (var sound in activeSounds)
        {
            sound.Stop();
            sound.Dispose();
        }
        activeSounds.Clear();
    }

    protected override void UnloadContent()
    {
        StopAllSounds();
        backgroundMusic?.Stop();
        backgroundMusic?.Dispose();
        backgroundMusicEffect?.Dispose();
        base.UnloadContent();
    }

    private enum RunState
    {
        Playing,
        Damaged,
        Dying,
        Restarting,
        NameEntry,
        PersonalScore,
        Leaderboard
    }

    private enum AsteroidSize
    {
        Large,
        Medium,
        Small
    }

    private sealed class Asteroid(AsteroidSize size, Vector2 position, Vector2 velocity, float rotationSpeed)
    {
        public AsteroidSize Size { get; } = size;
        public Vector2 Position { get; set; } = position;
        public Vector2 Velocity { get; } = velocity;
        public float Rotation { get; set; }
        public float RotationSpeed { get; } = rotationSpeed;
    }

    private sealed class Projectile(Vector2 position)
    {
        public Vector2 Position { get; set; } = position;
    }

    private sealed class Debris(Texture2D texture, Vector2 position, Vector2 velocity)
    {
        public Texture2D Texture { get; } = texture;
        public Vector2 Position { get; private set; } = position;
        public float Rotation { get; private set; }
        public float Age { get; private set; }

        public void Update(float elapsed)
        {
            Age += elapsed;
            Position += velocity * elapsed;
            Rotation += elapsed * 3;
        }
    }
}
