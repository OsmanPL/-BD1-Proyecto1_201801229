-- Insertar en Tabla Pais
INSERT INTO PAIS (Nombre)
SELECT DISTINCT t.PAIS_CLIENTE 
FROM TEMPORAL t 
WHERE t.PAIS_CLIENTE IS NOT NULL
GROUP BY t.PAIS_CLIENTE
UNION
SELECT DISTINCT TEMPORAL.PAIS_EMPLEADO 
FROM TEMPORAL 
WHERE TEMPORAL.PAIS_EMPLEADO IS NOT NULL
GROUP BY TEMPORAL.PAIS_EMPLEADO
UNION
SELECT DISTINCT TEMPORAL.PAIS_TIENDA 
FROM TEMPORAL 
WHERE TEMPORAL.PAIS_TIENDA IS NOT NULL
GROUP BY TEMPORAL.PAIS_TIENDA;

COMMIT;

-- Insertar en Tabla Ciudad
INSERT INTO CIUDAD (NOMBRE, PAIS)
SELECT DISTINCT t.CIUDAD_CLIENTE , p.ID_PAIS 
FROM TEMPORAL t INNER JOIN PAIS p
ON t.PAIS_CLIENTE = p.NOMBRE 
WHERE t.CIUDAD_CLIENTE IS NOT NULL  
GROUP BY t.CIUDAD_CLIENTE , p.ID_PAIS 
UNION
SELECT DISTINCT t.CIUDAD_EMPLEADO  , p.ID_PAIS 
FROM TEMPORAL t INNER JOIN PAIS p
ON t.PAIS_EMPLEADO = p.NOMBRE 
WHERE t.CIUDAD_EMPLEADO IS NOT NULL 
GROUP BY t.CIUDAD_EMPLEADO , p.ID_PAIS
UNION
SELECT DISTINCT t.CIUDAD_TIENDA , p.ID_PAIS 
FROM TEMPORAL t INNER JOIN PAIS p
ON t.PAIS_TIENDA = p.NOMBRE 
WHERE t.CIUDAD_TIENDA IS NOT NULL  
GROUP BY t.CIUDAD_TIENDA , p.ID_PAIS;

COMMIT;

-- Insertar en Tabla Tienda
INSERT INTO TIENDA (NOMBRE, DIRECCION, CIUDAD)
SELECT DISTINCT t.NOMBRE_TIENDA, t.DIRECCION_TIENDA, c.ID_CIUDAD 
FROM TEMPORAL t INNER JOIN CIUDAD c 
ON t.CIUDAD_TIENDA = c.NOMBRE 
WHERE t.NOMBRE_TIENDA IS NOT NULL AND t.DIRECCION_TIENDA IS NOT NULL 
GROUP BY t.NOMBRE_TIENDA , t.DIRECCION_TIENDA , c.ID_CIUDAD ;

COMMIT;

-- Insertar en Tabla Empleado
INSERT INTO EMPLEADO (CORREO_ELECTRONICO ,USUARIO , PASSWORD, NOMBRE, APELLIDO, TIENDA_TRABAJO, ESTADO, CIUDAD)
SELECT DISTINCT t.CORREO_EMPLEADO , t.USUARIO_EMPLEADO , t.CONTRASENA_EMPLEADO ,split_part(t.NOMBRE_EMPLEADO ,' ',1), split_part(t.NOMBRE_EMPLEADO  ,' ',2)  , t2.ID_TIENDA , t.EMPLEADO_ACTIVO, c.ID_CIUDAD 
FROM TEMPORAL t INNER JOIN CIUDAD c ON t.CIUDAD_EMPLEADO = c.NOMBRE 
INNER JOIN TIENDA t2 ON t2.NOMBRE = t.TIENDA_EMPLEADO 
WHERE t.CORREO_EMPLEADO IS NOT NULL AND t.USUARIO_EMPLEADO IS NOT NULL AND t.CONTRASENA_EMPLEADO IS NOT NULL AND t.NOMBRE_EMPLEADO IS NOT NULL AND t2.ID_TIENDA IS NOT NULL AND t.EMPLEADO_ACTIVO IS NOT NULL AND c.ID_CIUDAD IS NOT NULL 
GROUP BY t.CORREO_EMPLEADO , t.USUARIO_EMPLEADO , t.CONTRASENA_EMPLEADO , t.NOMBRE_EMPLEADO , t2.ID_TIENDA , t.EMPLEADO_ACTIVO , c.ID_CIUDAD ;

COMMIT;

-- Insertar en Tabla Encargado
INSERT INTO ENCARGADO (EMPLEADO, TIENDA)
SELECT DISTINCT e.ID_EMPLEADO, t2.ID_TIENDA 
FROM TEMPORAL t INNER JOIN EMPLEADO e ON e.NOMBRE = split_part(t.ENCARGADO_TIENDA ,' ',1) AND e.APELLIDO = split_part(t.ENCARGADO_TIENDA ,' ',2)
INNER JOIN TIENDA t2 ON t.NOMBRE_TIENDA = t2.NOMBRE 
WHERE t2.ID_TIENDA IS NOT NULL AND e.ID_EMPLEADO IS NOT NULL 
GROUP BY e.ID_EMPLEADO , t2.ID_TIENDA ;

COMMIT;

-- Insertar en Tabla Cliente
INSERT INTO CLIENTE (CORREO_ELECTRONICO, NOMBRE, APELLIDO,  DIRECCION, ESTADO, FECHA_REGISTRO, TIENDA_PREFERIDA, CIUDAD, CODIGO_POSTAL)
SELECT t.CORREO_CLIENTE, split_part(t.NOMBRE_CLIENTE ,' ',1), split_part(t.NOMBRE_CLIENTE  ,' ',2) , t.DIRECCION_CLIENTE , t.CLIENTE_ACTIVO , t.FECHA_CREACION , t2.ID_TIENDA , c.ID_CIUDAD , t.CODIGO_POSTAL_CLIENTE 
FROM TEMPORAL t INNER JOIN CIUDAD c ON t.CIUDAD_CLIENTE = c.NOMBRE 
INNER JOIN TIENDA t2 ON t.TIENDA_PREFERIDA = t2.NOMBRE 
INNER JOIN PAIS p ON p.NOMBRE = t.PAIS_CLIENTE AND c.PAIS = p.ID_PAIS 
WHERE t.CORREO_CLIENTE IS NOT NULL AND t.NOMBRE_CLIENTE IS NOT NULL AND t.DIRECCION_CLIENTE IS NOT NULL AND t.DIRECCION_CLIENTE IS NOT NULL AND t.CLIENTE_ACTIVO IS NOT NULL AND t.FECHA_CREACION IS NOT NULL 
AND t.CODIGO_POSTAL_CLIENTE IS NOT NULL 
GROUP BY t.CORREO_CLIENTE , t.NOMBRE_CLIENTE , t.DIRECCION_CLIENTE , t.CLIENTE_ACTIVO , t.FECHA_CREACION , t2.ID_TIENDA , c.ID_CIUDAD , t.CODIGO_POSTAL_CLIENTE ;

COMMIT;

-- Insertar en Tabla Actor
INSERT INTO ACTOR (NOMBRE, APELLIDO)
SELECT DISTINCT split_part(t.ACTOR_PELICULA ,' ',1), split_part(t.ACTOR_PELICULA  ,' ',2)
FROM TEMPORAL t 
WHERE t.ACTOR_PELICULA IS NOT NULL 
GROUP BY t.ACTOR_PELICULA ;

COMMIT;

-- Insertar en Tabla Categoria
INSERT INTO CATEGORIA (CATEGORIA)
SELECT DISTINCT t.CATEGORIA_PELICULA 
FROM TEMPORAL t 
WHERE t.CATEGORIA_PELICULA IS NOT NULL 
GROUP BY t.CATEGORIA_PELICULA ;

COMMIT;

-- Insertar en Tabla Clasificacion
INSERT INTO CLASIFICACION (CLASIFICACION)
SELECT DISTINCT t.CLASIFICACION 
FROM TEMPORAL t 
WHERE t.CLASIFICACION IS NOT NULL 
GROUP BY t.CLASIFICACION ;

COMMIT;

-- Insertar en Tabla Idioma
INSERT INTO IDIOMA (LENGUAJE)
SELECT DISTINCT t.LENGUAJE_PELICULA 
FROM TEMPORAL t 
WHERE t.LENGUAJE_PELICULA IS NOT NULL 
GROUP BY t.LENGUAJE_PELICULA ;

COMMIT;

-- Insertar en Tabla Pelicula
INSERT INTO PELICULA (NOMBRE, DESCRIPCION, ANO_LANZAMIENTO, DIAS_RENTA, COSTO_RENTA, DURACION, COSTO_POR_DANO, CLASIFICACION)
SELECT DISTINCT t.NOMBRE_PELICULA, t.DESCRIPCION_PELICULA , t.ANO_LANZAMIENTO , t.DIAS_RENTA , TO_NUMBER(t.COSTO_RENTA, '999999999999999999.99') AS COSTO_RENTA , t.DURACION , 
TO_NUMBER(t.COSTO_POR_DANO , '999999999999999999.99') AS COSTO_POR_DANO , c.ID_CLASIFICACION 
FROM TEMPORAL t INNER JOIN CLASIFICACION c ON t.CLASIFICACION = c.CLASIFICACION 
WHERE t.NOMBRE_PELICULA IS NOT NULL AND t.DESCRIPCION_PELICULA IS NOT NULL AND  t.ANO_LANZAMIENTO IS NOT NULL AND t.DIAS_RENTA IS NOT NULL AND COSTO_RENTA IS NOT NULL AND t.DURACION IS NOT NULL AND COSTO_POR_DANO IS NOT NULL
GROUP BY t.NOMBRE_PELICULA, t.DESCRIPCION_PELICULA  , t.ANO_LANZAMIENTO , t.DIAS_RENTA , COSTO_RENTA , t.DURACION , COSTO_POR_DANO , c.ID_CLASIFICACION ;

COMMIT;

-- Insertar en Tabla Inventario
INSERT INTO INVENTARIO (TIENDA, PELICULA, CANTIDAD)
SELECT DISTINCT t2.ID_TIENDA , p.ID_PELICULA ,count(t.NOMBRE_PELICULA) AS conteo_pelicula 
FROM TEMPORAL t 
INNER JOIN PELICULA p ON p.NOMBRE = t.NOMBRE_PELICULA 
INNER JOIN TIENDA t2 ON t.TIENDA_PELICULA = t2.NOMBRE 
WHERE t.NOMBRE_PELICULA IS NOT NULL
GROUP BY t2.ID_TIENDA , p.ID_PELICULA ;

COMMIT;

-- Insetar en Tabla Pelicula_Actor
INSERT INTO PELICULA_ACTOR (PELICULA, ACTOR)
SELECT DISTINCT p.ID_PELICULA , a.ID_ACTOR 
FROM TEMPORAL t INNER JOIN PELICULA p ON p.NOMBRE = t.NOMBRE_PELICULA 
INNER JOIN ACTOR a ON a.NOMBRE = split_part(t.ACTOR_PELICULA ,' ',1) AND a.APELLIDO =split_part(t.ACTOR_PELICULA ,' ',2)
GROUP BY p.ID_PELICULA , a.ID_ACTOR ;

COMMIT;

-- Insertar en Tabla Pelicula_Categoria
INSERT INTO PELICULA_CATEGORIA (PELICULA, CATEGORIA)
SELECT DISTINCT p.ID_PELICULA , c.ID_CATEGORIA 
FROM TEMPORAL t INNER JOIN PELICULA p ON p.NOMBRE = t.NOMBRE_PELICULA 
INNER JOIN CATEGORIA c ON c.CATEGORIA = t.CATEGORIA_PELICULA 
GROUP BY p.ID_PELICULA , c.ID_CATEGORIA ;

COMMIT;

-- Insertar en Tabla Pelicula_Idioma
INSERT INTO PELICULA_IDIOMA (PELICULA, IDIOMA)
SELECT DISTINCT p.ID_PELICULA , i.ID_IDIOMA 
FROM TEMPORAL t INNER JOIN PELICULA p ON p.NOMBRE = t.NOMBRE_PELICULA 
INNER JOIN IDIOMA i ON i.LENGUAJE = t.LENGUAJE_PELICULA 
GROUP BY p.ID_PELICULA , i.ID_IDIOMA ;

COMMIT;

-- Insertar en Tabla Factura
INSERT INTO FACTURA (CLIENTE, EMPLEADO, FECHA_RENTA, FECHA_RETORNO, MONTO_A_PAGAR, FECHA_PAGO, PELICULA, TIENDA)
SELECT c.ID_CLIENTE , e.ID_EMPLEADO , t.FECHA_RENTA , t.FECHA_RETORNO , TO_NUMBER(t.MONTO_A_PAGAR , '999999999999999999.99') AS MONTO_A_PAGAR, t.FECHA_PAGO , p.ID_PELICULA , t2.ID_TIENDA 
FROM TEMPORAL t INNER JOIN CLIENTE c ON t.CORREO_CLIENTE = c.CORREO_ELECTRONICO 
INNER JOIN EMPLEADO e ON e.CORREO_ELECTRONICO = t.CORREO_EMPLEADO 
INNER JOIN PELICULA p ON p.NOMBRE = t.NOMBRE_PELICULA 
INNER JOIN TIENDA t2 ON t2.NOMBRE = t.TIENDA_PREFERIDA 
WHERE t.CORREO_CLIENTE IS NOT NULL AND t.CORREO_EMPLEADO IS NOT NULL AND t.FECHA_RENTA IS NOT NULL AND MONTO_A_PAGAR IS NOT NULL AND t.FECHA_PAGO IS NOT NULL 
GROUP BY c.ID_CLIENTE , e.ID_EMPLEADO , t.FECHA_RENTA , t.FECHA_RETORNO , MONTO_A_PAGAR, t.FECHA_PAGO , p.ID_PELICULA , t2.ID_TIENDA ;

COMMIT;


