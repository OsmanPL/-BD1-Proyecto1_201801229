DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Tienda CASCADE CONSTRAINTS;
DROP TABLE Ciudad CASCADE CONSTRAINTS;
DROP TABLE Pais CASCADE CONSTRAINTS;
DROP TABLE Empleado CASCADE CONSTRAINTS;
DROP TABLE Factura CASCADE CONSTRAINTS;
DROP TABLE Categoria CASCADE CONSTRAINTS;
DROP TABLE Pelicula CASCADE CONSTRAINTS;
DROP TABLE Idioma CASCADE CONSTRAINTS;
DROP TABLE Actor CASCADE CONSTRAINTS;
DROP TABLE Pelicula_Actor CASCADE CONSTRAINTS;
DROP TABLE Pelicula_Categoria CASCADE CONSTRAINTS;
DROP TABLE Pelicula_Idioma CASCADE CONSTRAINTS;
DROP TABLE Inventario CASCADE CONSTRAINTS;
DROP TABLE Encargado CASCADE CONSTRAINTS;
DROP TABLE Clasificacion CASCADE CONSTRAINTS;


/*Tabla Pais*/
CREATE TABLE Pais(
	Id_Pais NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Nombre VARCHAR2(250) NOT NULL
);

ALTER TABLE Pais 
    ADD CONSTRAINT PK_Pais
        PRIMARY KEY(Id_Pais);

COMMIT;

/*Tabla Ciudad*/
CREATE TABLE Ciudad(
	Id_Ciudad NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Nombre VARCHAR2(250) NOT NULL,
	Pais NUMBER NOT NULL
);

ALTER TABLE Ciudad
    ADD CONSTRAINT PK_Ciudad
        PRIMARY KEY(Id_Ciudad);

ALTER TABLE Ciudad
    ADD CONSTRAINT FK_Pais
        FOREIGN KEY (Pais)
            REFERENCES Pais(Id_Pais) ON DELETE CASCADE;

COMMIT;

/*Tabla Tienda*/
CREATE TABLE Tienda(
	Id_Tienda NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Nombre VARCHAR2(250) NOT NULL,
	Direccion VARCHAR2(250) NOT NULL,
	Ciudad NUMBER NOT NULL
);

ALTER TABLE Tienda
    ADD CONSTRAINT PK_Tienda
        PRIMARY KEY(Id_Tienda);

ALTER TABLE Tienda
    ADD CONSTRAINT FK_Ciudad_Tienda
        FOREIGN KEY (Ciudad)
            REFERENCES Ciudad(Id_Ciudad) ON DELETE CASCADE;

COMMIT;

/*Tabla Cliente*/
CREATE TABLE Cliente(
	Id_Cliente NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Correo_Electronico VARCHAR2(250) NOT NULL,
	Nombre VARCHAR2(250) NOT NULL,
	Apellido VARCHAR(250) NOT NULL,
	Direccion VARCHAR2(250) NOT NULL,
	Estado VARCHAR2(250) NOT NULL,
	Fecha_Registro TIMESTAMP NOT NULL,
	Tienda_Preferida NUMBER NOT NULL,
	Ciudad NUMBER NOT NULL,
	Codigo_Postal NUMBER NOT NULL
);

ALTER TABLE Cliente
    ADD CONSTRAINT PK_Cliente
        PRIMARY KEY(Id_Cliente);

ALTER TABLE Cliente
    ADD CONSTRAINT FK_Ciudad_Cliente
        FOREIGN KEY (Ciudad)
            REFERENCES Ciudad(Id_Ciudad) ON DELETE CASCADE;
           
ALTER TABLE Cliente
    ADD CONSTRAINT FK_Tienda_Cliente
        FOREIGN KEY (Tienda_Preferida)
            REFERENCES Tienda(Id_Tienda) ON DELETE CASCADE;

COMMIT;

/*Tabla Empleado*/
CREATE TABLE Empleado(
	Id_Empleado NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Correo_Electronico VARCHAR2(250) NOT NULL,
	Usuario VARCHAR2(250) NOT NULL,
	Password VARCHAR2(250) NOT NULL,
	Nombre VARCHAR2(250) NOT NULL,
	Apellido VARCHAR(250) NOT NULL,
	Tienda_Trabajo NUMBER NOT NULL,
	Estado VARCHAR2(250) NOT NULL,
	Ciudad NUMBER NOT NULL
);

ALTER TABLE Empleado
    ADD CONSTRAINT PK_Empleado
        PRIMARY KEY(Id_Empleado);

ALTER TABLE Empleado
    ADD CONSTRAINT FK_Ciudad_Empleado
        FOREIGN KEY (Ciudad)
            REFERENCES Ciudad(Id_Ciudad) ON DELETE CASCADE;
           
ALTER TABLE Empleado
    ADD CONSTRAINT FK_Tienda_Empleado
        FOREIGN KEY (Tienda_Trabajo)
            REFERENCES Tienda(Id_Tienda) ON DELETE CASCADE;

COMMIT;

/*Tabla Encargado*/

CREATE TABLE Encargado(
	Empleado NUMBER NOT NULL,
	Tienda NUMBER NOT NULL
);

ALTER TABLE Encargado
    ADD CONSTRAINT PK_Encargado
        PRIMARY KEY(Empleado, Tienda);
       
ALTER TABLE Encargado
    ADD CONSTRAINT FK_Encargado_Empleado
        FOREIGN KEY (Empleado)
            REFERENCES Empleado(Id_Empleado) ON DELETE CASCADE;
           
ALTER TABLE Encargado
    ADD CONSTRAINT FK_Encargado_Tienda
        FOREIGN KEY (Tienda)
            REFERENCES Tienda(Id_Tienda) ON DELETE CASCADE;
           
COMMIT;

/*Tabla Actor*/
CREATE TABLE Actor(
	Id_Actor NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Nombre VARCHAR2(250) NOT NULL,
	Apellido VARCHAR(250) NOT NULL
);

ALTER TABLE Actor
    ADD CONSTRAINT PK_Actor
        PRIMARY KEY(Id_Actor);
       
COMMIT;

/*Tabla Categoria*/
CREATE TABLE Categoria(
	Id_Categoria NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Categoria VARCHAR2(250) NOT NULL 
);

ALTER TABLE Categoria
    ADD CONSTRAINT PK_Categoria
        PRIMARY KEY(Id_Categoria);

COMMIT;

/*Tabla Idioma*/
CREATE TABLE Idioma(
	Id_Idioma NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Lenguaje VARCHAR2(250) NOT NULL
);

ALTER TABLE Idioma
    ADD CONSTRAINT PK_Idioma
        PRIMARY KEY(Id_Idioma);

COMMIT;

/*Tabla Clasificacion*/
CREATE TABLE Clasificacion(
	Id_Clasificacion NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Clasificacion VARCHAR2(250) NOT NULL
);

ALTER TABLE Clasificacion
    ADD CONSTRAINT PK_Clasificacion
        PRIMARY KEY(Id_Clasificacion);

COMMIT;

/*Tabla Pelicula*/
CREATE TABLE Pelicula(
	Id_Pelicula NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Nombre VARCHAR2(250) NOT NULL,
	Descripcion VARCHAR2(250) NOT NULL,
	Ano_Lanzamiento NUMBER NOT NULL,
	Dias_Renta NUMBER NOT NULL,
	Costo_Renta NUMBER NOT NULL,
	Duracion NUMBER NOT NULL,
	Costo_Por_Dano NUMBER NOT NULL,
	Clasificacion NUMBER NOT NULL
);

ALTER TABLE Pelicula
    ADD CONSTRAINT PK_Pelicula
        PRIMARY KEY(Id_Pelicula);

ALTER TABLE Pelicula
    ADD CONSTRAINT FK_Pelicula_Clasificacion
        FOREIGN KEY (Clasificacion)
            REFERENCES Clasificacion(Id_Clasificacion) ON DELETE CASCADE;

COMMIT;

/*Tabla Inventario*/
CREATE TABLE Inventario(
	Id_Inventario NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Tienda NUMBER NOT NULL,
	Pelicula NUMBER NOT NULL,
	Cantidad NUMBER DEFAULT 0
);

ALTER TABLE Inventario
    ADD CONSTRAINT PK_Inventario
        PRIMARY KEY(Id_Inventario);

ALTER TABLE Inventario
    ADD CONSTRAINT FK_Tienda_Inventario
        FOREIGN KEY (Tienda)
            REFERENCES Tienda(Id_Tienda) ON DELETE CASCADE;
           
ALTER TABLE Inventario
    ADD CONSTRAINT FK_Pelicula_Inventario
        FOREIGN KEY (Pelicula)
            REFERENCES Pelicula(Id_Pelicula) ON DELETE CASCADE;

COMMIT;

/*Tabla Pelicula_Actor*/
CREATE TABLE Pelicula_Actor(
	Pelicula NUMBER NOT NULL,
	Actor NUMBER NOT NULL
);

ALTER TABLE Pelicula_Actor
    ADD CONSTRAINT PK_Pelicula_Actor
        PRIMARY KEY(Pelicula, Actor);

ALTER TABLE Pelicula_Actor
    ADD CONSTRAINT FK_Pelicula_Pelicula_Actor
        FOREIGN KEY (Pelicula)
            REFERENCES Pelicula(Id_Pelicula) ON DELETE CASCADE;  
           
ALTER TABLE Pelicula_Actor
    ADD CONSTRAINT FK_Actor_Pelicula_Actor
        FOREIGN KEY (Actor)
            REFERENCES Actor(Id_Actor) ON DELETE CASCADE;  

COMMIT;

/*Tabla Pelicula_Categoria*/
CREATE TABLE Pelicula_Categoria(
	Pelicula NUMBER NOT NULL,
	Categoria NUMBER NOT NULL
);

ALTER TABLE Pelicula_Categoria
    ADD CONSTRAINT PK_Pelicula_Categoria
        PRIMARY KEY(Pelicula, Categoria);

ALTER TABLE Pelicula_Categoria
    ADD CONSTRAINT FK_Pelicula_Pelicula_Categoria
        FOREIGN KEY (Pelicula)
            REFERENCES Pelicula(Id_Pelicula) ON DELETE CASCADE;  
           
ALTER TABLE Pelicula_Categoria
    ADD CONSTRAINT FK_Categoria_Pelicula_Categoria
        FOREIGN KEY (Categoria)
            REFERENCES Categoria(Id_Categoria) ON DELETE CASCADE;  

COMMIT;

/*Tabla Pelicula_Idioma*/
CREATE TABLE Pelicula_Idioma(
	Pelicula NUMBER NOT NULL,
	Idioma NUMBER NOT NULL
);

ALTER TABLE Pelicula_Idioma
    ADD CONSTRAINT PK_Pelicula_Idioma
        PRIMARY KEY(Pelicula, Idioma);

ALTER TABLE Pelicula_Idioma
    ADD CONSTRAINT FK_Pelicula_Pelicula_Idioma
        FOREIGN KEY (Pelicula)
            REFERENCES Pelicula(Id_Pelicula) ON DELETE CASCADE;  
           
ALTER TABLE Pelicula_Idioma
    ADD CONSTRAINT FK_Idioma_Pelicula_Idioma
        FOREIGN KEY (Idioma)
            REFERENCES Idioma(Id_Idioma) ON DELETE CASCADE;  

COMMIT;

/*Tabla Factura*/
CREATE TABLE Factura(
	Id_Factura NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	Cliente NUMBER NOT NULL,
	Empleado NUMBER NOT NULL,
	Fecha_Renta TIMESTAMP NOT NULL,
	Fecha_Retorno TIMESTAMP,
	Monto_A_Pagar NUMBER NOT NULL,
	Fecha_Pago TIMESTAMP NOT NULL,
	Pelicula NUMBER NOT NULL,
	Tienda NUMBER NOT NULL
);

ALTER TABLE Factura
    ADD CONSTRAINT PK_Factura
        PRIMARY KEY(Id_Factura);

ALTER TABLE Factura
    ADD CONSTRAINT FK_Cliente_Factura
        FOREIGN KEY (Cliente)
            REFERENCES Cliente(Id_Cliente) ON DELETE CASCADE;  
           
ALTER TABLE Factura
    ADD CONSTRAINT FK_Empleado_Factura
        FOREIGN KEY (Empleado)
            REFERENCES Empleado(Id_Empleado) ON DELETE CASCADE;
           
ALTER TABLE Factura
    ADD CONSTRAINT FK_Pelicula_Factura
        FOREIGN KEY (Pelicula)
            REFERENCES Pelicula(Id_Pelicula) ON DELETE CASCADE;
           
ALTER TABLE Factura
    ADD CONSTRAINT FK_Tienda_Factura
        FOREIGN KEY (Tienda)
            REFERENCES Tienda(Id_Tienda) ON DELETE CASCADE;

COMMIT;


