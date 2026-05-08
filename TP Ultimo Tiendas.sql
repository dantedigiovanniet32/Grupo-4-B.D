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
