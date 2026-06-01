create database DELIVERY;
use DELIVERY;


create table restaurantes (
id_rest int auto_increment primary key,
nombre varchar(50),
zona varchar(50)
);
insert into restaurantes(nombre, zona) values
('La continental', 'Villa Crespo'),
('El cuartito', 'Microcentro'),
('Sushi pop', 'Caballito'),
('Osaka', 'Palermo'),
('Parrilla lo de pancho', 'Moron');




create table platos (
id_plato int auto_increment primary key,
nombre varchar(100),
precio decimal(10, 2),
id_rest int,
foreign key (id_rest) references restaurantes(id_rest)
);

insert into platos (nombre, precio, id_rest) values
('Pizza', 7500, 1),
('Empanada de pollo', 600, 2),
('Nigiri', 1200, 3),
('Arancini con pistacho', 54000, 4),
('Choripan', 1400, 5);


create table pedidos (
id_ped int auto_increment primary key,
cantidad int(10),
id_plato int,
foreign key (id_plato) references platos(id_plato)
);
insert into pedidos (id_plato, cantidad) values
(1, 3),
(2, 13),
(3, 2),
(4, 1),
(5, 8);






#1
select restaurantes.nombre, count(platos.id_plato) as total_platos, sum(pedidos.cantidad) as total_ventas from restaurantes

inner join platos on restaurantes.id_rest = platos.id_rest
inner join pedidos on platos.id_plato = pedidos.id_plato

group by restaurantes.nombre;


#2
select restaurantes.nombre, avg(platos.precio * pedidos.cantidad) as promedio_ingresos from restaurantes

inner join platos on restaurantes.id_rest = platos.id_rest
inner join pedidos on platos.id_plato = pedidos.id_plato

where platos.precio > 1500 group by restaurantes.nombre;

#3
select platos.nombre as nombre_plato, sum(pedidos.cantidad) as total_vendido from restaurantes

inner join platos on restaurantes.id_rest = platos.id_rest
inner join pedidos on platos.id_plato = pedidos.id_plato

where platos.nombre = 'Pizza' group by platos.nombre
order by total_vendido desc limit 10;