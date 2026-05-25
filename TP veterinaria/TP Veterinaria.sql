-- 1)
-- a)
-- La PK Es el identificador unico para cada registro, este siendo unico e irrepetible. Se podria decir que sirve para identificar un registro de otro.
-- b) 
-- Un dato es una palabra/caracter/numero sin contexto alguno. Informacion por otro lado, es un conjunto de esos datos agrupados y ordenados de manera que sean comprensibles.
-- 2)
-- A)
-- V.
-- B)
-- F. Significa que 1 registro de la tabla A se puede relacionar con muchos de la tabla B
-- C)
-- F. El software propietario lo que hace es proteger el codigo y no deja que se modifique libremente
-- D)
-- V.

-- 4)
drop database if exists veterinaria;
create database veterinaria;
use veterinaria;

create table duenios (
    id_duenio int primary key,
    nombre varchar(50),
    apellido varchar(50),
    telefono varchar(20),
    dni int(20)
);

create table mascotas (
    id_mascota int auto_increment primary key,
    nombre varchar(50),
    especie varchar(50),
    edad int(20),
    raza varchar(50),
    id_duenio int,
    foreign key (id_duenio) references duenios(id_duenio)
);

create table veterinarios (
    id_veterinario int primary key,
    nombre varchar(50),
    especialidad varchar(50),
    turno varchar(10),
    legajo int(20)
);

create table turnos (
    id_turno int auto_increment primary key,
    fecha date,
    hora time,
    motivo varchar(100),
    id_mascota int,
    id_veterinario int,
    foreign key (id_mascota) references mascotas(id_mascota),
    foreign key (id_veterinario) references veterinarios(id_veterinario)
);


insert into duenios (id_duenio, nombre, apellido, telefono, dni) values
(1, 'Joaco', 'Mar', '4455-6677', 30111222),
(2, 'Ana', 'Alvarez', '4488-9900', 40333444);

insert into mascotas (id_mascota, nombre, especie, edad, raza, id_duenio) values
(1, 'Mano', 'Perro', 5, 'Labrador', 1),
(2, 'Mani', 'Gato', 3, 'Siames', 2);

insert into veterinarios (id_veterinario, nombre, especialidad, turno, legajo) values 
(1, 'Doctor Hous', 'Cirugia', 'Mañana', 101),
(2, 'Doctora Nuse', 'Clinica', 'Tarde', 102);

insert into turnos (fecha, hora, motivo, id_mascota, id_veterinario) values
('2024-05-10', '10:00', 'Vacunacion', 1, 1),
('2024-06-01', '16:30', 'Control', 2, 2);

select * from mascotas;
select nombre, apellido from duenios;
select * from turnos where fecha > '2024-05-01';
