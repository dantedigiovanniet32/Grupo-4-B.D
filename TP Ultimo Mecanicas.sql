drop database mecanica;
create database mecanica;
use mecanica;
create table clientes (
id_cliente int primary key,
dni varchar(20),
nombre varchar(50),
apellidos varchar(100),
direccion varchar(150),
telefono varchar(20)
);
create table coches (
id_coche int primary key,
matricula varchar(20),
modelo varchar(50),
marca varchar(50),
color varchar(30),
tipo varchar(10),
unidades int,
kilometros int,
id_cliente int,
foreign key (id_cliente) references clientes(id_cliente)
);
create table mecanicos (
id_mecanico int primary key,
dni varchar(20),
nombre varchar(50),
apellidos varchar(100),
fecha_contratacion date,
salario decimal(10,2)
);
create table reparaciones (
id_coche int,
id_mecanico int,
fecha date,
horas int,
primary key (id_coche, id_mecanico, fecha),
foreign key (id_coche) references coches(id_coche),
foreign key (id_mecanico) references mecanicos(id_mecanico)
);
insert into clientes (id_cliente, dni, nombre, apellidos, direccion, telefono) values
(1,'111','juan','perez','calle 1','111'),
(2,'222','ana','lopez','calle 2','222'),
(3,'333','luis','gomez','calle 3','333'),
(4,'444','sofia','diaz','calle 4','444'),
(5,'555','pedro','ruiz','calle 5','555');
insert into coches (id_coche, matricula, modelo, marca, color, tipo, unidades, kilometros, id_cliente) values
(1,'aaa111','modelo1z','tesla','rojo','nuevo',10,0,1),
(2,'bbb222','modelo2dsd','marcaacdc','azul','usado',0,50000,2),
(3,'ccc333','modelo3abc','ferrari','negro','nuevo',5,0,3),
(4,'ddd444','modelo4fur','nose','blanco','usado',0,80000,4),
(5,'eee555','modelo2jfud','gta','gris','nuevo',8,0,5);
insert into mecanicos (id_mecanico, dni, nombre, apellidos, fecha_contratacion, salario) values
(1,'101','carlos','perez','2020-01-01',1000),
(2,'102','maria','lopez','2021-02-01',1200),
(3,'103','jose','gomez','2019-03-01',1100),
(4,'104','laura','diaz','2022-04-01',1300),
(5,'105','diego','ruiz','2023-05-01',1250);
insert into reparaciones (id_coche, id_mecanico, fecha, horas) values
(1,1,'2026-05-01',2),
(2,2,'2026-05-02',3),
(3,3,'2026-05-03',4),
(4,4,'2026-05-04',2),
(5,5,'2026-05-05',5);