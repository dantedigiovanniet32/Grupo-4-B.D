drop database biblioteca;
CREATE DATABASE Biblioteca;
USE Biblioteca;
CREATE TABLE Autores (
  id_autor INT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Libros (
  id_libro INT PRIMARY KEY,
  titulo VARCHAR(100),
  isbn VARCHAR(20),
  editorial VARCHAR(100),
  paginas INT
);


CREATE TABLE Autor_Libro (
  id_autor INT,
  id_libro INT,
  PRIMARY KEY (id_autor, id_libro),
  FOREIGN KEY (id_autor) REFERENCES Autores(id_autor),
  FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
);

CREATE TABLE Ejemplares (
  id_ejemplar INT PRIMARY KEY,
  ubicacion VARCHAR(100),
  id_libro INT,
  FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
);

CREATE TABLE Usuarios (
  id_usuario INT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150),
  telefono VARCHAR(20)
);

CREATE TABLE Prestamos (
  id_usuario INT,
  id_ejemplar INT,
  fecha_prestamo DATE,
  fecha_devolucion DATE,
  PRIMARY KEY (id_usuario, id_ejemplar, fecha_prestamo),
  FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
  FOREIGN KEY (id_ejemplar) REFERENCES Ejemplares(id_ejemplar)
);
INSERT INTO Autores VALUES
(1, 'Juan'),
(2, 'Ana'),
(3, 'Luis'),
(4, 'Sofia'),
(5, 'Pedro');
INSERT INTO Libros VALUES
(1, 'El Viaje', '111', 'Sur', 120),
(2, 'La Historia', '222', 'Norte', 200),
(3, 'Mundo Azul', '333', 'Este', 300),
(4, 'Camino Largo', '444', 'Oeste', 150),
(5, 'Tiempo Final', '555', 'Central', 250);
INSERT INTO Autor_Libro VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);
INSERT INTO Ejemplares VALUES
(1, 'A1', 1),
(2, 'B1', 2),
(3, 'C1', 3),
(4, 'D1', 4),
(5, 'E1', 5);
INSERT INTO Usuarios VALUES
(1, 'Carlos', 'Calle 1', '111'),
(2, 'Maria', 'Calle 2', '222'),
(3, 'Jose', 'Calle 3', '333'),
(4, 'Laura', 'Calle 4', '444'),
(5, 'Diego', 'Calle 5', '555');
INSERT INTO Prestamos VALUES
(1,1,'2026-05-01','2026-05-10'),
(2,2,'2026-05-02','2026-05-11'),
(3,3,'2026-05-03','2026-05-12'),
(4,4,'2026-05-04','2026-05-13'),
(5,5,'2026-05-05','2026-05-14');

 

drop database mecanica;
CREATE DATABASE Mecanica;
USE Mecanica;
CREATE TABLE Clientes (
  id_cliente INT PRIMARY KEY,
  dni VARCHAR(20),
  nombre VARCHAR(50),
  apellidos VARCHAR(100),
  direccion VARCHAR(150),
  telefono VARCHAR(20)
);

CREATE TABLE Coches (
  id_coche INT PRIMARY KEY,
  matricula VARCHAR(20),
  modelo VARCHAR(50),
  marca VARCHAR(50),
  color VARCHAR(30),
  tipo VARCHAR(10), 
  unidades INT,     
  kilometros INT,   
  id_cliente INT,
  FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Mecanicos (
  id_mecanico INT PRIMARY KEY,
  dni VARCHAR(20),
  nombre VARCHAR(50),
  apellidos VARCHAR(100),
  fecha_contratacion DATE,
  salario DECIMAL(10,2)
);

CREATE TABLE Reparaciones (
  id_coche INT,
  id_mecanico INT,
  fecha DATE,
  horas INT,
  PRIMARY KEY (id_coche, id_mecanico, fecha),
  FOREIGN KEY (id_coche) REFERENCES Coches(id_coche),
  FOREIGN KEY (id_mecanico) REFERENCES Mecanicos(id_mecanico)
);

INSERT INTO Clientes VALUES
(1,'111','Juan','Perez','Calle 1','111'),
(2,'222','Ana','Lopez','Calle 2','222'),
(3,'333','Luis','Gomez','Calle 3','333'),
(4,'444','Sofia','Diaz','Calle 4','444'),
(5,'555','Pedro','Ruiz','Calle 5','555');
INSERT INTO Coches VALUES
(1,'AAA111','Modelo1Z','TESLA','Rojo','nuevo',10,NULL,1),
(2,'BBB222','Modelo2DSD','MarcaACDC','Azul','usado',NULL,50000,2),
(3,'CCC333','Modelo3ABC','FERRARI','Negro','nuevo',5,NULL,3),
(4,'DDD444','Modelo4FUR','NOSE','Blanco','usado',NULL,80000,4),
(5,'EEE555','Modelo2JFUD','GTA','Gris','nuevo',8,NULL,5);
INSERT INTO Mecanicos VALUES
(1,'101','Carlos','Perez','2020-01-01',1000),
(2,'102','Maria','Lopez','2021-02-01',1200),
(3,'103','Jose','Gomez','2019-03-01',1100),
(4,'104','Laura','Diaz','2022-04-01',1300),
(5,'105','Diego','Ruiz','2023-05-01',1250);
INSERT INTO Reparaciones VALUES
(1,1,'2026-05-01',2),
(2,2,'2026-05-02',3),
(3,3,'2026-05-03',4),
(4,4,'2026-05-04',2),
(5,5,'2026-05-05',5);
 



drop database Liga;
CREATE DATABASE Liga;
USE Liga;

CREATE TABLE Equipos (
  id_equipo INT PRIMARY KEY,
  nombre VARCHAR(100),
  estadio VARCHAR(100),
  anio_fundacion INT,
  ciudad VARCHAR(100)
);

CREATE TABLE Jugadores (
  id_jugador INT PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  fecha_nacimiento DATE,
  posicion VARCHAR(50),
  id_equipo INT,
  FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo)
);

CREATE TABLE Presidentes (
  id_presidente INT PRIMARY KEY,
  dni VARCHAR(20),
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  fecha_nacimiento DATE,
  id_equipo INT UNIQUE,
  anio_eleccion INT,
  FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo)
);

CREATE TABLE Partidos (
  id_partido INT PRIMARY KEY,
  id_equipo_local INT,
  id_equipo_visitante INT,
  fecha DATE,
  goles_local INT,
  goles_visitante INT,
  FOREIGN KEY (id_equipo_local) REFERENCES Equipos(id_equipo),
  FOREIGN KEY (id_equipo_visitante) REFERENCES Equipos(id_equipo)
);

CREATE TABLE Goles (
  id_gol INT PRIMARY KEY,
  id_partido INT,
  id_jugador INT,
  minuto INT,
  descripcion VARCHAR(100),
  FOREIGN KEY (id_partido) REFERENCES Partidos(id_partido),
  FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador)
);

INSERT INTO Equipos VALUES
(1,'Equipo1','Estadio1',2000,'Ciudad1'),
(2,'Equipo2','Estadio2',2001,'Ciudad2'),
(3,'Equipo3','Estadio3',2002,'Ciudad3'),
(4,'Equipo4','Estadio4',2003,'Ciudad4'),
(5,'Equipo5','Estadio5',2004,'Ciudad5');

INSERT INTO Jugadores VALUES
(1,'Juan','A','2000-01-01','Delantero',1),
(2,'Luis','B','2001-02-02','Defensor',2),
(3,'Pedro','C','2002-03-03','Arquero',3),
(4,'Ana','D','2003-04-04','Mediocampo',4),
(5,'Sofia','E','2004-05-05','Delantero',5);

INSERT INTO Presidentes VALUES
(1,'101','Carlos','A','1980-01-01',1,2020),
(2,'102','Maria','B','1981-02-02',2,2021),
(3,'103','Jose','C','1982-03-03',3,2022),
(4,'104','Laura','D','1983-04-04',4,2023),
(5,'105','Diego','E','1984-05-05',5,2024);

INSERT INTO Partidos VALUES
(1,1,2,'2026-06-01',2,1),
(2,2,3,'2026-06-02',0,0),
(3,3,4,'2026-06-03',1,2),
(4,4,5,'2026-06-04',3,1),
(5,1,5,'2026-06-05',2,2);

INSERT INTO Goles VALUES
(1,1,1,10,'Gol 1'),
(2,1,2,20,'Gol 2'),
(3,3,3,30,'Gol 3'),
(4,4,4,40,'Gol 4'),
(5,5,5,50,'Gol 5');



 

