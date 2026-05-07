Create database EMPRESA;
Use EMPRESA;

Create table Empleados (
    IDEmpleado int auto_increment primary key not null,
    Nombre varchar(18),
    Apellido varchar(20) not null,
    Sector enum('Adm', 'Ventas', 'Compras', 'RRHH') not null,
    Edad int(2) default(35) not null,
    Sexo enum('M', 'F') not null,
    Barrio_vivienda varchar(25) default 'Belgrano' not null,
    CodPostal int(4) not null,
    Ingreso year not null,
    Sueldo decimal(10,2) not null,
    Antiguedad decimal(10, 2) default 210.00 not null,
    Celular int(8) not null
    );
    
    
Insert into EMPLEADOS(Nombre, Apellido, Sector, Edad, Sexo, Barrio_vivienda, CodPostal, Ingreso, Sueldo, Antiguedad, Celular)
Values
('Carlos', 'Gomez', 'RRHH', 43, 'M', 'Almagro', 1178, 2011, 85000.50, 500, 1122334455),
('Ana', 'Perez', 'RRHH', 29, 'F', 'Villa_Crespo', 1178, 2011, 92000.00, 450, 1133445566),
('Luis', 'Rodriguez', 'Adm', 35, 'M', 'Flores', 1406, 2011, 78000.00, 300, 1144556677),
('Marta', 'Sánchez', 'Ventas', 32, 'F', 'Vicente_Lopez', 1406, 2011, 95000.75, 250, 1155667788),
('Jorge', 'Martinez', 'Adm', 45, 'M', 'Belgrano', 1428, 2011, 110000.00, 600, 1166778899),
('Lucia', 'Fernandez', 'Compras', 29, 'F', 'Villa_Luzuriaga', 1428, 2015, 88000.00, 250, 1177889900),
('Diego', 'Lopez', 'Ventas', 38, 'M', 'Belgrano', 1428, 2018, 92000.50, 400, 1188990011),
('Sofia', 'Diaz', 'Adm', 35, 'F', 'Almagro', 1178, 2020, 75000.00, 250, 1199001122),
('Pabla', 'Garcia', 'RRHH', 50, 'F', 'Flores', 1406, 2012, 105000.00, 800, 1100112233),
('Elena', 'Torres', 'Compras', 42, 'F', 'Almagro', 1178, 2019, 82000.25, 250, 1122112211),
('Raul', 'Ruiz', 'Adm', 31, 'M', 'Flores', 1406, 2022, 70000.00, 250, 1133223344),
('Julia', 'Vazquez', 'Ventas', 27, 'F', 'Chacarita', 1178, 2021, 89000.00, 250, 1144334455),
('Oscar', 'Blanco', 'RRHH', 61, 'M', 'Flores', 1406, 2017, 91000.00, 350, 1155445566),
('Laura', 'Mendez', 'Adm', 33, 'F', 'Belgrano', 1428, 2014, 98000.00, 550, 1166556677),
('Fabián', 'Sosa', 'Ventas', 39, 'M', 'Almagro', 1178, 2016, 84000.00, 250, 1177667788);
#1
Select * from Empleados;

#2
Select Nombre, Apellido from Empleados
where Barrio_vivienda = 'belgrano';

#3
select Apellido, Edad from Empleados
Where Ingreso in (2010, 2011, 2012);

#4
Select count(nombre) from empleados
Where sexo = 'f' and sector = 'rrhh';

#5
Select nombre, apellido, celular from empleados;

#6
Select nombre, apellido, sueldo from Empleados
where Barrio_vivienda = 'almagro' or 'flores'
order by apellido desc;

#7
select count(nombre) from Empleados;

#8
select nombre, apellido from empleados
order by edad asc
limit 1;
select nombre, apellido from empleados
order by edad desc
limit 1;

#9
select avg(edad) from empleados;

#10
select avg(edad) from empleados
where sector = 'rrhh';
