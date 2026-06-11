drop database if exists fg;
create database fg;
use fg;

create table congresos(
idcongreso int primary key not null auto_increment,
tematica varchar(50) not null,
fechainicio date not null,
precioinscripcion int(10) not null
);

create table expositores(
idexpositor int primary key not null auto_increment,
nombre varchar(80) not null,
pais varchar(50) not null,
especialidad varchar(50) not null
);

create table charlas(
idcharla int primary key not null auto_increment,
idcongreso int not null,
idexpositor int not null,
titulocharla varchar(100) not null,
asistentesestimados int(10) not null,
duracionminutos int(10) not null,
foreign key (idcongreso) references congresos(idcongreso),
foreign key (idexpositor) references expositores(idexpositor)
);

insert into congresos(tematica, fechainicio, precioinscripcion) 
values
('Inteligencia Artificial', '2026-03-10', 15000),
('Biotecnologia Avanzada', '2026-04-22', 12000),
('Robotica Avanzada', '2026-05-15', 18000),
('Ciencia de Datos', '2026-06-08', 10000),
('Inteligencia Computacional', '2026-07-19', 20000);

insert into expositores(nombre, pais, especialidad) 
values
('Lucas Fernandez', 'Chile', 'Machine Learning'),
('Ana Souza', 'Brasil', 'Bioinformatica'),
('Carlos Ruiz', 'Argentina', 'Robotica'),
('Maria Oliveira', 'Brasil', 'Analisis de Datos'),
('Pablo Moreno', 'Chile', 'Redes Neuronales');

insert into charlas(idcongreso, idexpositor, titulocharla, asistentesestimados, duracionminutos) 
values
(1, 1, 'Redes Neuronales Profundas', 150, 90),
(1, 5, 'Aprendizaje por Refuerzo', 120, 75),
(1, 4, 'Modelos de Lenguaje a Gran Escala', 110, 65),
(2, 2, 'Edicion Genomica con CRISPR', 200, 45),
(3, 3, 'Automatizacion Industrial', 80, 30);

select c.tematica, sum(ch.asistentesestimados) as totalasistentes 
from charlas ch join congresos c on ch.idcongreso = c.idcongreso join expositores e on ch.idexpositor = e.idexpositor 
where e.pais in ('Chile', 'Brasil') and ch.asistentesestimados > 100 
group by c.tematica having count(ch.idcharla) > 2;

select e.pais, avg(ch.asistentesestimados) as promedioasistentes 
from charlas ch join congresos c on ch.idcongreso = c.idcongreso join expositores e on ch.idexpositor = e.idexpositor 
where c.tematica = 'Inteligencia Artificial' 
group by e.pais;

select ch.titulocharla, e.nombre as nombreexpositor, ch.duracionminutos 
from charlas ch join expositores e on ch.idexpositor = e.idexpositor 
where ch.duracionminutos > 60 
order by ch.duracionminutos desc;

select tematica, precioinscripcion 
from congresos 
where tematica like '%Avanzada%' or tematica like '%Inteligencia%' 
order by tematica asc;