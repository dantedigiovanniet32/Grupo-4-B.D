drop database campeonato;
create database campeonato;
use campeonato;
create table equipos (
idequipo int primary key,
nombre varchar(100)
);
create table posiciones (
idposicion int primary key,
nombre varchar(50)
);
create table jugadores (
idjugador int primary key,
nombre varchar(100),
idequipo int,
idposicion int,
foreign key (idequipo) references equipos(idequipo),
foreign key (idposicion) references posiciones(idposicion)
);
create table estadios (
idestadio int primary key,
nombre varchar(100)
);
create table partidos (
idpartido int primary key,
idequipo1 int,
idequipo2 int,
fecha date,
goles_equipo1 int,
goles_equipo2 int,
resultado varchar(20),
idestadio int,
foreign key (idequipo1) references equipos(idequipo),
foreign key (idequipo2) references equipos(idequipo),
foreign key (idestadio) references estadios(idestadio)
);
insert into equipos (idequipo, nombre) values
(1, 'Boca'),
(2, 'River'),
(3, 'Racing');
insert into posiciones (idposicion, nombre) values
(1, 'Arquero'),
(2, 'Defensa'),
(3, 'Delantero');
insert into jugadores (idjugador, nombre, idequipo, idposicion) values
(1, 'Juan', 1, 1),
(2, 'Pedro', 2, 2),
(3, 'Luis', 3, 3);
insert into estadios (idestadio, nombre) values
(1, 'La Bombonera'),
(2, 'Monumental'),
(3, 'Cilindro');
insert into partidos (idpartido, idequipo1, idequipo2, fecha, goles_equipo1, goles_equipo2, resultado, idestadio) values
(1, 1, 2, '2026-06-01', 2, 1, 'Gana Equipo1', 1),
(2, 2, 3, '2026-06-02', 0, 0, 'Empate', 2),
(3, 1, 3, '2026-06-03', 1, 3, 'Gana Equipo2', 3);
select * from partidos;
select jugadores.nombre, posiciones.nombre
from jugadores, posiciones
where jugadores.idposicion = posiciones.idposicion;