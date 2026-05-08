drop database liga;
create database liga;
use liga;
create table equipos (
id_equipo int primary key,
nombre varchar(100),
estadio varchar(100),
anio_fundacion int,
ciudad varchar(100)
);
create table jugadores (
id_jugador int primary key,
nombre varchar(50),
apellido varchar(50),
fecha_nacimiento date,
posicion varchar(50),
id_equipo int,
foreign key (id_equipo) references equipos(id_equipo)
);
create table presidentes (
id_presidente int primary key,
dni varchar(20),
nombre varchar(50),
apellido varchar(50),
fecha_nacimiento date,
id_equipo int unique,
anio_eleccion int,
foreign key (id_equipo) references equipos(id_equipo)
);
create table partidos (
id_partido int primary key,
id_equipo_local int,
id_equipo_visitante int,
fecha date,
goles_local int,
goles_visitante int,
foreign key (id_equipo_local) references equipos(id_equipo),
foreign key (id_equipo_visitante) references equipos(id_equipo)
);
create table goles (
id_gol int primary key,
id_partido int,
id_jugador int,
minuto int,
descripcion varchar(100),
foreign key (id_partido) references partidos(id_partido),
foreign key (id_jugador) references jugadores(id_jugador)
);
insert into equipos (id_equipo, nombre, estadio, anio_fundacion, ciudad) values
(1,'equipo1','estadio1',2000,'ciudad1'),
(2,'equipo2','estadio2',2001,'ciudad2'),
(3,'equipo3','estadio3',2002,'ciudad3'),
(4,'equipo4','estadio4',2003,'ciudad4'),
(5,'equipo5','estadio5',2004,'ciudad5');
insert into jugadores (id_jugador, nombre, apellido, fecha_nacimiento, posicion, id_equipo) values
(1,'juan','a','2000-01-01','delantero',1),
(2,'luis','b','2001-02-02','defensor',2),
(3,'pedro','c','2002-03-03','arquero',3),
(4,'ana','d','2003-04-04','mediocampo',4),
(5,'sofia','e','2004-05-05','delantero',5);
insert into presidentes (id_presidente, dni, nombre, apellido, fecha_nacimiento, id_equipo, anio_eleccion) values
(1,'101','carlos','a','1980-01-01',1,2020),
(2,'102','maria','b','1981-02-02',2,2021),
(3,'103','jose','c','1982-03-03',3,2022),
(4,'104','laura','d','1983-04-04',4,2023),
(5,'105','diego','e','1984-05-05',5,2024);
insert into partidos (id_partido, id_equipo_local, id_equipo_visitante, fecha, goles_local, goles_visitante) values
(1,1,2,'2026-06-01',2,1),
(2,2,3,'2026-06-02',0,0),
(3,3,4,'2026-06-03',1,2),
(4,4,5,'2026-06-04',3,1),
(5,1,5,'2026-06-05',2,2);
insert into goles (id_gol, id_partido, id_jugador, minuto, descripcion) values
(1,1,1,10,'gol 1'),
(2,1,2,20,'gol 2'),
(3,3,3,30,'gol 3'),
(4,4,4,40,'gol 4'),
(5,5,5,50,'gol 5');