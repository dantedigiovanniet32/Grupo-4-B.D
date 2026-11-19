SELECT 
    players.nombre,
    asteroidtypes.tamanio AS asteroide,
    collisionlogs.cordenada_impacto,
    collisionlogs.timestamp
FROM players
INNER JOIN sessions ON players.id_player = sessions.id_player
INNER JOIN collisionlogs ON sessions.id_session = collisionlogs.id_session
INNER JOIN asteroidinstances ON collisionlogs.id_asteroid = asteroidinstances.id_asteroid
INNER JOIN asteroidtypes ON asteroidinstances.id_type = asteroidtypes.id_type;
// Como tal este no importa ara el proyecto pero se tiene para simulacion.
