drop database tiendasss;
Create database TIENDASSS;

Use TIENDASSS;

CREATE TABLE Clientes (
  idcliente INT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Vendedores (
  idvendedor INT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Estados (
  idestado INT PRIMARY KEY,
  descripcion VARCHAR(100)
);

CREATE TABLE Facturas (
  idfactura INT PRIMARY KEY,
  tipo VARCHAR(10)
);

CREATE TABLE Productos (
  idproducto INT PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10,2)
);

CREATE TABLE Pedidos (
  idpedido INT PRIMARY KEY,
  idcliente INT,
  idvendedor INT,
  idestado INT,
  idfactura INT,
  fecha DATE,
  FOREIGN KEY (idcliente) REFERENCES Clientes(idcliente),
  FOREIGN KEY (idvendedor) REFERENCES Vendedores(idvendedor),
  FOREIGN KEY (idestado) REFERENCES Estados(idestado),
  FOREIGN KEY (idfactura) REFERENCES Facturas(idfactura)
);
INSERT INTO Clientes VALUES
(1, 'Juan Perez'),
(2, 'Ana Lopez'),
(3, 'Luis Gomez');
INSERT INTO Vendedores VALUES
(1, 'Carlos'),
(2, 'Maria'),
(3, 'Pedro');
INSERT INTO Estados VALUES
(1, 'Pendiente'),
(2, 'Enviado'),
(3, 'Entregado');

INSERT INTO Facturas VALUES
(1, 'A'),
(2, 'B'),
(3, 'C');
INSERT INTO Productos VALUES
(1, 'Remera', 5000),
(2, 'Pantalon', 8000),
(3, 'Campera', 15000);

INSERT INTO Pedidos VALUES
(1, 1, 1, 1, 1, '2026-05-01'),
(2, 2, 2, 2, 2, '2026-05-02'),
(3, 3, 3, 3, 3, '2026-05-03');

Select * from Productos;

SELECT Pedidos.idpedido, Vendedores.nombre
FROM Pedidos, Vendedores
WHERE Pedidos.idvendedor = Vendedores.idvendedor;


CREATE DATABASE Clinica;
USE Clinica;

CREATE TABLE Pacientes (
  idpaciente INT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Especialidades (
  idespecialidad INT PRIMARY KEY,
  tipo VARCHAR(100)
);

CREATE TABLE Medicos (
  idmedico INT PRIMARY KEY,
  nombre VARCHAR(100),
  idespecialidad INT,
  FOREIGN KEY (idespecialidad) REFERENCES Especialidades(idespecialidad)
);

CREATE TABLE Estados (
  idestado INT PRIMARY KEY,
  descripcion VARCHAR(100)
);

CREATE TABLE Turnos (
  idturno INT PRIMARY KEY,
  idpaciente INT,
  idmedico INT,
  fecha iNT,
  hora INT,
  idestado INT,
  FOREIGN KEY (idpaciente) REFERENCES Pacientes(idpaciente),
  FOREIGN KEY (idmedico) REFERENCES Medicos(idmedico),
  FOREIGN KEY (idestado) REFERENCES Estados(idestado)
);


INSERT INTO Pacientes VALUES
(1, 'Juan Perez'),
(2, 'Ana Lopez'),
(3, 'Luis Gomez');
INSERT INTO Especialidades VALUES
(1, 'Pediatria'),
(2, 'Cardiologia'),
(3, 'Dermatologia');
INSERT INTO Medicos VALUES
(1, 'Alvarez', 1),
(2, 'Martinez', 2),
(3, 'Lopez', 3);
INSERT INTO Estados VALUES
(1, 'Pendiente'),
(2, 'Confirmado'),
(3, 'Cancelado');
INSERT INTO Turnos VALUES
(1, 1, 1, '2026-05-10', '10:00:00', 1),
(2, 2, 2, '2026-05-11', '11:00:00', 2),
(3, 3, 3, '2026-05-12', '12:00:00', 3);

SELECT Medicos.nombre, Especialidades.tipo
FROM Medicos, Especialidades
WHERE Medicos.idespecialidad = Especialidades.idespecialidad;

SELECT * FROM Turnos;


CREATE DATABASE Campeonato;
USE Campeonato;
CREATE TABLE Equipos (
  idequipo INT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Posiciones (
  idposicion INT PRIMARY KEY,
  nombre VARCHAR(50)
);

CREATE TABLE Jugadores (
  idjugador INT PRIMARY KEY,
  nombre VARCHAR(100),
  idequipo INT,
  idposicion INT,
  FOREIGN KEY (idequipo) REFERENCES Equipos(idequipo),
  FOREIGN KEY (idposicion) REFERENCES Posiciones(idposicion)
);

CREATE TABLE Estadios (
  idestadio INT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Partidos (
  idpartido INT PRIMARY KEY,
  idequipo1 INT,
  idequipo2 INT,
  fecha DATE,
  goles_equipo1 INT,
  goles_equipo2 INT,
  resultado VARCHAR(20),
  idestadio INT,
  FOREIGN KEY (idequipo1) REFERENCES Equipos(idequipo),
  FOREIGN KEY (idequipo2) REFERENCES Equipos(idequipo),
  FOREIGN KEY (idestadio) REFERENCES Estadios(idestadio)
);

INSERT INTO Equipos VALUES
(1, 'Boca'),
(2, 'River'),
(3, 'Racing');


INSERT INTO Posiciones VALUES
(1, 'Arquero'),
(2, 'Defensa'),
(3, 'Delantero');

INSERT INTO Jugadores VALUES
(1, 'Juan', 1, 1),
(2, 'Pedro', 2, 2),
(3, 'Luis', 3, 3);

INSERT INTO Estadios VALUES
(1, 'La Bombonera'),
(2, 'Monumental'),
(3, 'Cilindro');


INSERT INTO Partidos VALUES
(1, 1, 2, '2026-06-01', 2, 1, 'Gana Equipo1', 1),
(2, 2, 3, '2026-06-02', 0, 0, 'Empate', 2),
(3, 1, 3, '2026-06-03', 1, 3, 'Gana Equipo2', 3);

SELECT * FROM Partidos;

SELECT Jugadores.nombre, Posiciones.nombre
FROM Jugadores, Posiciones
WHERE Jugadores.idposicion = Posiciones.idposicion;

