drop database if exists consorcio;
create database consorcio;
use consorcio;

create table edificios (
    id_edif int primary key,
    nombre varchar(50),
    direccion varchar(100)
);

create table unidades (
    id_unidad int primary key,
    nro_piso int,
    id_edif int,
    foreign key (id_edif) references edificios(id_edif)
);

create table expensas (
    id_exp int primary key,
    id_unidad int,
    monto decimal(15,2),
    estado varchar(10),
    foreign key (id_unidad) references unidades(id_unidad)
);


insert into edificios (id_edif, nombre, direccion) values 
(1, 'Edifico 1', 'Pampa'),
(2, 'Edificio 2', 'Av Santa'),
(3, 'Edificio 3', 'Direccion 3'),
(4, 'Edificio 4', 'Monroe'),
(5, 'Edificio 5', 'Forest');

insert unidades (id_unidad, nro_piso, id_edif) values
(101, 1, 1),
(102, 2, 2),
(103, 3, 3),
(104, 4, 4),
(105, 5, 5);

insert into expensas (id_exp, id_unidad, monto, estado) values 
(1, 101, 1500000.00, 'Impago'),
(2, 102, 25000.00, 'Pago'),
(3, 103, 12000.00, 'Pago'),
(4, 104, 30000.00, 'Pago'),
(5, 105, 1100000.00, 'Impago');

select edificios.nombre, sum(expensas.monto) from edificios, unidades, expensas
where edificios.id_edif = unidades.id_edif and unidades.id_unidad = expensas.id_unidad and expensas.estado = 'Impago'
group by edificios.nombre
having sum(expensas.monto) > 1000000 and count(unidades.id_unidad) > 5;

select edificios.nombre, avg(expensas.monto)
from edificios, unidades, expensas
where edificios.id_edif = unidades.id_edif and unidades.id_unidad = expensas.id_unidad and expensas.estado = 'Pago'
group by edificios.nombre
having avg(expensas.monto) >= 20000;

select edificios.nombre, sum(expensas.monto) as recaudacion_total from edificios, unidades, expensas
where edificios.id_edif = unidades.id_edif and unidades.id_unidad = expensas.id_unidad and expensas.estado = 'Pago'
group by edificios.nombre
order by recaudacion_total desc
limit 3;