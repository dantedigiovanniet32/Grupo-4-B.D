drop database if exists cartoonn;
create database cartoonn;
use cartoonn;

create table series(
idserie int primary key auto_increment,
nombreserie varchar(50),
anioestreno date,
nombrecreador varchar(25)
);

create table personajes(
idpersonaje int primary key auto_increment,
nombrepersonaje varchar(25),
idserie int,
foreign key (idserie) references series(idserie),
rol varchar(25),
nivelenergia int(2)
);

create table episodios(
idepisodio int primary key auto_increment,
tituloepisodio varchar(50),
idserie int,
foreign key (idserie) references series(idserie), 
duracionminutos int(2),
rating decimal(3,1) 
);

create table habilidadesespeciales(
idhabilidad int primary key auto_increment,
idpersonaje int,
foreign key (idpersonaje) references personajes(idpersonaje),
nombrehabilidad varchar(25),
tipohabilidad varchar(25)
);

create table objetosmisticos(
idobjeto int primary key auto_increment,
nombreobjeto varchar(25),
idpersonaje_duenio int,
foreign key (idpersonaje_duenio) references personajes(idpersonaje),
valorsubasta int(10)
);
create table enemigos_historicos (
idrivalidad int primary key auto_increment,
idheroe int,
idvillano int,
encuentrostotales int,
foreign key (idheroe) references personajes(idpersonaje),
foreign key (idvillano) references personajes(idpersonaje)
);

insert into series(nombreserie, anioestreno, nombrecreador) values
("Hora de aventura", '2010-03-11', "Pendleton Ward"),
("Ben 10", '2005-12-27', "Man of Action"),
("Billy y Mandy", '2003-06-13', "Maxwell Atoms"),
("Un show mas", '2010-09-06', "J.G. Quintel"),
("Coraje el Perro Cobarde", '1999-11-12', "John R. Dilworth"),
("El laboratorio de Dexter", '1996-04-28', "Genndy Tartakovsky");

insert into personajes(idpersonaje, nombrepersonaje, idserie, rol, nivelenergia) values
(1, "Finn el humano", 1, "Protagonista", 85),
(2, "Jake el perro", 1, "Protagonista", 90),
(3, "Rey Helado", 1, "Antagonista", 75),
(4, "Ben Tennyson", 2, "Protagonista", 95),
(5, "Vilgax", 2, "Antagonista", 98),
(6, "Puro Hueso", 3, "Secundario", 80),
(7, "Mordecai", 4, "Protagonista", 60),
(8, "Rigby", 4, "Protagonista", 55),
(9, "Coraje", 5, "Protagonista", 40),
(10, "Dexter", 6, "Protagonista", 70);

insert into episodios (idepisodio, tituloepisodio, idserie, duracionminutos, rating) values
(1, 'Isla de las lagrimas', 1, 11, 6.5),
(2, 'Panico en la fiesta', 1, 11, 7.3),
(3, 'Y luego habia 10', 2, 24, 8.2),
(4, 'Caza de primas', 2, 24, 7.3),
(5, 'Solo arma las sillas', 4, 11, 8.6),
(6, 'El teclado magico', 4, 11, 8.6),
(7, 'El Rey Ramses', 5, 11, 8.7),
(8, 'El regreso de Katz', 5, 11, 8.5),
(9, 'El juguete de Dee Dee', 6, 11, 7.8),
(10, 'Complicaciones', 6, 11, 7.5);


insert into habilidadesespeciales(idpersonaje, nombrehabilidad, tipohabilidad) values
(1, "Combate", "Fisica"),
(2, "Estiramiento", "Natural"),
(3, "Hielo", "Magica"),
(4, "Omnitrix", "Tecnologica"),
(5, "Fuerza", "Fisica"),
(6, "Magia", "Magica"),
(7, "Vuelo", "Natural");


insert into objetosmisticos(nombreobjeto, idpersonaje_duenio, valorsubasta) values
("Espada de Pasto", 1, 6000),
("Reloj Omnitrix", 4, 200000),
("Hoz del Destino", 6, 15000),
("Corona Magica", 3, 50000);


insert into enemigos_historicos(idheroe, idvillano, encuentrostotales) values
(1, 3, 25), 
(4, 5, 40); 

-- 1
select nombreserie, nombrecreador 
from series 
order by nombreserie asc;
-- 2
select nombrepersonaje, rol 
from personajes 
where nombrepersonaje like 'b%' or nombrepersonaje like 'f%';
-- 3
select * 
from episodios 
where duracionminutos > 10 and rating > 8.5;

-- 4
select *
from objetosmisticos
where nombreobjeto like '%Espada%' or nombreobjeto like '%Anillo%';

-- 5
select min(nivelenergia), max(nivelenergia) 
from personajes 
where rol = 'antagonista';

-- 6

select tipohabilidad, count(*) 
from habilidadesespeciales 
group by tipohabilidad;

-- 7

select nombrepersonaje, nivelenergia 
from personajes 
order by nivelenergia desc, nombrepersonaje asc;

-- 9

select idpersonaje_duenio, sum(valorsubasta) 
from objetosmisticos 
where valorsubasta > 5000 
group by idpersonaje_duenio 
order by sum(valorsubasta) desc;

-- 9

select idserie, avg(rating) 
from episodios 
group by idserie 
having avg(rating) > 7.5;

-- 10
select idserie, count(*) 
from personajes 
where nivelenergia > 50 
group by idserie;

-- 11

select avg(episodios.duracionminutos) 
from episodios, series 
where episodios.idserie = series.idserie and series.anioestreno > 2010;

-- 12

select idpersonaje, count(*) 
from habilidadesespeciales 
group by idpersonaje 
having count(*) > 3;

-- 13
select * 
from enemigoshistoricos 
where encuentrostotales > 15 
order by encuentrostotales desc;

-- 14

select idpersonaje_duenio, max(valorsubasta) 
from objetosmisticos 
group by idpersonaje_duenio 
having max(valorsubasta) > 100000;

-- 15

select idserie, count(*) 
from episodios 
group by idserie 
order by count(*) desc;
