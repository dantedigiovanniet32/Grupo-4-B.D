drop database if exists asteroid_dodge;
create database asteroid_dodge;

use asteroid_dodge;

drop table if exists poweruplogs;
drop table if exists powerups;
drop table if exists collisionlogs;
drop table if exists dodgerecords;
drop table if exists asteroidinstances;
drop table if exists asteroidtypes;
drop table if exists sessions;
drop table if exists players;

create table players (
id_player int primary key AUTO_INCREMENT,
nombre varchar(100),
puntos int
);

create table sessions (
id_session int primary key AUTO_INCREMENT,
id_player int,
inicio datetime,
fin datetime,
tiempo_supervivencia int,
dificultad_inicial varchar(50),
foreign key (id_player) references players(id_player)
);

create table asteroidtypes (
id_type int primary key AUTO_INCREMENT,
tamanio varchar(50),
velocidad_base float,
sprite varchar(100),
puntos_evasion int
);

create table asteroidinstances (
id_asteroid int primary key AUTO_INCREMENT,
id_session int,
id_type int,
x float,
y float,
velocidad_actual float,
spawn_time datetime,
foreign key (id_session) references sessions(id_session),
foreign key (id_type) references asteroidtypes(id_type)
);

create table dodgerecords (
id_record int primary key AUTO_INCREMENT,
id_session int,
id_asteroid int,
timestamp datetime,
distancia_minima float,
foreign key (id_session) references sessions(id_session),
foreign key (id_asteroid) references asteroidinstances(id_asteroid)
);

create table collisionlogs (
id_collision int primary key AUTO_INCREMENT,
id_session int,
id_asteroid int,
timestamp datetime,
cordenada_impacto varchar(50),
foreign key (id_session) references sessions(id_session),
foreign key (id_asteroid) references asteroidinstances(id_asteroid)
);

create table powerups (
id_powerup int primary key AUTO_INCREMENT,
nombre varchar(100),
efecto varchar(255),
duracion_base float,
probabilidad_spawn float
);

create table poweruplogs (
id_plogs int primary key AUTO_INCREMENT,
id_session int,
id_powerup int,
timestamp_aplicacion datetime,
timestamp_fin datetime,
foreign key (id_session) references sessions(id_session),
foreign key (id_powerup) references powerups(id_powerup)
);

# Inserts

insert into players(nombre, puntos) values
("Vg7", 99999999),
("Wly", 23423467),
("Frg", 94981),
("Mke", 456476),
("Trl", 789997),
("Tim", 4567891),
("Lzu", 123456),
("Stx", 876543);

insert into sessions(id_player, inicio, fin, tiempo_supervivencia, dificultad_inicial) values
(1, '2026-06-01 10:00:00', '2026-06-01 10:01:10', 70, "Dificil"),
(2, '2026-06-01 10:05:00', '2026-06-01 10:06:00', 60, "Normal"),
(3, '2026-06-01 10:10:00', '2026-06-01 10:11:50', 110, "Facil"),
(4, '2026-06-01 10:15:00', '2026-06-01 10:16:00', 60, "Normal"),
(5, '2026-06-01 10:20:00', '2026-06-01 10:20:45', 45, "Normal"),
(6, '2026-06-01 10:25:00', '2026-06-01 10:26:07', 67, "Normal");

insert into asteroidtypes(tamanio, velocidad_base, sprite, puntos_evasion) values
("Pequeño", 5.5, "small_asteroid.png", 10),
("Mediano", 3.5, "medium_asteroid.png", 25),
("Grande", 2.0, "large_asteroid.png", 50),
("Gigante", 1.0, "giant_asteroid.png", 100);

insert into asteroidinstances(id_session, id_type, x, y, velocidad_actual, spawn_time) values
(1, 1, 100.5, 200.0, 6.0, '2026-06-01 10:00:05'),
(1, 2, 300.0, 450.5, 3.5, '2026-06-01 10:00:15'),
(2, 3, 50.0, 150.0, 2.2, '2026-06-01 10:05:10'),
(3, 1, 500.0, 300.0, 5.0, '2026-06-01 10:10:20');

insert into collisionlogs(id_session, id_asteroid, timestamp, cordenada_impacto) values
(1, 1, '2026-06-01 10:01:00', '120.0, 210.0'),
(2, 3, '2026-06-01 10:05:50', '55.0, 160.0'),
(4, 2, '2026-06-01 10:15:40', '310.0, 460.0');

insert into powerups(nombre, efecto, duracion_base, probabilidad_spawn) values
("Escudo", "Invulnerabilidad temporal", 5.0, 0.15),
("Ralentizador", "Reduce la velocidad de los asteroides un 50%", 8.0, 0.10),
("Doble Puntos", "Multiplica los puntos obtenidos por 2", 10.0, 0.05);

insert into poweruplogs(id_session, id_powerup, timestamp_aplicacion, timestamp_fin) values
(1, 1, '2026-06-01 10:00:20', '2026-06-01 10:00:25'),
(1, 3, '2026-06-01 10:00:40', '2026-06-01 10:00:50'),
(3, 2, '2026-06-01 10:10:30', '2026-06-01 10:10:38');


# Consultas

select * from players;

select players.nombre, sessions.id_session, sessions.inicio, sessions.tiempo_supervivencia from sessions
inner join players on sessions.id_player = players.id_player;

# Contar las colisiones de cada sesion
select id_session, count(*) as total_colisiones from collisionlogs
group by id_session;

select dificultad_inicial, avg(tiempo_supervivencia) as promedio_supervivencia 
from sessions 
group by dificultad_inicial;
select nombre, puntos 
from players 
order by puntos desc;

select p.nombre, count(pl.id_plogs) as total_powerups 
from players p 
join sessions s on p.id_player = s.id_player 
left join poweruplogs pl on s.id_session = pl.id_session 
group by p.id_player, p.nombre;
