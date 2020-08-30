/*
Cambios Realizados en el modelo:
- Se añadieron columnas de nombre para farmacia y cliente
- Se añadió una columna 'stock_actual' a la tabla stock_bodega * antes llamada bodega_uniadad_medicamento
*/

DROP DATABASE IF EXISTS g1;
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
	id_farmacia INT PRIMARY KEY AUTO_INCREMENT,
	id_jefe VARCHAR(12) NOT NULL,
    nombre VARCHAR(20) NOT NULL,
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
	id_medicamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
	precio_unitario DECIMAL(10,2) NOT NULL 
);
    
CREATE TABLE if not exists Unidad_Medicamento
(
	id_medicamento INT NOT NULL, 
    numero_serie INT PRIMARY KEY, 
    fecha_caducidad Date NOT NULL,
    FOREIGN KEY(id_medicamento) references Medicamento(id_medicamento)
);

CREATE TABLE if not exists Categoria
(
	id_categoria INT PRIMARY KEY AUTO_INCREMENT, 
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
	id_cliente VARCHAR(12) PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
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
	id_venta_medicamento INT PRIMARY KEY,
    id_factura INT NOT NULL,
    unidad_medicamento INT NOT NULL,
    FOREIGN KEY(id_factura) references Factura(id_factura),
    FOREIGN KEY(unidad_medicamento) references Unidad_Medicamento(id_medicamento)
    );

CREATE TABLE if not exists Stock_Farmacia_Medicamento
(
	id_farmacia INT,
    id_medicamento INT,
    stock_minimo INT NOT NULL,
    stock_actual INT NOT NULL, 
    PRIMARY KEY(id_farmacia, id_medicamento),
    FOREIGN KEY(id_farmacia) references Farmacia(id_farmacia),
    FOREIGN KEY(id_medicamento) references Medicamento(id_medicamento) 
);

CREATE TABLE if not exists Bodega
(
	id_bodega INT PRIMARY KEY AUTO_INCREMENT, 
    id_admin_bodega VARCHAR(12),
    direccion VARCHAR(50),
    FOREIGN KEY(id_admin_bodega) references Persona(cedula)
);

CREATE TABLE if not exists Bodeguero
(
	id_bodeguero VARCHAR(12) PRIMARY KEY,
    id_bodega INT NOT NULL,
    FOREIGN KEY(id_bodeguero) references Persona(cedula),
    FOREIGN KEY(id_bodega) references Bodega(id_bodega)
);

CREATE TABLE if not exists Stock_Bodega
(
	numero_serie INT,
    id_bodega INT, 
    stock_actual INT,
    PRIMARY KEY(numero_serie, id_bodega),
    FOREIGN KEY(numero_serie) references Unidad_Medicamento(numero_serie),
    FOREIGN KEY(id_bodega) references Bodega(id_bodega)
);

CREATE TABLE if not exists Registro
(
	id_registro INT PRIMARY KEY AUTO_INCREMENT, 
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

INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0953496437' , 'Danny'  , 'Loor' , 'Nunez' , 'Guayaquil'  );
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0951839273' , 'Mario' , 'Chalén' , 'Carvajal' , 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0954364659' , 'Jorge' , 'Vulgarín' , 'Punguil' , 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0123456789' , 'Alfredo' , 'Pacheco' , 'Castillo', 'Milagro');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('1234568987' , 'María' , 'Roca' , 'Zambrano' , 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('2345678910' , 'José' , 'Malo' , 'Villamar', 'Samborondón');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('2356974001' , 'Martha' , 'Idrovo' , 'Cañarte' , 'Durán');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('2597651685' , 'Mickey' , 'Bejarano' , 'Martillo' , 'Yaguachi');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0954311867' , 'Thalía' , 'Chavarría' , 'López' , 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0641631432' , 'Patricio' , 'Álava' , 'Tomalá' , 'Durán');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0911004372', 'María', 'Torres', 'Barros', 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0943761342', 'Alison', 'Zavala', 'Alcívar', 'Durán');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('1353687923', 'Eduardo', 'Morán', 'Guananga', 'Durán');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('1498736112', 'Ángel', 'Letamendi', 'Guale', 'Yaguachi');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0945742831', 'Josefina', 'Gómez', 'García', 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0953496431' ,   'Jorge','Ramirez','Gonzales','Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0951839223' , 'Mario' ,  'Carvajal','Challen' , 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0954368659' , 'Jorge' , 'Punguil','Vulgarin' , 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0173456789' , 'Alfredo' ,'Castillo','Pacheco', 'Milagro');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('1234568987' , 'María' ,  'Zambrano','Piedra' , 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('2345678910' , 'José' ,'Villamar','Bueno', 'Samborondón');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('2356874001' , 'Martha' , 'Cañarte','Idrovo' , 'Durán');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('2597681685' , 'Mickey' ,  'Martillo','Bejarano' , 'Yaguachi');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0954391867' , 'Thalía' ,  'López' ,'Lopez', 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0641631432' , 'Mario' , 'Álava' , 'Tomalá' , 'Durán');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0911007872', 'Jorge', 'Torres', 'Barros', 'Guayaquil');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0943714134', 'Pedro', 'Zavala', 'Alcívar', 'Durán');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('1313687923', 'Eduarda', 'Morán', 'Guananga', 'Durán');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('1418736112', 'Ángela', 'Letamendi', 'Guale', 'Yaguachi');
INSERT INTO Persona  (cedula,nombre,apellido_paterno,apellido_materno,direccion) VALUES('0941742830', 'Josefino', 'Filipa', 'García', 'Guayaquil');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0953496437'  , '042985426');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0953496437'  , '0953496437');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0951839273', '042562559');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0951839273', '0979688148');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0954364659', '0996325624');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0954364659', '042472149');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0123456789' , '072552681');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0123456789' , '0926314492');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1234568987' , '022317431');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1234568987' , '0958642371');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2345678910' , '072573249');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2345678910' , '0957842672');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2356974001' , '042574293');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2356974001' , '0945374212');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2597651685' , '042487293');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2597651685' , '0953472863');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0954311867', '042527619');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0954311867', '0936421274');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0641631432', '042576821');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0641631432', '0953642751');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0911004372', '042547321');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0911004372', '0857842672');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0943761342', '042874475');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0943761342', '0938731834');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1353687923', '02246834');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1353687923', '0974862713');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1498736112', '042371142');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1498736112', '0984726741');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0945742830', '042573971');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0953496431', '0917821723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0951839223', '0947821723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0954368659', '0941822723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0173456789', '0447821723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1234568987', '0947221723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2345678910', '0947821223');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2356874001', '0947821723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('2597681685', '0947811723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0954391867', '0947821723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0641631432', '0941821723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0911007872', '0970821723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('0943714134', '0947811723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1313687923', '0917821723');
INSERT INTO Persona_Telefonos  (id_persona,numero) VALUES('1418736112', '0947821723');





INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0953496437'  , 'danny_loor00@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0953496437'  , 'dannyloor00@gmail.com'   );
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0953496437'  , 'dgloor@edu.ec' );
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0951839273', 'marces312001@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0951839273', 'marces312001@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0951839273', 'mcchalen@espol.edu.ec' );
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0954364659', 'adrivulgarin@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0954364659', 'adrivularin15042001@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0954364659', 'jvlugari@espol.edu.ec'         );
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0123456789' , 'alfrepach2000@yahoo.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0123456789' , 'alfpacheco15@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1234568987' , 'mrocazambra4@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1234568987' , 'mariarocazambr1999@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2345678910' , 'josemalo2002@outlook.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2345678910' , 'jmalovillamar31@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2356974001' , 'marthaidrovo2000@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2356974001' , 'maridrovo7@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2597651685' , 'mickeybejamar2001@outlook.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2597651685' , 'mbejarano032001@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0954311867', 'tchavalop1997@yahoo.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0641631432', 'patricioalava1998@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0911004372', 'mariatorres1999@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0911004372', 'mtorresbarros@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0943761342', 'alizavalaalcivar@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1353687923', 'edumoranguananga@outlook.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1353687923', 'edumoran2001@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1498736112', 'angeleta2000@outlook.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1498736112', 'angeletaguale@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0953496431', 'josomezgarcia@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0951839223' , 'mahaidrovo2000@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0954368659' , 'madrovo7@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0173456789' , 'micybejamar2001@outlook.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1234568987' , 'mbarano032001@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2345678910', 'tchavap1997@yahoo.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2356874001', 'patricalava1998@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('2597681685', 'mariatres1999@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0954391867', 'mtorresrros@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0641631432', 'alizavaalcivar@hotmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0911007872', 'edumonguananga@outlook.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0943714134', 'edumon2001@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1313687923', 'angelet000@outlook.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('1418736112', 'angeletuale@gmail.com');
INSERT INTO Persona_Correos  (id_persona,correo) VALUES('0941742830', 'josegomgarcia@hotmail.com');


INSERT INTO Cliente  (id_cliente, nombre) VALUES('00000000000', 'Jose Lita');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('00000000002', 'Misael Bohorquez');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('02468101214', 'Catalina Camacho');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('04681012145', 'Ruben Clemente');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('02681012141', 'Paula Umpierrez');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('24681012142', 'Paula Barahona');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('01246810122', 'Aaron Soria');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('02164810123', 'Genesis Pluas');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('01485454321', 'Jose Lita');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('09854653414', 'Misael Bohorquez');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('12310985321', 'Catalina Camacho');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('12095465321', 'Ruben Clemente');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('12468246824', 'Paula Umpierrez');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('25689478266', 'Paula Barahona');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('02468126786', 'Aaron Soria');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('02466966666', 'Joseph Lita');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('66655546262', 'Misaela Bohorquez');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22246679952', 'Catalino Camacho');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22246668795', 'Rubena Clemente');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22246667991', 'Paulo Umpierrez');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22233366999', 'Paulito Barahona');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22246679798', 'Aaron Soriosis');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22224669887', 'Genesis Pluasis');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22226664489', 'Jose Litio');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22224666889', 'Misael Bohorques');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22255654489', 'Catalina Camachon');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('55546952468', 'Ruben Clarinete');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('35465432152', 'Paula Umpierres');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('21652865421', 'Paula Barada');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('32165469898', 'Aaron Soriano');
INSERT INTO Cliente  (id_cliente, nombre) VALUES('22455556888', 'Genesis Pluasis');
INSERT INTO Categoria  (nombre,descripcion) VALUES('antibiótico','combatir infecciones' );
INSERT INTO Categoria  (nombre,descripcion) VALUES('analgésico','para el dolor muscular');
INSERT INTO Categoria  (nombre,descripcion) VALUES('deportivo','uso especifico para deportistas activos');
INSERT INTO Categoria  (nombre,descripcion) VALUES('antipirético','medicamento para la fiebre');
INSERT INTO Categoria  (nombre,descripcion) VALUES('antihistaminico','medicamentos para las alergias');
INSERT INTO Categoria  (nombre,descripcion) VALUES('antiinflamatorio','medicamentos para reducir la inflamacion');
INSERT INTO Categoria  (nombre,descripcion) VALUES('tranquilizante','medicamento para reducir el estres o la carga emocional');
INSERT INTO Categoria  (nombre,descripcion) VALUES('antidepresivo','para la depresion' );
INSERT INTO Categoria  (nombre,descripcion) VALUES('dermico','para problemas relacionados con la piel');
INSERT INTO Categoria  (nombre,descripcion) VALUES('embarazo','medicamentos dedicados al perido deembarazo');
INSERT INTO Categoria  (nombre,descripcion) VALUES('cronico','medicamentos para pacientes con enfeemedades cronicas');
INSERT INTO Categoria  (nombre,descripcion) VALUES('uso general','medicamentos que no requieres prescripcion');
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('paracentamol', 0.10);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('ibuprofeno', 0.15);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('gatorade', 1.00);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('analgan', 0.20);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('pasinerva', 2.40);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('voltaren', 1.50);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Cartimina', 0.10);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Ceritizina', 0.15);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Glucagon', 1.00);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Indapamina', 0.20);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Bemolan', 2.40);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Metaformina', 1.50);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Sutril', 0.10);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Zolpiden', 0.15);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Amchafibrin', 1.00);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Furantoina', 0.20);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Terbasin', 2.40);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Atrovent', 1.50);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Duphalac', 0.10);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Munorol', 0.15);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('NeoGripal', 1.00);
INSERT INTO Medicamento  (nombre,precio_unitario) VALUES('Conexine', 0.20);

INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(1, 5);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(1, 2);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(3, 12);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(2, 2);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(2, 6);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(4, 1);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(5, 7);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(6, 6);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(7, 4);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(8, 2);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(9, 3);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(10, 11);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(11, 6);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(12, 1);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(13, 10);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(14, 10);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(15, 7);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(16, 9);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(17, 8);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(18, 2);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(19, 6);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(20, 10);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(21, 12);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(22, 7);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(12, 3);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(13, 11);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(14, 2);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(15, 5);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(16, 7);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(17, 2);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(18, 1);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(19, 12);
INSERT INTO Categoria_Medicamento  (id_medicamento,id_categoria) VALUES(20, 3);

INSERT INTO Farmacia  (id_jefe, nombre) VALUES('0951839273', 'Farmacis');
INSERT INTO Farmacia  (id_jefe, nombre) VALUES('0953496437', 'Sana Sana');
INSERT INTO Farmacia  (id_jefe, nombre) VALUES('0954364659', 'Fybeca');
INSERT INTO Farmacia  (id_jefe, nombre) VALUES('0954311867', '24 horas');
INSERT INTO Farmacia  (id_jefe, nombre) VALUES('0641631432', 'Cruz Azul');

INSERT INTO Empleado_Farmacia  (id_empleado,id_farmacia,sueldo) VALUES('0911004372', 1, 500);
INSERT INTO Empleado_Farmacia  (id_empleado,id_farmacia,sueldo) VALUES('0943761342', 2, 600);
INSERT INTO Empleado_Farmacia  (id_empleado,id_farmacia,sueldo) VALUES('1353687923', 3, 500);
INSERT INTO Empleado_Farmacia  (id_empleado,id_farmacia,sueldo) VALUES('1498736112', 4, 500);
INSERT INTO Empleado_Farmacia  (id_empleado,id_farmacia,sueldo) VALUES('0945742830', 5, 600);
INSERT INTO Localidad  (id_farmacia,calle_principal,calle_secundaria,canton,provincia,referencia) VALUES(1, 'Av. Guano', 'Penipe', 'Guayaquil', 'Guayas', 'Parque Acuático Juan Montalvo');
INSERT INTO Localidad  (id_farmacia,calle_principal,calle_secundaria,canton,provincia,referencia) VALUES(2, 'Av. Amazonas', 'Av. Samuel Cisneros', 'Durán', 'Guayas', 'SuperAKI Primavera I');
INSERT INTO Localidad  (id_farmacia,calle_principal,calle_secundaria,canton,provincia,referencia) VALUES(3, 'Manuel Galecio', 'Boyacá', 'Guayaquil', 'Guayas', 'Estación Metrovía Luis Vernaza');
INSERT INTO Localidad  (id_farmacia,calle_principal,calle_secundaria,canton,provincia,referencia) VALUES(4, 'Av. Las Monjas', 'Calle Primera', 'Guayaquil', 'Guayas', 'Florería Bouquete');
INSERT INTO Localidad  (id_farmacia,calle_principal,calle_secundaria,canton,provincia,referencia) VALUES(5, 'Av. 25 de Julio', 'Chambers', 'Guayaquil', 'Guayas', 'Estación Metrovía Sagrada Familia - Oeste"');
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(1,  571821,STR_TO_DATE(' 2020-12-14', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(2,  589426,STR_TO_DATE(' 2021-05-28', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(3,  548390,STR_TO_DATE(' 2020-10-11', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(4,  561420,STR_TO_DATE(' 2022-08-20', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(5,  452718,STR_TO_DATE(' 2021-11-12', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(6,  464520,STR_TO_DATE(' 2020-07-25', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(7,  581821,STR_TO_DATE(' 2020-12-14', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(8,  579426,STR_TO_DATE(' 2021-05-28', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(9,  528390,STR_TO_DATE(' 2020-10-11', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(10, 512320,STR_TO_DATE(' 2022-08-20', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(11, 455158,STR_TO_DATE(' 2021-11-12', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(12, 415520,STR_TO_DATE(' 2020-07-25', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(13, 572521,STR_TO_DATE(' 2020-12-14', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(14, 949876,STR_TO_DATE(' 2021-05-28', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(15, 156485,STR_TO_DATE(' 2020-10-11', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(16, 564560,STR_TO_DATE(' 2022-08-20', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(17, 457158,STR_TO_DATE(' 2021-11-12', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(18, 461545,STR_TO_DATE(' 2020-07-25', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(19, 513858,STR_TO_DATE(' 2020-12-14', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(20, 512326,STR_TO_DATE(' 2021-05-28', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(1,  571561,STR_TO_DATE(' 2020-12-14', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(2,  589165,STR_TO_DATE(' 2021-05-28', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(3,  583319,STR_TO_DATE(' 2020-10-11', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(4,  554620,STR_TO_DATE(' 2022-08-20', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(5,  845628,STR_TO_DATE(' 2021-11-12', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(6,  643450,STR_TO_DATE(' 2020-07-25', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(7,  581681,STR_TO_DATE(' 2020-12-14', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(8,  579267,STR_TO_DATE(' 2021-05-28', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(9,  519870,STR_TO_DATE(' 2020-10-11', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(10, 579870,STR_TO_DATE(' 2022-08-20', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(11, 435818,STR_TO_DATE(' 2021-11-12', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(12, 411242,STR_TO_DATE(' 2020-07-25', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(13, 578121,STR_TO_DATE(' 2020-12-14', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(14, 515986,STR_TO_DATE(' 2021-05-28', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(15, 546840,STR_TO_DATE(' 2020-10-11', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(16, 561680,STR_TO_DATE(' 2022-08-20', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(17, 451658,STR_TO_DATE(' 2021-11-12', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(18, 466452,STR_TO_DATE(' 2020-07-25', '%Y-%m-%d'));
INSERT INTO Unidad_Medicamento  (id_medicamento,numero_serie,fecha_caducidad) VALUES(19, 585482,STR_TO_DATE(' 2020-12-14', '%Y-%m-%d'));
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,571821,26);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,589426,220);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,548390,210);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,561420,220);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,452718,220);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,464520,211);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,581821,21);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,579426,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,528390,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,512320,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,455158,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,415520,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,572521,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,949876,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,156485,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,564560,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,457158,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,461545,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,466452,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (1,585482,20);


INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,571821,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,589426,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,548390,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,561420,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,452718,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,464520,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,581821,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,579426,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,528390,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,512320,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,455158,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,415520,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,572521,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,949876,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,156485,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,564560,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,457158,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,461545,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,466452,20);
INSERT INTO Farmcia_Unidad_Medicamento(id_farmacia,numero_serie,cantidad) VALUES (2,585482,20);


insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,571821,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,589426,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,548390,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,561420,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,452718,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,464520,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,581821,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,579426,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,528390,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,512320,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,455158,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,415520,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,572521,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,949876,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,156485,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,564560,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,457158,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,461545,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,466452,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (3,585482,20);



insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,571821,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,589426,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,548390,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,561420,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,452718,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,464520,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,581821,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,579426,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,528390,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,512320,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,455158,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,415520,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,572521,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,949876,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,156485,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,564560,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,457158,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,461545,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,466452,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (4,585482,20);



insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,571821,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,589426,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,548390,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,561420,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,452718,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,464520,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,581821,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,579426,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,528390,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,512320,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,455158,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,415520,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,572521,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,949876,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,156485,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,564560,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,457158,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,461545,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,466452,20);
insert into farmcia_unidad_medicamento(id_farmacia,numero_serie,cantidad) values (5,585482,20);


INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(1, 1, 100, 250);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(1, 2, 90, 90);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(1, 3, 100, 280);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(1, 4, 100, 320);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(1, 5, 100, 250);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(1, 6, 100, 320);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(2, 1, 80, 80);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(2, 2, 100, 100);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(2, 3, 85, 85);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(2, 4, 100, 782);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(2, 5, 135, 135);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(2, 6, 100, 764);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(3, 1, 100, 100);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(3, 2, 115, 115);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(3, 3, 100, 326);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(3, 4, 100, 352);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(3, 5, 100, 100);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(3, 6, 100, 771);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(4, 1, 100, 723);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(4, 2, 80, 80);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(4, 3, 100, 573);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(4, 4, 120, 120);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(4, 5, 100, 734);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(4, 6, 85, 85);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(5, 1, 100, 302);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(5, 2, 100, 100);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(5, 3, 100, 394);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(5, 4, 90, 90);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(5, 5, 100, 386);
INSERT INTO Stock_Farmacia_Medicamento  (id_farmacia,id_medicamento,stock_minimo,stock_actual) VALUES(5, 6, 100, 263);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1001, '0911004372', '01485454321',STR_TO_DATE(' 2020-05-15', '%Y-%m-%d'), 20.00, 12);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1002, '1498736112', '01485454321',STR_TO_DATE(' 2015-04-15', '%Y-%m-%d'), 25.54, 12);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1003, '0911004372', '01485454321',STR_TO_DATE(' 2016-04-15', '%Y-%m-%d'), 15.45, 12);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1004, '0945742830', '01485454321',STR_TO_DATE(' 2019-05-16', '%Y-%m-%d'), 25.25, 12);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1005, '0911004372', '01485454321',STR_TO_DATE(' 2019-08-16', '%Y-%m-%d'), 5.65, 12);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1006, '1498736112', '01485454321',STR_TO_DATE(' 2016-07-14', '%Y-%m-%d'), 6.20, 12);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1007, '1353687923', '01485454321',STR_TO_DATE(' 2020-05-03', '%Y-%m-%d'), 89.65, 12);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1008, '0943761342', '01485454321',STR_TO_DATE(' 2005-09-08', '%Y-%m-%d'), 25.20, 12);
INSERT INTO Factura  (id_factura,id_empleado,id_cliente,fecha,total,iva) VALUES(1009, '1353687923', '01485454321',STR_TO_DATE(' 2019-09-08', '%Y-%m-%d'), 15.10, 12    );
INSERT INTO Venta_Unidad_Medicamento  (id_venta_medicamento,id_factura,unidad_medicamento) VALUES(1, 1001,2);
INSERT INTO Venta_Unidad_Medicamento  (id_venta_medicamento,id_factura,unidad_medicamento) VALUES(2, 1002,3 );
INSERT INTO Venta_Unidad_Medicamento  (id_venta_medicamento,id_factura,unidad_medicamento) VALUES(3, 1003,2);
INSERT INTO Venta_Unidad_Medicamento  (id_venta_medicamento,id_factura,unidad_medicamento) VALUES(4, 1004,3);
INSERT INTO Venta_Unidad_Medicamento  (id_venta_medicamento,id_factura,unidad_medicamento) VALUES(5, 1005,1);
INSERT INTO Venta_Unidad_Medicamento  (id_venta_medicamento,id_factura,unidad_medicamento) VALUES(6, 1006,1);
INSERT INTO Bodega (id_admin_bodega,direccion) VALUES('0641631432', 'Alarcon y calle 35');
INSERT INTO Bodega (id_admin_bodega,direccion) VALUES('0911004372', '36 y portete');
INSERT INTO Bodega (id_admin_bodega,direccion) VALUES('0943761342', 'Garcia Gollena y Pedro Pablo Gomez');
INSERT INTO Bodega (id_admin_bodega,direccion) VALUES('1498736112', 'Rumichaca y Manuel Galecio');
INSERT INTO Bodega (id_admin_bodega,direccion) VALUES('0945742830', '26 y Maldonado');
INSERT INTO Stock_Bodega  (numero_serie,id_bodega,stock_actual) VALUES( 571821, 1,875);
INSERT INTO Stock_Bodega  (numero_serie,id_bodega,stock_actual ) VALUES( 589426, 2,544);
INSERT INTO Stock_Bodega  (numero_serie,id_bodega,stock_actual ) VALUES( 548390, 3,1143);
INSERT INTO Stock_Bodega  (numero_serie,id_bodega,stock_actual ) VALUES( 561420, 3,933);
INSERT INTO Stock_Bodega  (numero_serie,id_bodega,stock_actual ) VALUES( 452718, 4,854);
INSERT INTO Stock_Bodega  (numero_serie,id_bodega,stock_actual ) VALUES( 464520, 5,1147);
INSERT INTO Bodeguero (id_bodeguero,id_bodega) VALUES( "0123456789", 1);
INSERT INTO Bodeguero (id_bodeguero,id_bodega) VALUES( "1234568987", 2);
INSERT INTO Bodeguero (id_bodeguero,id_bodega) VALUES( "2345678910", 3);
INSERT INTO Bodeguero (id_bodeguero,id_bodega) VALUES( "2356974001", 4);
INSERT INTO Bodeguero (id_bodeguero,id_bodega) VALUES( "2597651685", 5);
INSERT INTO Registro  (id_bodeguero,fecha_solicitud,justificativo) VALUES("0123456789",STR_TO_DATE(' 2001-04-15 ', '%Y-%m-%d'), "Salida de medicamentos para la farmacia 1");
INSERT INTO Registro  (id_bodeguero,fecha_solicitud,justificativo) VALUES("1234568987",STR_TO_DATE(' 2002-05-15 ', '%Y-%m-%d'), "Ingreso de medicamentos de la marca fibeca");
INSERT INTO Registro  (id_bodeguero,fecha_solicitud,justificativo) VALUES("2345678910",STR_TO_DATE(' 2008-05-22 ', '%Y-%m-%d'), "Salida de mediacmentos para la farmacia 3");
INSERT INTO Registro  (id_bodeguero,fecha_solicitud,justificativo) VALUES("2597651685",STR_TO_DATE(' 2001-05-15 ', '%Y-%m-%d'), "Ingreso de medicamento del proveedor farmacis");
INSERT INTO Ingreso  (id_ingreso,id_admin_bodega) VALUES( 2, '0641631432');
INSERT INTO Ingreso  (id_ingreso,id_admin_bodega) VALUES( 4, '0911004372');
INSERT INTO Ingreso_Bodega_Unidad (id_ingreso,numero_serie,cantidad) VALUES(    2 , 571821 , 1000);
INSERT INTO Ingreso_Bodega_Unidad (id_ingreso,numero_serie,cantidad) VALUES(    2 , 589426 , 1548);
INSERT INTO Ingreso_Bodega_Unidad (id_ingreso,numero_serie,cantidad) VALUES(    2 , 548390 , 1266);
INSERT INTO Ingreso_Bodega_Unidad (id_ingreso,numero_serie,cantidad) VALUES(    4 , 561420 , 1254);
INSERT INTO Ingreso_Bodega_Unidad (id_ingreso,numero_serie,cantidad) VALUES(    4 , 452718 , 1365);
INSERT INTO Ingreso_Bodega_Unidad (id_ingreso,numero_serie,cantidad) VALUES(    4 , 464520 , 1236);
INSERT INTO Egreso  (id_egreso,farmacia_destino,solicitante,fecha_egreso) VALUES(    1 , 1 , "0123456789",STR_TO_DATE('2001-04-15', '%Y-%m-%d'));
INSERT INTO Egreso  (id_egreso,farmacia_destino,solicitante,fecha_egreso) VALUES(    3 , 2 , "0945742830",STR_TO_DATE('2002-05-15', '%Y-%m-%d'));
INSERT INTO Egreso_Bodega_Unidad (id_egreso,numero_serie,cantidad) VALUES(    1 , 571821 , 125);
INSERT INTO Egreso_Bodega_Unidad (id_egreso,numero_serie,cantidad) VALUES(    1 , 589426 , 125);
INSERT INTO Egreso_Bodega_Unidad (id_egreso,numero_serie,cantidad) VALUES(    1 , 548390 , 123);
INSERT INTO Egreso_Bodega_Unidad (id_egreso,numero_serie,cantidad) VALUES(    1 , 452718 , 124);
INSERT INTO Egreso_Bodega_Unidad (id_egreso,numero_serie,cantidad) VALUES(    3 , 561420 , 321);
INSERT INTO Egreso_Bodega_Unidad (id_egreso,numero_serie,cantidad) VALUES(    3 , 452718 , 387);
INSERT INTO Egreso_Bodega_Unidad (id_egreso,numero_serie,cantidad) VALUES(    3 , 464520 , 89);
INSERT INTO Egreso_Bodega_Unidad (id_egreso,numero_serie,cantidad) VALUES(    3 , 589426 , 879);


----------------------------------------------------------- VIEWS 

create view reporte_ingreso as 
	select b.direccion as direccion_bodega,
	concat(p.nombre, ' ', p.apellido_paterno) as solicitante, 
	r.fecha_solicitud, m.nombre as medicamento, ibd.cantidad
	from ingreso i
	inner join (registro r, bodega b, ingreso_bodega_unidad ibd,
	unidad_medicamento um, medicamento m, persona p)
	on (i.id_ingreso = r.id_registro and b.id_admin_bodega = i.id_admin_bodega 
	and i.id_ingreso = ibd.id_ingreso and um.numero_serie = ibd.numero_serie
	and um.id_medicamento = m.id_medicamento and p.cedula = b.id_admin_bodega)
	group by p.cedula, r.fecha_solicitud, m.id_medicamento
	order by r.fecha_solicitud;

-- select * from reporte_ingreso;

create view reporte_egreso as
	select b.direccion as direccion_bodega,
	concat(p.nombre, ' ', p.apellido_paterno) as solicitante_farmacia,
    f.nombre as nombre_farmacia,
    concat(l.calle_principal, ' ', l.calle_secundaria) as direccion_farmacia,
    e.fecha_egreso, sum(ebu.cantidad) as cantidad
	from egreso e
	inner join (registro r, persona p, farmacia f, localidad l,
	egreso_bodega_unidad ebu, bodega b, bodeguero bo)
	on (e.id_egreso = r.id_registro and e.solicitante = p.cedula
	and f.id_farmacia = e.farmacia_destino
	and f.id_farmacia = l.id_farmacia
	and ebu.id_egreso = e.id_egreso
	and r.id_bodeguero = bo.id_bodeguero
	and bo.id_bodega = b.id_bodega)
	group by p.cedula, e.fecha_egreso, f.id_farmacia
	order by e.fecha_egreso;

-- select * from reporte_egreso;

CREATE VIEW frecuencia_compras as 
	select cat.nombre as nombre_categoria,
	c.nombre as nombre_cliente,
	count(cat.id_categoria) as frecuencia_compra,
	sum(f.total) as total_compras
	from factura f 
	inner join (cliente c, venta_unidad_medicamento vum , categoria_medicamento cm, categoria cat)
	on (c.id_cliente = f.id_cliente
	and f.id_factura = vum.id_factura
	and vum.unidad_medicamento = cm.id_medicamento
	and cm.id_categoria = cat.id_categoria)
	group by cat.id_categoria, c.id_cliente
	order by cat.nombre asc;
    
-- select * from frecuencia_compras;


-------------------------------------------------------- PROCEDURES

DROP PROCEDURE IF EXISTS RegistrarIngreso;
DELIMITER ||
CREATE PROCEDURE RegistrarIngreso (
	in solicitante varchar(12) , in bodeguero varchar(12), in justif varchar(100), 
    in medicina int, in nSerie int , in caducidad date, in cantidad int 
    )
BEGIN
	START TRANSACTION;
		INSERT INTO Registro(id_bodeguero, fecha_solicitud, justificativo) 
			VALUES (bodeguero, date(now()), justif);
        INSERT INTO Ingreso(id_ingreso, id_admin_bodega) 
			VALUES ((select max(id_registro) FROM Registro), solicitante);
        INSERT INTO Unidad_Medicamento(id_medicamento, numero_serie, fecha_caducidad) 
			VALUES (medicina, nSerie, caducidad);
        INSERT INTO Ingreso_Bodega_Unidad(id_ingreso, numero_serie, cantidad) 
			VALUES ((select max(id_ingreso) FROM Ingreso), nSerie, cantidad);
	COMMIT;
END ||
DELIMITER ;


DROP PROCEDURE IF EXISTS RegistrarEgreso;
DELIMITER ||
CREATE PROCEDURE RegistrarEgreso 
	(in bodeguero varchar(12), in justificativo varchar(1000), in farmacia int, in n_serie int, in cantidad int, out exitoso boolean)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        set exitoso = false;
	END;

	START TRANSACTION;
    
    /*
        SET @solicitante = (SELECT id_jefe FROM Farmacia f WHERE f.id_farmacia = farmacia);
        -- SELECT id_jefe FROM Farmacia f WHERE f.id_farmacia = farmacia;
		INSERT INTO Registro(id_bodeguero, fecha_solicitud, justificativo) VALUES(bodeguero, date(now()), justificativo);
        
        SET @idRegistro = (SELECT max(id_registro) FROM Registro);
        INSERT INTO Egreso VALUES(@idRegistro, farmacia, @solicitante, date(now()));
        INSERT INTO Egreso_bodega_unidad VALUES(@idRegistro, n_serie, cantidad);
        
        UPDATE Stock_Farmacia_Medicamento SET stock_actual = (stock_actual + cantidad) 
			WHERE id_farmacia = farmacia AND id_medicamento = n_serie;
            
        SET @bodega = (SELECT id_bodega FROM Bodeguero WHERE id_bodeguero = bodeguero) ;
        -- SELECT id_bodega FROM Bodeguero WHERE id_bodeguero = bodeguero;
        UPDATE Stock_Bodega SET stock_actual = (stock_actual - cantidad) 
			WHERE id_bodega = @bodega AND numero_serie = n_serie;
        SET @stockBodega = (SELECT stock_actual FROM Stock_Bodega WHERE id_bodega = @bodega AND numero_serie = n_serie);
        -- SELECT stock_actual FROM Stock_Bodega WHERE id_bodega = @bodega AND numero_serie = n_serie;
		IF @stockBodega < 0 THEN
			set exitoso = false;
			ROLLBACK;        
		ELSE
			set exitoso = true;
			COMMIT;
		END IF;*/
        set exitoso=true;
END ||
DELIMITER ; 
call registraregreso('0123456789','jorge ',1,571821,10,@exito);
