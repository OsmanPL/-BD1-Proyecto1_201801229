SELECT * FROM TEMPORAL;
SELECT COUNT(*) FROM TEMPORAL;

CREATE TABLE TEMPORAL(
	NOMBRE_CLIENTE VARCHAR2(250),
	CORREO_CLIENTE VARCHAR2(250),
	CLIENTE_ACTIVO VARCHAR2(250),
	FECHA_CREACION TIMESTAMP,
	TIENDA_PREFERIDA VARCHAR2(250),
	DIRECCION_CLIENTE VARCHAR2(250),
	CODIGO_POSTAL_CLIENTE NUMBER,
	CIUDAD_CLIENTE VARCHAR2(250),
	PAIS_CLIENTE VARCHAR2(250),
	FECHA_RENTA TIMESTAMP,
	FECHA_RETORNO TIMESTAMP,
	MONTO_A_PAGAR VARCHAR2(250),
	FECHA_PAGO TIMESTAMP,
	NOMBRE_EMPLEADO VARCHAR2(250),
	CORREO_EMPLEADO VARCHAR2(250),
	EMPLEADO_ACTIVO VARCHAR2(250),
	TIENDA_EMPLEADO VARCHAR2(250),
	USUARIO_EMPLEADO VARCHAR2(250),
	CONTRASENA_EMPLEADO VARCHAR2(250),
	DIRECCION_EMPLEADO VARCHAR2(250),
	CODIGO_POSTAL_EMPLEADO NUMBER,
	CIUDAD_EMPLEADO VARCHAR2(250),
	PAIS_EMPLEADO VARCHAR2(250),
	NOMBRE_TIENDA VARCHAR2(250),
	ENCARGADO_TIENDA VARCHAR2(250),
	DIRECCION_TIENDA VARCHAR2(250),
	CODIGO_POSTAL_TIENDA NUMBER,
	CIUDAD_TIENDA VARCHAR2(250),
	PAIS_TIENDA VARCHAR2(250),
	TIENDA_PELICULA VARCHAR2(250),
	NOMBRE_PELICULA VARCHAR2(250),
	DESCRIPCION_PELICULA VARCHAR2(250),
	ANO_LANZAMIENTO NUMBER,
	DIAS_RENTA NUMBER,
	COSTO_RENTA VARCHAR2(250),
	DURACION NUMBER,
	COSTO_POR_DANO VARCHAR2(250),
	CLASIFICACION VARCHAR2(250),
	LENGUAJE_PELICULA VARCHAR2(250),
	CATEGORIA_PELICULA VARCHAR2(250),
	ACTOR_PELICULA VARCHAR2(250)
);

COMMIT;

DROP TABLE TEMPORAL;