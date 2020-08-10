CREATE DATABASE if not exists G1;
use g1;
CREATE TABLE if not exists Persona
(
	cedula VARCHAR(12) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL, 
    apellido_paterno VARCHAR(20) NOT NULL ,
    apellido_materno VARCHAR(20) NOT NULL,
    direccion VARCHAR(100) NOT NULL
);

CREATE TABLE if not exists Persona_Telefonos
(
	numero VARCHAR(20) PRIMARY KEY,
    id_persona VARCHAR(12) NOT NULL, 
    FOREIGN KEY(id_persona) references Persona(cedula)
);

CREATE TABLE if not exists Persona_Correos
(
	correo VARCHAR(30) PRIMARY KEY, 
    id_persona VARCHAR(12) NOT NULL,
    FOREIGN KEY(id_persona) references Persona(cedula)
);

CREATE TABLE if not exists Farmacia
(
	id_farmacia INT PRIMARY KEY,
	id_jefe VARCHAR(12) NOT NULL,
	foreign key(id_jefe) references Persona(cedula)
);

CREATE TABLE if not exists Localidad
(
	id_farmacia INT PRIMARY KEY,
    calle_principal VARCHAR(30) NOT NULL, 
    calle_secundaria VARCHAR(30) NOT NULL, 
    canton VARCHAR(30) NOT NULL,
    provincia VARCHAR(30) NOT NULL, 
	referencia VARCHAR(100) NOT NULL,
    foreign key(id_farmacia) references Farmacia(id_farmacia)
);

CREATE TABLE if not exists Empleado_Farmacia
(
	id_empleado VARCHAR(12) PRIMARY KEY,
    id_farmacia INT NOT NULL, 
    sueldo decimal(10,4) NOT NULL,
    FOREIGN KEY(id_empleado) references Persona(cedula),
    FOREIGN KEY(id_farmacia) references Farmacia(id_farmacia)
);
    
CREATE TABLE if not exists Medicamento
(
	id_medicamento INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
	precio_unitario DECIMAL(10,2) NOT NULL 
);
    
CREATE TABLE if not exists Unidad_Medicamento
(
	id_medicamento INT NOT NULL, 
    numero_serie INT PRIMARY KEY, 
    fecha_caducidad Date,
    FOREIGN KEY(id_medicamento) references Medicamento(id_medicamento)
);

CREATE TABLE if not exists Categoria
(
	id_categoria INT PRIMARY KEY, 
	nombre VARCHAR(50) NOT NULL, 
	descripcion VARCHAR(100) NOT NULL
);

CREATE TABLE if not exists Categoria_Medicamento
(
	id_categoria INT,
    id_medicamento INT,
    PRIMARY KEY(id_categoria, id_medicamento),
    FOREIGN KEY (id_categoria) references Categoria(id_categoria),
    FOREIGN KEY (id_medicamento) references Medicamento(id_medicamento)
);

CREATE TABLE if not exists Cliente
(
	id_cliente VARCHAR(12) PRIMARY KEY 
);

CREATE TABLE if not exists Factura
(
	id_factura INT PRIMARY KEY,
    id_empleado VARCHAR(12) NOT NULL,
    id_cliente VARCHAR(12) NOT NULL, 
    fecha Date NOT NULL, 
    total DECIMAL(6,2) NOT NULL,
    IVA INT NOT NULL, 
    FOREIGN KEY (id_empleado) references Empleado_Farmacia(id_empleado),
    FOREIGN KEY (id_cliente) references Cliente(id_cliente)
);

CREATE TABLE if not exists Venta_Unidad_Medicamento
(
	id_venta_med INT PRIMARY KEY,
    id_factura INT NOT NULL,
    unidad_medicamento INT NOT NULL,
    FOREIGN KEY(id_factura) references Factura(id_factura),
    FOREIGN KEY(unidad_medicamento) references Unidad_Medicamento(id_medicamento)
    );

CREATE TABLE if not exists Stock_Farmacia_Medicamento
(
	id_farmacia INT,
    id_unidad_medicamento INT,
    stock_minimo INT NOT NULL,
    stock_actual INT NOT NULL, 
    PRIMARY KEY(id_farmacia, id_unidad_medicamento),
    FOREIGN KEY(id_farmacia) references Farmacia(id_farmacia),
    FOREIGN KEY(id_unidad_medicamento) references Unidad_Medicamento(id_medicamento) 
);

CREATE TABLE if not exists Bodega
(
	id_bodega INT PRIMARY KEY, 
    id_admin VARCHAR(12) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    FOREIGN KEY(id_admin) references Persona(cedula)
);

CREATE TABLE if not exists Bodeguero
(
	id_bodeguero VARCHAR(12) PRIMARY KEY,
    id_bodega INT NOT NULL,
    FOREIGN KEY(id_bodeguero) references Persona(cedula),
    FOREIGN KEY(id_bodega) references Bodega(id_bodega)
);

CREATE TABLE if not exists Bodega_unidad_medicamento
(
	id_unidad_medicamento INT,
    id_bodega INT, 
    PRIMARY KEY(id_unidad_medicamento, id_bodega),
    FOREIGN KEY(id_unidad_medicamento) references Unidad_Medicamento(numero_serie),
    FOREIGN KEY(id_bodega) references Bodega(id_bodega)
);

CREATE TABLE if not exists Registro
(
	id_registro INT PRIMARY KEY, 
	id_bodeguero VARCHAR(12) NOT NULL, 
	fecha_solicitud date  NOT NULL,
	justificativo VARCHAR(100) NOT NULL,
	FOREIGN KEY (id_bodeguero) references Bodeguero(id_bodeguero)
);

CREATE TABLE  if not exists Ingreso
(
	id_ingreso INT PRIMARY KEY,
	id_admin_bodega VARCHAR(12) NOT NULL, 
	FOREIGN KEY (id_ingreso) references Registro(id_registro),
	FOREIGN KEY (id_admin_bodega) references Persona(cedula)
);

CREATE TABLE if not exists Egreso
(
	id_egreso INT PRIMARY KEY,
	farmacia_destino INT,
	solicitante VARCHAR (12) NOT NULL,
	fecha_egreso date NOT NULL,
	FOREIGN KEY(id_egreso) references Registro(id_registro), 
	FOREIGN KEY(farmacia_destino) references Farmacia(id_farmacia),
	FOREIGN KEY (solicitante) references Persona(cedula)
);

CREATE TABLE if not exists Ingreso_Bodega_Unidad
(
    id_ingreso INT,
    numero_serie INT, 
    cantidad INT NOT NULL,
    PRIMARY KEY(id_ingreso, numero_serie),
    FOREIGN KEY(id_ingreso) references Ingreso(id_ingreso),
    FOREIGN KEY(numero_serie) references Unidad_Medicamento(numero_serie)
);

CREATE TABLE if not exists Egreso_Bodega_Unidad
(
	id_egreso INT NOT NULL,
    numero_serie INT NOT NULL, 
    cantidad INT NOT NULL,
    PRIMARY KEY(id_egreso, numero_serie),
    FOREIGN KEY(id_egreso) references Egreso(id_egreso),
    FOREIGN KEY(numero_serie) references Unidad_Medicamento(numero_serie)
);