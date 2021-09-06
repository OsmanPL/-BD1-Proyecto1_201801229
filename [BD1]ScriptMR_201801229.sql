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
	Codigo_Postal NUMBER NOT NULL,
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
	Nombre_Tienda VARCHAR2(250) NOT NULL,
	Direccion VARCHAR2(250) NOT NULL,
	Ciudad NUMBER NOT NULL
);

ALTER TABLE Tienda
    ADD CONSTRAINT PK_Tienda
        PRIMARY KEY(Id_Tienda);

ALTER TABLE Tienda
    ADD CONSTRAINT FK_Ciudad
        FOREIGN KEY (Ciudad)
            REFERENCES Ciudad(Id_Ciudad) ON DELETE CASCADE;

COMMIT;

/*Tabla Cliente*/
CREATE TABLE Cliente(
	Id_Cliente VARCHAR2(250) NOT NULL,
	Correo_Electronico VARCHAR2(250) NOT NULL,
	Nombre VARCHAR2(250) NOT NULL,
	Apellido VARCHAR2(250) NOT NULL,
	Direccion VARCHAR2(250) NOT NULL,
	Estado VARCHAR2(250) NOT NULL,
	Fecha_Registro TIMESTAMP NOT NULL,
	Tienda_Preferida NUMBER NOT NULL,
	Ciudad NUMBER NOT NULL
);

ALTER TABLE Cliente
    ADD CONSTRAINT PK_Cliente
        PRIMARY KEY(Id_Cliente);

ALTER TABLE Cliente
    ADD CONSTRAINT FK_Ciudad
        FOREIGN KEY (Ciudad)
            REFERENCES Ciudad(Id_Ciudad) ON DELETE CASCADE;
           
ALTER TABLE Cliente
    ADD CONSTRAINT FK_Tienda
        FOREIGN KEY (Tienda_Preferida)
            REFERENCES Tienda(Id_Tienda) ON DELETE CASCADE;

COMMIT;

/*Tabla Empleado*/
CREATE TABLE Empleado(
	Correo_Electronico VARCHAR2(250) NOT NULL,
	Usuario VARCHAR2(250) NOT NULL,
	Nombre VARCHAR2(250) NOT NULL,
	Apellido VARCHAR2(250) NOT NULL,
	Tienda_Trabajo NUMBER NOT NULL,
	Estado VARCHAR2(2) NOT NULL,
	Encargado VARCHAR2(2) NOT NULL,
	
);

COMMIT;


/*
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Tienda CASCADE CONSTRAINTS;
DROP TABLE Direccion CASCADE CONSTRAINTS;
DROP TABLE Ciudad CASCADE CONSTRAINTS;
DROP TABLE Pais CASCADE CONSTRAINTS;
*/




