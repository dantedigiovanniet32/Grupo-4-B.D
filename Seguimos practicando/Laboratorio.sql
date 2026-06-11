drop database if exists laboratorio;
create database laboratorio;
use laboratorio;

create table laboratorios (
    id_lab int primary key,
    nombre_lab varchar(50),
    pais_origen varchar(50),
    telefono varchar(20)
);

create table medicamentos (
    id_med int primary key,
    nombre_comercial varchar(50),
    monodroga varchar(50),
    precio_venta decimal(10,2),
    id_lab int,
    foreign key (id_lab) references laboratorios(id_lab)
);

create table lotes (
    id_lote int primary key,
    id_med int,
    stock_actual int,
    precio_costo decimal(10,2),
    fecha_vencimiento date,
    ubicacion_gondola varchar(50),
    foreign key (id_med) references medicamentos(id_med)
);

insert into laboratorios (id_lab, nombre_lab, pais_origen, telefono) values
(1, 'Bayer', 'Alemania', '4444-1111'),
(2, 'Pfizer', 'EEUU', '4444-2222'),
(3, 'Roemmers', 'Argentina', '4444-3333'),
(4, 'Bagó', 'Argentina', '4444-4444'),
(5, 'Sanofi', 'Francia', '4444-5555');
insert into medicamentos (id_med, nombre_comercial, monodroga, precio_venta, id_lab) values
(101, 'Aspirina', 'Acido Acetilsalicilico', 500.00, 1),
(102, 'Sertal', 'Propinoxato', 1200.00, 3),
(103, 'Amoxidal', 'Amoxi', 2500.00, 3),
(104, 'Ibupirac', 'Ibuprofeno', 800.00, 2),
(105, 'Lotrial', 'Enalapril', 1500.00, 3);
insert into lotes (id_lote, id_med, stock_actual, precio_costo, fecha_vencimiento, ubicacion_gondola) values
(1001, 101, 50, 200.00, '2026-12-01', 'A1'),
(1002, 102, 30, 450.00, '2025-08-15', 'B2'),
(1003, 103, 100, 900.00, '2027-01-20', 'C3'),
(1004, 104, 20, 300.00, '2026-05-10', 'A2'),
(1005, 105, 80, 600.00, '2025-11-30', 'D4');


select la.nombre_lab as laboratorios, sum(l.stock_actual) as stock_actual from laboratorios la join medicamentos m on la.id_lab = m.id_lab join lotes l on l.id_med = m.id_med 
where YEAR(l.fecha_vencimiento) = 2025 and m.id_med > 100 AND m.id_med < 500 group by la.nombre_lab having SUM(l.Stock_actual) < 200 
order by stock_actual asc limit 5;

select m.nombre_comercial as medicamentos, max(l.stock_actual) as StockMaximo from medicamentos m join lotes l on m.id_med = l.id_med join laboratorios la on m.id_lab = la.id_lab 
where la.nombre_lab like 'A%' or la.nombre_lab like 'B%' group by m.nombre_comercial;

select m.nombre_comercial as medicamentos, m.precio_venta as PrecioVenta, l.precio_costo as PrecioCosto, (m.precio_venta - l.precio_costo) as MargenGanancia 
From medicamentos m join lotes l on m.id_med = l.id_med order by MargenGanancia desc;

select count(*) as CantidadLotes from lotes l join medicamentos m on l.id_med = m.id_med
where l.ubicacion_gondola = 'A-1' and m.monodroga like '%Amoxi%'