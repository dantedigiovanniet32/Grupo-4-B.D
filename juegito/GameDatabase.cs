using MySqlConnector;

namespace Asteroides;

internal sealed record LeaderboardEntry(string Name, int Score, int SurvivalSeconds);

internal sealed class GameDatabase
{
    private readonly string connectionString;

    public GameDatabase()
    {
        connectionString = Environment.GetEnvironmentVariable("ASTEROID_DODGE_CONNECTION_STRING")
            ?? throw new InvalidOperationException(
                "Define la variable ASTEROID_DODGE_CONNECTION_STRING para conectar con MySQL.");
        if (string.IsNullOrWhiteSpace(connectionString))
            throw new InvalidOperationException(
                "La variable ASTEROID_DODGE_CONNECTION_STRING esta vacia.");
    }

    public void SaveFinalResult(string name, DateTime startedAt, DateTime finishedAt, int survivalSeconds, int score)
    {
        using var connection = new MySqlConnection(connectionString);
        connection.Open();
        using var transaction = connection.BeginTransaction();

        using var playerCommand = new MySqlCommand(
            "INSERT INTO players (nombre) VALUES (@nombre);",
            connection,
            transaction);
        playerCommand.Parameters.AddWithValue("@nombre", name);
        playerCommand.ExecuteNonQuery();

        using var idCommand = new MySqlCommand("SELECT LAST_INSERT_ID();", connection, transaction);
        var playerId = Convert.ToInt32(idCommand.ExecuteScalar());

        using var sessionCommand = new MySqlCommand(
            """
            INSERT INTO sessions
                (id_player, inicio, fin, tiempo_supervivencia, dificultad_inicial, puntuacion)
            VALUES
                (@id_player, @inicio, @fin, @tiempo, @dificultad, @puntuacion);
            """,
            connection,
            transaction);
        sessionCommand.Parameters.AddWithValue("@id_player", playerId);
        sessionCommand.Parameters.AddWithValue("@inicio", startedAt);
        sessionCommand.Parameters.AddWithValue("@fin", finishedAt);
        sessionCommand.Parameters.AddWithValue("@tiempo", survivalSeconds);
        sessionCommand.Parameters.AddWithValue("@dificultad", "NORMAL");
        sessionCommand.Parameters.AddWithValue("@puntuacion", score);
        sessionCommand.ExecuteNonQuery();

        transaction.Commit();
    }

    public List<LeaderboardEntry> GetLeaderboard(int limit)
    {
        using var connection = new MySqlConnection(connectionString);
        connection.Open();

        using var command = new MySqlCommand(
            """
            SELECT p.nombre, s.puntuacion, s.tiempo_supervivencia
            FROM sessions AS s
            INNER JOIN players AS p ON p.id_player = s.id_player
            ORDER BY s.puntuacion DESC, s.tiempo_supervivencia DESC
            LIMIT @limite;
            """,
            connection);
        command.Parameters.AddWithValue("@limite", limit);

        using var reader = command.ExecuteReader();
        var entries = new List<LeaderboardEntry>();
        while (reader.Read())
        {
            entries.Add(new LeaderboardEntry(
                reader.GetString(0),
                reader.GetInt32(1),
                reader.GetInt32(2)));
        }

        return entries;
    }
}
