create database GIMNASIO;
use GIMNASIO;

create table socios (
Id_socio int auto_increment primary key,
nombre varchar(100),
fecha_alta date
);

insert into socios (nombre, fecha_alta) values 
('Maria Alvear', '2023-01-10'),
('Marta Minujin', '2021-07-24'),
('Federico Castro', '2019-12-02'),
('Gaston Vasco', '2026-02-28'),
('Mario Lunes', '2014-08-05');

create table planes (
id_plan int auto_increment primary key,
tipo varchar(100),
costo decimal(10,2)
);

insert into planes (tipo, costo) values 
('Basico', 15000),
('Estandar X', 25000),
('Premium', 40000),
('Anual', 120000),
('Premium Extra Mega Plus', 500000);

create table pagos (
id_pago int auto_increment primary key,
monto decimal(10,2),
fecha date,
id_socio int,
id_plan int,
foreign key (id_socio) references socios(id_socio),
foreign key (id_plan) references planes(id_plan)
);

insert into pagos (id_socio, id_plan, monto, fecha) values 
(1, 3, 45000, '2021-09-05'),
(2, 1, 15000, '1990-07-28'),
(3, 2, 25000, '2023-11-30'),
(4, 3, 42000, '2024-12-04'),
(5, 5, 500000, '2026-03-12');

select socios.nombre, count(pagos.id_pago) from socios
join pagos on socios.id_socio = pagos.id_socio
group by socios.id_socio, socios.nombre
having sum(pagos.monto) > (select planes.costo from planes where planes.tipo = 'Premium');



select planes.tipo, sum(pagos.monto) from planes
join pagos on planes.id_plan = pagos.id_plan
group by planes.id_plan, planes.tipo
having count(distinct pagos.id_socio) > 50 and sum(pagos.monto) > 100000;



select socios.nombre from socios
join pagos on socios.id_socio = pagos.id_socio
group by socios.id_socio, socios.nombre, pagos.id_plan
having count(pagos.id_pago) > 3;
