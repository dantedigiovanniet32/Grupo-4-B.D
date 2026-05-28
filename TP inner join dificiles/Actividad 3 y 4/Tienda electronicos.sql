drop database if exists tienda;
create database tienda;

use tienda;

create table categorias (
    id_categoria int primary key,
    nombre_categoria varchar(50)
);

create table productos (
    id_producto int primary key,
    nombre varchar(50),
    precio decimal(10,2),
    id_categoria int,
    foreign key (id_categoria) references categorias(id_categoria)
);

create table detalles_ventas (
    id_detalle int primary key,
    id_producto int,
    cantidad int,
    precio_uni decimal(10,2),
    foreign key (id_producto) references productos(id_producto)
);

insert into categorias (id_categoria, nombre_categoria) values
(1, 'Celulares'),
(2, 'Laptops'),
(3, 'Accesorios'),
(4, 'Monitores'),
(5, 'Cables');

insert into productos (id_producto, nombre, precio, id_categoria) values
(10, 'ifoun', 1200.00, 1),
(11, 'Tablet', 1600.00, 2),
(12, 'Teclado', 15.00, 3),
(13, 'Monitor', 2000.00, 4),
(14, 'HDMI', 12.00, 5);

insert into detalles_ventas (id_detalle, id_producto, cantidad, precio_uni) values
(1, 10, 600, 1200.00),
(2, 11, 15, 1600.00),
(3, 12, 100, 15.00),
(4, 13, 20, 2000.00),
(5, 14, 50, 12.00);

select categorias.nombre_categoria, productos.nombre, sum(detalles_ventas.cantidad) as total_vendido
from categorias, productos, detalles_ventas
where categorias.id_categoria = productos.id_categoria
and productos.id_producto = detalles_ventas.id_producto
group by categorias.nombre_categoria, productos.nombre
having sum(detalles_ventas.cantidad) > 500
order by total_vendido desc
limit 1;

select categorias.nombre_categoria, avg(productos.precio) as promedio, sum(detalles_ventas.cantidad) as total_unidades
from categorias, productos, detalles_ventas
where categorias.id_categoria = productos.id_categoria
and productos.id_producto = detalles_ventas.id_producto
group by categorias.nombre_categoria
having avg(productos.precio) > 1500
and sum(detalles_ventas.cantidad) >= 10;


select categorias.nombre_categoria, sum(detalles_ventas.cantidad * detalles_ventas.precio_uni) as recaudacion
from categorias, productos, detalles_ventas
where categorias.id_categoria = productos.id_categoria
and productos.id_producto = detalles_ventas.id_producto
and productos.precio < 100
group by categorias.nombre_categoria
having sum(detalles_ventas.cantidad * detalles_ventas.precio_uni) < 5000;