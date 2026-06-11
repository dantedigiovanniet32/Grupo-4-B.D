drop database if exists fg;
create database fg;
use fg;

create table sucursales(
idsucursal int primary key not null auto_increment,
idsucursalorigen int not null,
ciudad varchar(50) not null,
provincia varchar(50) not null,
responsable varchar(80) not null
);

create table paquetes(
idpaquete int primary key not null auto_increment,
peso int(10) not null,
descripcioncontenido varchar(100) not null,
tipoenvio enum('Express', 'Normal') not null,
idsucursalorigen int not null,
foreign key (idsucursalorigen) references sucursales(idsucursal)
);
 
create table envios(
idenvio int primary key not null auto_increment,
idpaquete int not null,
costoenvio int(10) not null,
fechadespacho date not null,
estado enum('Entregado', 'En Camino', 'Devuelto') not null,
foreign key (idpaquete) references paquetes(idpaquete)
); 

use fg;

insert into sucursales (ciudad, provincia, responsable) 
values
('Buenos Aires', 'Buenos Aires', 'Carlos Méndez'),
('Córdoba',      'Córdoba',      'Laura Giménez'),
('Rosario',      'Santa Fe',     'Martín Torres'),
('Mendoza',      'Mendoza',      'Sofía Romero'),
('Tucumán',      'Tucumán',      'Diego Herrera');

insert into paquetes(peso, descripcioncontenido, tipoenvio, idsucursalorigen) 
values
(12.50, 'Caja con electrodomésticos',  'Express', 1),
(5.00,  'Caja con ropa y accesorios',  'Normal',  2),
(30.00, 'Documentos legales urgentes', 'Express', 3),
(8.75,  'Caja con libros escolares',   'Normal',  4),
(45.00, 'Repuestos de maquinaria',     'Express', 5);

insert into envios (idpaquete, costoenvio, fechadespacho, estado) 
values
(1, 75000.00, '2026-05-03', 'Entregado'),
(2,  4500.00, '2026-05-15', 'En Camino'),
(3, 60000.00, '2026-05-22', 'Entregado'),
(4,  6800.00, '2026-04-10', 'En Camino'),
(5, 95000.00, '2026-05-30', 'Devuelto');

use fg;
 
select s.ciudad as ciudadorigen, avg(p.peso) as pesopromedio, sum(e.costoenvio) as costoacumulado 
from envios e join paquetes p on e.idpaquete = p.idpaquete join sucursales s on p.idsucursalorigen = s.idsucursalorigen 
where e.estado  = 'Entregado' and p.peso > 1 and p.peso < 50 
group by s.ciudad having sum(e.costoenvio) > 50000;
 
select s.ciudad as ciudadorigen, count(e.idenvio) as totalencamino 
from envios e join paquetes p on e.idpaquete = p.idpaquete join sucursales s on p.idsucursalorigen = s.idsucursal 
where e.estado = 'En Camino' and e.costoenvio > 5000 
group by s.ciudad; 

select p.descripcioncontenido as descripcion, e.costoenvio as costo_envio 
from envios e join paquetes p on e.idpaquete = p.idpaquete join sucursales s on p.idsucursalorigen = s.idsucursal 
where s.provincia  = 'Buenos Aires' and p.tipoenvio = 'Express' 
order by e.costoenvio desc; 

select p.idpaquete, p.descripcioncontenido, p.peso, p.tipoenvio, e.fechadespacho, e.estado, e.costoenvio 
from paquetes p join envios e on p.idpaquete = e.idpaquete 
where p.descripcioncontenido like 'Caja%' and year(e.fechadespacho)  = 2026 and month(e.fechadespacho) = 5;