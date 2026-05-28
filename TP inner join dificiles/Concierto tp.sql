drop database if exists concierto;
create database concierto;
use concierto;

create table Artistas (
id_artista int auto_increment primary key,
nombre varchar(50),
edad int(2) not null
);

create table Albumes (
id_album int auto_increment primary key,
titulo varchar(40),
id_artista int,
foreign key (id_artista) references Artistas(id_artista)
);

create table reproducciones (
id_rep int auto_increment primary key,
cant_rep int(100),
id_album int,
foreign key (id_album) references Albumes(id_album)
);

insert into Artistas (id_artista, nombre, edad) values
( 1, 'Leo122', 25 ),
( 2, 'Leo128', 23 ),
( 3, 'Leo161', 26 ),
( 4, 'Le5745', 66),
( 5, 'Favu21', 21 );

insert into Albumes (id_album, titulo, id_artista) values
( 1, 'Sky', 1),
( 2, 'jsong', 2),
( 3, 'Sy', 2),
( 4, 'S462', 2),
( 5, 'marrio', 5);

insert into reproducciones (id_rep, cant_rep, id_album) values
( 10, 200000, 1),
( 11, 232411, 2),
( 12, 237747, 3),
( 13, 833944, 4),
( 14, 199999, 5);

select artistas.nombre, sum(reproducciones.cant_rep)
from artistas, albumes, reproducciones
where artistas.id_artista = albumes.id_artista and albumes.id_album = reproducciones.id_album
group by artistas.nombre
having count(albumes.id_album) > 3 and sum(reproducciones.cant_rep) > 1000000;


select albumes.titulo, artistas.nombre
from artistas, albumes, reproducciones
where artistas.id_artista = albumes.id_artista and albumes.id_album = reproducciones.id_album
group by albumes.titulo, artistas.nombre
having avg(reproducciones.cant_rep) > 50000;


select artistas.nombre, sum(reproducciones.cant_rep) as total
from artistas, albumes, reproducciones
where artistas.id_artista = albumes.id_artista and albumes.id_album = reproducciones.id_album
group by artistas.nombre
order by total asc
limit 1;
