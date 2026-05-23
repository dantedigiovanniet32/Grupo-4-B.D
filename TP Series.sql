drop database if exists SERIES;
create database SERIES;

use SERIES;

create table generos (
    id_genero int auto_increment primary key,
    tipo varchar(50)
);


create table directores (
    id_director int auto_increment primary key,
    nombre varchar(50),
    edad int(3),
    sueldo int(20)
);



create table plataformas (
    id_plataforma int auto_increment primary key,
    nombre varchar(50),
    precio int(20)
);

create table series (
    id_serie int auto_increment primary key,
    nombre varchar(50),
    anio_lanzamiento int(4),
    presupuesto int(20),
    id_genero int,
    id_plataforma int,
    id_director int,
    foreign key (id_genero) references generos(id_genero),
    foreign key (id_plataforma) references plataformas(id_plataforma),
    foreign key (id_director) references directores(id_director)
);

create table personajes (
    id_personaje int auto_increment primary key,
    nombre varchar(50),
    edad int(3),
    genero enum('Masculino', 'Femenino')
);
create table temporadas (
    id_temporada int auto_increment primary key,
    nombre varchar(50),
    numero int(3),
    descripcion varchar(1000000000),
    id_serie int,
    foreign key (id_serie) references series(id_serie)
);
create table episodios (
    id_episodio int auto_increment primary key,
    numero int,
    nombre varchar(50),
    descripcion varchar(100000000),
    puntuacion decimal(3,1),
    id_temporada int,
    foreign key (id_temporada) references temporadas(id_temporada)
);



create table personajes_episodios (
    id_personaje_episodio int auto_increment primary key,
    id_personaje int,
    id_episodio int,
    foreign key (id_personaje) references personajes(id_personaje),
    foreign key (id_episodio) references episodios(id_episodio)
);

insert into generos(id_genero, tipo) values
(1, 'Sci-fi'),
(2, 'Drama'),
(3, 'Post-apoc'),
(4, 'Accion'),
(5, 'Antologia'),
(6, 'Comedia'),
(7, 'Suspenso'),
(8, 'Intriga');

insert into directores(id_director, nombre, edad, sueldo) values
(121, 'Duffer Brothers', 40, 500000),
(122, 'Christopher Stopher', 43, 350000),
(123, 'Craig Mazin', 53, 900000),
(124, 'Mark Mylod', 59, 750000),
(125, 'Erik Cripke', 50, 400000),
(126, 'Charli Brooker', 53, 300000),
(127, 'Declan Lowney', 63, 450000),
(128, 'Ben Stiller', 58, 800000),
(129, 'Jonathan Nolan', 47, 1200000),
(130, 'Barnabo Odar', 46, 280000);

insert into plataformas(id_plataforma, nombre, precio) values
(1, 'Netflix', 80),
(2, 'Disney plus', 60),
(3, 'Max', 65),
(4, 'Prime video', 60),
(5, 'Apple TV', 30);

insert into series(id_serie, nombre, anio_lanzamiento, presupuesto, id_genero, id_plataforma, id_director) values
(1, 'Stranger Things', 2016, 30000000, 1, 1, 121),
(2, 'The Bear', 2022, 12000000, 2, 2, 122),
(3, 'TLOU', 2023, 100000000, 3, 3, 123),
(4, 'Succesion', 2018, 90000000, 2, 3, 124),
(5, 'The Boys', 2019, 11000000, 4, 4, 125),
(6, 'Black Mirror', 2011, 5000000, 5, 1, 126),
(7, 'Ted Lasso', 2020, 15000000, 6, 5, 127),
(8, 'Severance', 2022, 40000000, 7, 5, 128),
(9, 'Fallout', 2024, 150000000, 1, 4, 129),
(10, 'Dark', 2017, 18000000, 8, 1, 130);

insert into personajes(id_personaje, nombre, edad, genero) values
(1, 'Eleven', 14, 'Femenino'),
(2, 'Carmy Berzatto', 28, 'Masculino'),
(3, 'Joel Miller', 52, 'Masculino'),
(4, 'Ellie Williams', 14, 'Femenino'),
(5, 'Kendall Roy', 40, 'Masculino'),
(6, 'Homelander', 38, 'Masculino'),
(7, 'Ted Lasso', 45, 'Masculino'),
(8, 'Mark Scout', 42, 'Masculino'),
(9, 'Lucy MacLean', 22, 'Femenino'),
(10, 'Jonas Kahnwald', 17, 'Masculino');
insert into temporadas(id_temporada, nombre, numero, descripcion, id_serie) values
(1, 'Stranger Things 1', 1, 'La desaparicion de Will', 1),
(2, 'Stranger Things 4', 2, 'El regreso de Vecna', 1),
(3, 'The Bear S1', 3, 'El caos en la cocina', 2),
(4, 'The Last of Us S1', 4, 'El viaje de Joel y Ellie', 3),
(5, 'Succession S4', 5, 'La guerra final', 4),
(6, 'The Boys S1', 6, 'Los héroes son malos', 5),
(7, 'Black Mirror S1', 7, 'Tecnología y pesadillas', 6),
(8, 'Ted Lasso S1', 8, 'Un DT de fútbol americano en UK', 7),
(9, 'Severance S1', 9, 'Separación cerebral laboral', 8),
(10, 'Fallout S1', 10, 'Salida del refugio 33', 9);

insert into episodios(id_episodio, numero, nombre, descripcion, puntuacion, id_temporada) values
(1, 101, 'El mundo del revés', 'El inicio de todo', 9.2, 1),
(2, 102, 'Dear Billy', 'El escape de Max', 9.8, 2),
(3, 103, 'Sistema', 'El servicio más intenso', 9.5, 3),
(4, 104, 'Mucho tiempo', 'La historia de Bill y Frank', 9.9, 4),
(5, 105, 'Connors Wedding', 'Un giro inesperado', 10.0, 5),
(6, 106, 'El nombre del juego', 'Hughie se une a los Boys', 8.8, 6),
(7, 107, 'Himno Nacional', 'El episodio del primer ministro', 8.1, 7),
(8, 108, 'Piloto', 'Ted llega a Richmond', 8.5, 8),
(9, 109, 'Lo que somos', 'El final de temporada', 9.7, 9),
(10, 110, 'El fin', 'Descubrimientos en el yermo', 9.4, 10);

insert into personajes_episodios(id_personaje_episodio, id_personaje, id_episodio) values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);

select genero, COUNT(*) as cantidad
from personajes
group by genero;

select d.nombre
from directores d, series s, plataformas p
where d.id_director = s.id_director 
  and s.id_plataforma = p.id_plataforma 
  and p.nombre = 'Prime video'
group by d.nombre;

SELECT p.nombre, p.edad
from personajes p, personajes_episodios pe, episodios e, temporadas t, series s, plataformas pl
where p.id_personaje = pe.id_personaje 
  and pe.id_episodio = e.id_episodio 
  and e.id_temporada = t.id_temporada 
  and t.id_serie = s.id_serie 
  and s.id_plataforma = pl.id_plataforma 
  and pl.nombre = 'Disney plus'
group by p.nombre, p.edad
order by p.edad desc;

select s.nombre, count(t.id_temporada) as total_temporadas
from series s, temporadas t
Where s.id_serie = t.id_serie
group bY s.nombre
order by total_temporadas desc
Limit 1;
Select p.nombre
from personajes p, personajes_episodios pe, episodios e, temporadas t, series s
where p.id_personaje = pe.id_personaje 
  and pe.id_episodio = e.id_episodio 
  And e.id_temporada = t.id_temporada 
  and t.id_serie = s.id_serie 
  and s.nombre = 'Hora de Aventura'
Group bY p.nombre;

Select nombre, presupuesto
From series
order by presupuesto desc
limit 1;

select e.nombre, e.puntuacion
from episodios e, temporadas t, series s
where e.id_temporada = t.id_temporada 
  and t.id_serie = s.id_serie 
  and s.anio_lanzamiento <= 2020
Order by e.puntuacion desc
Limit 1;