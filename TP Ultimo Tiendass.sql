drop database tiendasss;
create database tiendasss;
use tiendasss;
create table clientes (
idcliente int primary key,
nombre varchar(100)
);
create table vendedores (
idvendedor int primary key,
nombre varchar(100)
);
create table estados (
idestado int primary key,
descripcion varchar(100)
);
create table facturas (
idfactura int primary key,
tipo varchar(10)
);
create table productos (
idproducto int primary key,
nombre varchar(100),
precio decimal(10,2)
);
create table pedidos (
idpedido int primary key,
idcliente int,
idvendedor int,
idestado int,
idfactura int,
fecha date,
foreign key (idcliente) references clientes(idcliente),
foreign key (idvendedor) references vendedores(idvendedor),
foreign key (idestado) references estados(idestado),
foreign key (idfactura) references facturas(idfactura)
);
insert into clientes (idcliente, nombre) values
(1, 'Juan Perez'),
(2, 'Ana Lopez'),
(3, 'Luis Gomez');
insert into vendedores (idvendedor, nombre) values
(1, 'Carlos'),
(2, 'Maria'),
(3, 'Pedro');
insert into estados (idestado, descripcion) values
(1, 'Pendiente'),
(2, 'Enviado'),
(3, 'Entregado');
insert into facturas (idfactura, tipo) values
(1, 'A'),
(2, 'B'),
(3, 'C');
insert into productos (idproducto, nombre, precio) values
(1, 'Remera', 5000),
(2, 'Pantalon', 8000),
(3, 'Campera', 15000);
insert into pedidos (idpedido, idcliente, idvendedor, idestado, idfactura, fecha) values
(1, 1, 1, 1, 1, '2026-05-01'),
(2, 2, 2, 2, 2, '2026-05-02'),
(3, 3, 3, 3, 3, '2026-05-03');
select * from productos;
select pedidos.idpedido, vendedores.nombre
from pedidos, vendedores
where pedidos.idvendedor = vendedores.idvendedor;