create database VUELOS;
use VUELOS;

create table aviones (
id_avion int auto_increment primary key,
modelo varchar(50),
capacidad int(10)
);
insert into aviones(modelo, capacidad) values
('Boeign 737', 1200),
('Kratos 142', 320),
('Boeign 224', 50),
('Airbus A320', 150),
('Einstein 787 MAX', 980);



create table paises (
id_pais int auto_increment primary key,
nombre varchar(50)
);
insert into paises (nombre) values
('Francia'),
('Argentina'),
('Alemania'),
('EE.UU.'),
('Sudafrica');

create table lugares (
id_lugar int auto_increment primary key,
nombre varchar(50),
id_pais int,
foreign key (id_pais) references paises(id_pais)
);
insert into lugares (nombre, id_pais) values
('Paris', 1),
('Buenos Aires', 2),
('Muchen', 3),
('Miami', 4),
('Pretoria', 5);

create table vuelos (
id_vuelo int auto_increment primary key,
id_origen int,
id_destino int,
id_avion int,
foreign key (id_origen) references lugares(id_lugar),
foreign key (id_destino) references lugares(id_lugar),
foreign key (id_avion) references aviones(id_avion)
);
insert into vuelos(id_origen, id_destino, id_avion) values
(1, 2, 5),
(5, 3, 4),
(2, 1, 1),
(4, 3, 2),
(3, 4, 1);

create table pasajeros (
id_pasajero int auto_increment primary key,
dni int(8),
nombre varchar(50),
edad int(3)
);
insert into pasajeros (dni, nombre, edad) values
(72894635, 'Martin Zubimendi', 54),
(93627190, 'Pedro Pascal', 99),
(28375017, 'Lionel Merienda', 23),
(92547419, 'Kiosco Gutierrez', 18),
(75893247, 'Teo Montiel', '32');

create table pasajeros_vuelos (
id_ticket int auto_increment primary key,
nmr_ticket int(10),
precio decimal(10, 2),
id_vuelo int,
id_pasajero int,
foreign key (id_vuelo) references vuelos(id_vuelo),
foreign key (id_pasajero) references pasajeros(id_pasajero)
);
insert into pasajeros_vuelos (nmr_ticket, precio, id_vuelo, id_pasajero) values
(235, 98000, 1, 4),
(11, 1500000, 4, 2),
(23, 450000, 5, 1),
(5401, 75000, 3, 3),
(765, 12000, 2, 5);

select aviones.modelo, sum(pasajeros_vuelos.precio) as total
from aviones
inner join vuelos on aviones.id_avion = vuelos.id_avion
inner join pasajeros_vuelos on vuelos.id_vuelo = pasajeros_vuelos.id_vuelo
group by aviones.modelo
having sum(pasajeros_vuelos.precio) > 2000000 and count(pasajeros_vuelos.id_pasajero) > 100;
