create database asteroid_dodge;

use asteroid_dodge;



create table players (
id_player int primary key,
nombre varchar(100)
);

create table sessions (
id_session int primary key,
id_player int,
inicio datetime,
fin datetime,
tiempo_supervivencia int,
dificultad_inicial varchar(50),
foreign key (id_player) references players(id_player)
);

create table asteroidtypes (
id_type int primary key,
tamanio varchar(50),
velocidad_base float,
sprite varchar(100),
puntos_evasion int
);

create table asteroidinstances (
id_asteroid int primary key,
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
id_record int primary key,
id_session int,
id_asteroid int,
timestamp datetime,
distancia_minima float,
foreign key (id_session) references sessions(id_session),
foreign key (id_asteroid) references asteroidinstances(id_asteroid)
);

create table collisionlogs (
id_collision int primary key,
id_session int,
id_asteroid int,
timestamp datetime,
cordenada_impacto varchar(50),
foreign key (id_session) references sessions(id_session),
foreign key (id_asteroid) references asteroidinstances(id_asteroid)
);

create table powerups (
id_powerup int primary key,
nombre varchar(100),
efecto varchar(255),
duracion_base float,
probabilidad_spawn float
);

create table poweruplogs (
id_plogs int primary key,
id_session int,
id_powerup int,
timestamp_aplicacion datetime,
timestamp_fin datetime,
foreign key (id_session) references sessions(id_session),
foreign key (id_powerup) references powerups(id_powerup)
);









#Consultas


  
#Todos los jugadores
  
select * from players;


#Para ver que jugador jugo en cada sessionn

select players.nombre, sessions.id_session, sessions.inicio, sessions.tiempo_supervivencia from sessions
inner join players on sessions.id_player = players.id_player;







# COntar las colisiones de cada sesion

select id_session, count(*) as total_colisiones from collisionlogs
  
group by id_session;



