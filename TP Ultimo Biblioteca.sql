drop database biblioteca;
create database biblioteca;
use biblioteca;
create table autores (
id_autor int primary key,
nombre varchar(100)
);
create table editoriales (
id_editorial int primary key,
nombre varchar(100),
direccion varchar(150),
telefono varchar(20)
);
create table libros (
id_libro int primary key,
titulo varchar(100),
isbn varchar(20),
id_editorial int,
paginas int,
foreign key (id_editorial) references editoriales(id_editorial)
);

create table autor_libro (
id_autor int,
id_libro int,
primary key (id_autor, id_libro),
foreign key (id_autor) references autores(id_autor),
foreign key (id_libro) references libros(id_libro)
);
create table ejemplares (
id_ejemplar int primary key,
ubicacion varchar(100),
id_libro int,
foreign key (id_libro) references libros(id_libro)
);
create table usuarios (
id_usuario int primary key,
nombre varchar(100),
direccion varchar(150),
telefono varchar(20)
);
create table prestamos (
id_usuario int,
id_ejemplar int,
fecha_prestamo date,
fecha_devolucion date,
primary key (id_usuario, id_ejemplar, fecha_prestamo),
foreign key (id_usuario) references usuarios(id_usuario),
foreign key (id_ejemplar) references ejemplares(id_ejemplar)
);
insert into autores (id_autor, nombre) values
(1, 'Juan'),
(2, 'Ana'),
(3, 'Luis'),
(4, 'Sofia'),
(5, 'Pedro');
insert into editoriales (id_editorial, nombre, direccion, telefono) values
(1, 'San Juan', 'ni idea', '26533989'),
(2, 'San Jose', 'Enrique Segoviano', '26234989'),
(3, 'San Joaco', 'Palermo', '26453289'),
(4, 'San Miguel', 'Belgrano', '26532345'),
(5, 'San', 'Monroe', '26000349');
insert into libros (id_libro, titulo, isbn, id_editorial, paginas) values
(1, 'El Viaje', '111', '1', 120),
(2, 'La Historia', '222', '2', 200),
(3, 'Mundo', '333', '3', 300),
(4, 'Camino Largo', '444', '4', 150),
(5, 'Tiempo', '555', '5', 250);

insert into autor_libro (id_autor, id_libro) values
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);
insert into ejemplares (id_ejemplar, ubicacion, id_libro) values
(1, 'A1', 1),
(2, 'B1', 2),
(3, 'C1', 3),
(4, 'D1', 4),
(5, 'E1', 5);
insert into usuarios (id_usuario, nombre, direccion, telefono) values
(1, 'Carlos', 'Calle 1', '111'),
(2, 'Maria', 'Calle 2', '222'),
(3, 'Jose', 'Calle 3', '333'),
(4, 'Laura', 'Calle 4', '444'),
(5, 'Diego', 'Calle 5', '555');
insert into prestamos (id_usuario, id_ejemplar, fecha_prestamo, fecha_devolucion) values
(1,1,'2026-05-01','2026-05-10'),
(2,2,'2026-05-02','2026-05-11'),
(3,3,'2026-05-03','2026-05-12'),
(4,4,'2026-05-04','2026-05-13'),
(5,5,'2026-05-05','2026-05-14');