using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace AsteroidDodge;

public class Game1 : Game
{
    GraphicsDeviceManager graphics;
    SpriteBatch spriteBatch;
    Texture2D fondoImg;
    Texture2D spritesheet;
    Texture2D pixel; // un  pixel  blanco  para  las  letras  nomas

    Rectangle nave;
    Rectangle[] asteroide = new Rectangle[20];
    int[] vel = new int[20];
    int[] tipo = new int[20];
    bool[] vivo = new bool[20];
    Rectangle[] fuente = new Rectangle[3];

    Cola cola = new Cola();
    KeyboardState teclas;
    KeyboardState teclasVieja;
    Random random = new Random();

    int vidas = 3;
    int puntos = 0;
    float paso = 0;
    float tiempo = 0;
    float invulnerable = 0;
    bool empezo = false;
    bool termino = false;
    string[] top = new string[5];

    public Game1()
    {
        graphics = new GraphicsDeviceManager(this);
        graphics.PreferredBackBufferWidth = 800;
        graphics.PreferredBackBufferHeight = 600;
    }

    protected override void LoadContent()
    {
        spriteBatch = new SpriteBatch(GraphicsDevice);

        // cargo  el  fondo  y  el  spritesheet  de  kenney  nomas
        using (var archivo = File.OpenRead("assets/fondo_espacio.jpg"))
        {
            fondoImg = Texture2D.FromStream(GraphicsDevice, archivo);
        }
        using (var archivo = File.OpenRead("assets/spritesheet.png"))
        {
            spritesheet = Texture2D.FromStream(GraphicsDevice, archivo);
        }

        // estos  numeros  son  los  recortes  del  spritesheet  de  kenney
        fuente[0] = new Rectangle(224, 664, 101, 84); // grande
        fuente[1] = new Rectangle(651, 447, 43, 43);  // mediano
        fuente[2] = new Rectangle(406, 234, 28, 28);  // chico

        pixel = new Texture2D(GraphicsDevice, 1, 1);
        pixel.SetData(new[] { Color.White });

        Archivos.LeerConfig();
        Reset();
        empezo = false;
    }

    void Reset()
    {
        nave = new Rectangle(350, 500, 60, 45);
        vidas = 3;
        puntos = 0;
        paso = 0;
        tiempo = 0;
        invulnerable = 0;
        termino = false;
        empezo = true;
        top = new string[5];
        cola = new Cola();
        for (int i = 0; i < asteroide.Length; i++) vivo[i] = false;
    }

    protected override void Update(GameTime gameTime)
    {
        teclas = Keyboard.GetState();
        if (teclas.IsKeyDown(Keys.Escape)) Exit();

        if (termino)
        {
            if (teclas.IsKeyDown(Keys.Enter) && teclasVieja.IsKeyUp(Keys.Enter)) Reset();
            teclasVieja = teclas;
            return;
        }

        if (!empezo)
        {
            if (teclas.IsKeyDown(Keys.Enter)) empezo = true;
            return;
        }

        float dt = (float)gameTime.ElapsedGameTime.TotalSeconds;
        tiempo += dt;
        if (invulnerable > 0) invulnerable -= dt;

        // movimiento  mismo  del  repo  de  sonic,  con  flechas
        if (teclas.IsKeyDown(Keys.Left)) nave.X -= 5;
        if (teclas.IsKeyDown(Keys.Right)) nave.X += 5;
        if (teclas.IsKeyDown(Keys.Up)) nave.Y -= 5;
        if (teclas.IsKeyDown(Keys.Down)) nave.Y += 5;
        nave.X = MathHelper.Clamp(nave.X, 0, 800 - nave.Width);
        nave.Y = MathHelper.Clamp(nave.Y, 0, 600 - nave.Height);

        // si  quedan  pocos  pedidos  cargo  la  cola  de  nuevo
        if (cola.Cantidad < 4)
        {
            for (int i = 0; i < 8; i++)
            {
                cola.Poner(random.Next(20, 760), random.Next(0, 3));
            }
        }

        // cada  un  rato  saco  un  pedido  y  hago  un  asteroide
        // arranca  mas  rapido  para  que  sea  mas  dificil  nomas
        paso += dt;
        if (paso > 0.45f)
        {
            paso = 0;
            if (cola.Sacar(out int px, out int ptipo))
            {
                for (int i = 0; i < asteroide.Length; i++)
                {
                    if (vivo[i]) continue;
                    int size = ptipo == 0 ? 55 : ptipo == 1 ? 35 : 22;
                    asteroide[i] = new Rectangle(px, -size, size, size);
                    tipo[i] = ptipo;
                    vel[i] = 150 + ptipo * 60;
                    vivo[i] = true;
                    break;
                }
            }
        }

        for (int i = 0; i < asteroide.Length; i++)
        {
            if (!vivo[i]) continue;
            asteroide[i].Y += (int)(vel[i] * dt);

            // se  fue  abajo,  entonces  lo  esquive  y  sumo  puntos
            if (asteroide[i].Y > 600)
            {
                puntos += 5 + tipo[i] * 5;
                vivo[i] = false;
                continue;
            }

            // choque,  saco  una  vida
            if (invulnerable <= 0 && asteroide[i].Intersects(nave))
            {
                vivo[i] = false;
                vidas--;
                invulnerable = 1f;
                if (vidas <= 0)
                {
                    termino = true;
                    Archivos.GuardarPuntaje(puntos);
                    top = Archivos.Top5();
                }
            }
        }
    }

    protected override void Draw(GameTime gameTime)
    {
        GraphicsDevice.Clear(Color.CornflowerBlue);
        spriteBatch.Begin();

        // el  fondo  se  estira  a  toda  la  pantalla
        spriteBatch.Draw(fondoImg, new Rectangle(0, 0, 800, 600), Color.White);

        for (int i = 0; i < asteroide.Length; i++)
        {
            if (vivo[i]) spriteBatch.Draw(spritesheet, asteroide[i], fuente[tipo[i]], Color.White);
        }

        // parpadeo  cuando  me  pegaron
        if (invulnerable <= 0 || (int)(tiempo * 10) % 2 == 0)
        {
            spriteBatch.Draw(spritesheet, nave, new Rectangle(211, 941, 99, 75), Color.White);
        }

        Texto.Dibujar(spriteBatch, pixel, "PUNTOS " + puntos, 20, 20, Color.White);
        Texto.Dibujar(spriteBatch, pixel, "VIDAS " + vidas, 620, 20, Color.White);

        if (!empezo)
        {
            Texto.Dibujar(spriteBatch, pixel, "ENTER PARA EMPEZAR", 230, 280, Color.White);
        }

        if (termino)
        {
            Texto.Dibujar(spriteBatch, pixel, "GAME OVER", 300, 110, Color.White);
            Texto.Dibujar(spriteBatch, pixel, "PUNTOS " + puntos, 300, 150, Color.White);
            Texto.Dibujar(spriteBatch, pixel, "TOP 5", 280, 180, Color.White);
            for (int i = 0; i < 5; i++)
            {
                Texto.Dibujar(spriteBatch, pixel, top[i], 280, 220 + i * 30, Color.White);
            }
            Texto.Dibujar(spriteBatch, pixel, "ENTER PARA VOLVER", 260, 430, Color.White);
        }

        spriteBatch.End();
    }
}


