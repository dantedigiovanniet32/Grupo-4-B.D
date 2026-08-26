drop database if exists carne;
create database carne;
use carne;

create table carniceros(
id_carnicero int primary key auto_increment,
nombre varchar(30),
apellido varchar(30),
dni int(10)
);

create table clientes(
id_cliente int primary key auto_increment,
nombre varchar(30),
telefono int(10),
pago varchar(30)
);

create table pedidos(
id_pedido int primary key auto_increment,
corte varchar(30),
precio decimal(10,2),
id_carnicero int,
id_cliente int,
foreign key (id_carnicero) references carniceros(id_carnicero),
foreign key (id_cliente) references clientes(id_cliente)
);


insert into carniceros(id_carnicero, nombre, apellido, dni) values
(1, 'leol', 'nose', 1213193),
(2, 'alvarez', 'noel', 121342343),
(3, 'loco', 'naic', 121356789);
insert into clientes(id_cliente, nombre, telefono, pago) values
(10, 'cleinte1', 123456, 'efectivo'),
(12, 'cliente2', 2467865, 'efectivo'),
(13, 'cliente3', 2939849, 'debito');
insert into pedidos(id_pedido, corte, precio, id_carnicero, id_cliente) values
(15, 'canre', 1213, 3, 10),
(16, 'pellejo', 1234, 2, 13),
(17, 'pechuga', 984, 3, 13);


-- a)

select max(precio)
from pedidos;

-- b)
select clientes.nombre, count(pedidos.id_pedido) as total_compras
from clientes, pedidos
where clientes.id_cliente = pedidos.id_cliente
group by clientes.nombre
order by total_compras desc
limit 1;

-- c)
select carniceros.nombre, count(pedidos.id_pedido) as total_atendido
from carniceros, pedidos
where carniceros.id_carnicero = pedidos.id_carnicero
group by carniceros.nombre
order by total_atendido desc
limit 1;

-- d) 
select clientes.nombre as nombre_cliente, pedidos.corte as contenido_pedido, carniceros.nombre as nombre_carnicero
from clientes, pedidos, carniceros
where clientes.id_cliente = pedidos.id_cliente and carniceros.id_carnicero = pedidos.id_carnicero
order by pedidos.precio desc
limit 1;

-- e)

select corte as nombre_pedido, count(id_pedido) as total_vendidos
from pedidos
group by corte;