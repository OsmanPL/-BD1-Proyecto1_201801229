/* 1. Mostrar la cantidad de copias que existen en el inventario para la pel�cula
�Sugar Wonka�.*/

SELECT p.NOMBRE ,SUM( i.CANTIDAD) AS TOTAL 
FROM INVENTARIO i INNER JOIN PELICULA p ON i.PELICULA = p.ID_PELICULA 
WHERE p.NOMBRE = 'SUGAR WONKA' GROUP BY p.NOMBRE /*, i.TIENDA */; 

/* 2. Mostrar el nombre, apellido y pago total de todos los clientes que han rentado
pel�culas por lo menos 40 veces. */

SELECT  c.NOMBRE, c.APELLIDO ,SUM(f.MONTO_A_PAGAR) AS Total_Pagar /*, COUNT (f.CLIENTE) AS Veces*/
FROM FACTURA f INNER JOIN CLIENTE c ON c.ID_CLIENTE = f.CLIENTE 
GROUP BY c.NOMBRE , c.APELLIDO 
HAVING COUNT(f.CLIENTE) >=40 ;

/* 3. Mostrar el nombre y apellido del cliente y el nombre de la pel�cula de todos
aquellos clientes que hayan rentado una pel�cula y no la hayan devuelto y
donde la fecha de alquiler est� m�s all� de la especificada por la pel�cula. */

SELECT CONCAT(c.NOMBRE , CONCAT(' ',c.APELLIDO)) AS Nombre_Cliente , p.NOMBRE AS Nombre_Pelicula /*, f.FECHA_RENTA , f.FECHA_RETORNO , TRUNC(FECHA_RETORNO)-TRUNC(FECHA_RENTA) , p.DIAS_RENTA */
FROM FACTURA f INNER JOIN CLIENTE c ON f.CLIENTE = c.ID_CLIENTE
INNER JOIN PELICULA p ON p.ID_PELICULA = f.PELICULA 
WHERE f.FECHA_RETORNO IS NULL OR  TRUNC(FECHA_RETORNO)-TRUNC(FECHA_RENTA) >p.DIAS_RENTA ;  

/* 4. Mostrar el nombre y apellido (en una sola columna) de los actores que
contienen la palabra �SON� en su apellido, ordenados por su primer nombre. */

SELECT CONCAT(a.NOMBRE , CONCAT(' ',a.APELLIDO)) 
FROM  ACTOR a 
WHERE a.APELLIDO LIKE '%son%' ORDER BY a.NOMBRE ASC;

/* 5. Mostrar el apellido de todos los actores y la cantidad de actores que tienen
ese apellido pero solo para los que comparten el mismo nombre por lo menos
con dos actores. */

SELECT  a.APELLIDO , COUNT(a.APELLIDO) AS Cantidad 
FROM ACTOR a 
GROUP BY a.APELLIDO 
HAVING COUNT (a.NOMBRE) >= 2; 

/* 6. Mostrar el nombre y apellido de los actores que participaron en una pel�cula
que involucra un �Cocodrilo� y un �Tibur�n� junto con el a�o de lanzamiento
de la pel�cula, ordenados por el apellido del actor en forma ascendente. */

SELECT a.NOMBRE , a.APELLIDO , p.ANO_LANZAMIENTO 
FROM ACTOR a INNER JOIN PELICULA_ACTOR pa ON pa.ACTOR = a.ID_ACTOR 
INNER JOIN PELICULA p ON p.ID_PELICULA = pa.PELICULA 
WHERE p.DESCRIPCION LIKE '%Crocodile%' AND p.DESCRIPCION LIKE '%Shark%';

/* 7. Mostrar el nombre de la categor�a y el n�mero de pel�culas por categor�a de
todas las categor�as de pel�culas en las que hay entre 55 y 65 pel�culas.
Ordenar el resultado por n�mero de pel�culas de forma descendente. */

SELECT c.CATEGORIA , COUNT(p.NOMBRE) AS Cantidad 
FROM CATEGORIA c INNER JOIN PELICULA_CATEGORIA pc ON pc.CATEGORIA = c.ID_CATEGORIA 
INNER JOIN PELICULA p ON p.ID_PELICULA = pc.PELICULA 
HAVING COUNT(p.NOMBRE) BETWEEN 55 AND 65
GROUP BY c.CATEGORIA ORDER BY Cantidad DESC;

/* 8. Mostrar todas las categor�as de pel�culas en las que la diferencia promedio
entre el costo de reemplazo de la pel�cula y el precio de alquiler sea superior
a 17. */

SELECT  c.CATEGORIA , ROUND(AVG(p.COSTO_POR_DANO - COSTO_RENTA),2) AS Diferencia_Promedio
FROM PELICULA p  INNER JOIN PELICULA_CATEGORIA pc ON pc.PELICULA = p.ID_PELICULA 
INNER JOIN CATEGORIA c ON c.ID_CATEGORIA = pc.CATEGORIA 
GROUP BY c.CATEGORIA 
HAVING  ROUND(AVG(p.COSTO_POR_DANO - COSTO_RENTA),2) > 17;

/* 9. Mostrar el t�tulo de la pel�cula, el nombre y apellido del actor de todas
aquellas pel�culas en las que uno o m�s actores actuaron en dos o m�s
pel�culas. */

SELECT DISTINCT p.NOMBRE AS NOMBRE_PELICULA, a.NOMBRE AS NOMBRE_ACTOR, a.APELLIDO AS APELLIDO_ACTOR
FROM PELICULA p INNER JOIN PELICULA_ACTOR pa ON pa.PELICULA = p.ID_PELICULA 
INNER JOIN ACTOR a ON pa.ACTOR = pa.ACTOR 
GROUP BY p.NOMBRE , a.NOMBRE , a.APELLIDO
HAVING COUNT(pa.ACTOR) > 2  ;

/* 10. Mostrar el nombre y apellido (en una sola columna) de todos los actores y
clientes cuyo primer nombre sea el mismo que el primer nombre del actor con
ID igual a 8. No debe retornar el nombre del actor con ID igual a 8 */

SELECT CONCAT(NOMBRES, CONCAT(' ', APELLIDOS)) AS Nombre_Completo
FROM 
(SELECT c.NOMBRE AS NOMBRES, c.APELLIDO AS APELLIDOS FROM CLIENTE c
UNION 
SELECT a.NOMBRE AS NOMBRES, a.APELLIDO AS APELLIDOS FROM ACTOR a)
INNER JOIN 
(SELECT a2.NOMBRE AS NOMBRE_ACTOR, a2.APELLIDO AS APELLIDO_ACTOR 
FROM ACTOR a2
WHERE a2.NOMBRE LIKE 'Matthew%' AND a2.APELLIDO LIKE '%Johansson')
ON NOMBRES = NOMBRE_ACTOR 
WHERE APELLIDOS <> APELLIDO_ACTOR;

/* 11. Mostrar el pa�s y el nombre del cliente que m�s pel�culas rent� as� como
tambi�n el porcentaje que representa la cantidad de pel�culas que rent� con
respecto al resto de clientes del pa�s. */

SELECT Nombre, Apellido, Pais, Porcentaje FROM
(SELECT Nombre, Apellido , Pais, ROUND((Cantidad_Rentas_Cliente * 100) / Cantidad_Rentas_Pais, 2) AS Porcentaje, ROW_NUMBER() OVER(PARTITION BY Pais ORDER BY Pais) AS NumeroFila
FROM 
(SELECT c.NOMBRE AS Nombre , c.APELLIDO AS Apellido , COUNT(f.CLIENTE) AS Cantidad_Rentas_Cliente, p.NOMBRE AS Pais
FROM FACTURA f INNER JOIN CLIENTE c ON c.ID_CLIENTE = f.CLIENTE 
INNER JOIN CIUDAD c2 ON c.CIUDAD = c2.ID_CIUDAD 
INNER JOIN PAIS p ON p.ID_PAIS = c2.PAIS 
GROUP BY c.NOMBRE , c.APELLIDO , p.NOMBRE 
ORDER BY  p.NOMBRE , COUNT(f.CLIENTE) DESC )
INNER JOIN 
(SELECT COUNT(p.NOMBRE) AS Cantidad_Rentas_Pais ,p.NOMBRE AS Nombre_Pais
FROM FACTURA f INNER JOIN CLIENTE c ON c.ID_CLIENTE = f.CLIENTE 
INNER JOIN CIUDAD c2 ON c.CIUDAD = c2.ID_CIUDAD 
INNER JOIN PAIS p ON p.ID_PAIS = c2.PAIS 
GROUP BY p.NOMBRE 
ORDER BY  p.NOMBRE , COUNT(p.NOMBRE) DESC)
ON Pais = Nombre_Pais
GROUP BY Nombre, Apellido, Pais, ((Cantidad_Rentas_Cliente * 100) / Cantidad_Rentas_Pais) )
WHERE NumeroFila=1 
ORDER BY Porcentaje DESC; 

/* 12. Mostrar el total de clientes y porcentaje de clientes mujeres por ciudad y pa�s.
El ciento por ciento es el total de mujeres por pa�s. (Tip: Todos los
porcentajes por ciudad de un pa�s deben sumar el 100%). */



/* 13. Mostrar el nombre del pa�s, nombre del cliente y n�mero de pel�culas
rentadas de todos los clientes que rentaron m�s pel�culas por pa�s. Si el
n�mero de pel�culas m�ximo se repite, mostrar todos los valores que
representa el m�ximo. */

SELECT Pais, Cliente, Maximo
FROM 
(SELECT Pais, MAX(Cantidad) AS Maximo
FROM
(SELECT  p.NOMBRE AS Pais, CONCAT(c2.NOMBRE, CONCAT(' ', c2.APELLIDO)) AS Nombre_Cliente, COUNT(f.CLIENTE) AS Cantidad 
FROM PAIS p INNER JOIN CIUDAD c ON c.PAIS = p.ID_PAIS 
INNER JOIN CLIENTE c2 ON c2.CIUDAD = c.ID_CIUDAD 
INNER JOIN FACTURA f ON c2.ID_CLIENTE = f.CLIENTE 
GROUP BY p.NOMBRE, CONCAT(c2.NOMBRE, CONCAT(' ', c2.APELLIDO))
ORDER BY p.NOMBRE , COUNT(f.CLIENTE) DESC )
GROUP BY Pais ORDER BY Pais)
INNER JOIN 
(SELECT  p.NOMBRE AS Nombre_Pais, CONCAT(c2.NOMBRE, CONCAT(' ', c2.APELLIDO)) AS Cliente, COUNT(f.CLIENTE) AS Cantidad_Rentas
FROM PAIS p INNER JOIN CIUDAD c ON c.PAIS = p.ID_PAIS 
INNER JOIN CLIENTE c2 ON c2.CIUDAD = c.ID_CIUDAD 
INNER JOIN FACTURA f ON c2.ID_CLIENTE = f.CLIENTE 
GROUP BY p.NOMBRE, CONCAT(c2.NOMBRE, CONCAT(' ', c2.APELLIDO))
ORDER BY p.NOMBRE , COUNT(f.CLIENTE) DESC ) ON Pais = Nombre_Pais
WHERE Cantidad_Rentas = Maximo;

/* 14.Mostrar todas las ciudades por pa�s en las que predomina la renta de
pel�culas de la categor�a �Horror�. Es decir, hay m�s rentas que las otras
categor�as. */

SELECT Ciudad, Categoria, Cantidad
FROM
(SELECT Ciudad, Categoria, Cantidad , ROW_NUMBER() OVER(PARTITION BY Ciudad ORDER BY Ciudad ASC) AS NumeroFila 
FROM  (SELECT c3.NOMBRE AS Ciudad, c.CATEGORIA AS Categoria , COUNT(f.PELICULA) AS Cantidad
FROM CATEGORIA c INNER JOIN  PELICULA_CATEGORIA pc ON pc.CATEGORIA = c.ID_CATEGORIA 
INNER JOIN PELICULA p ON p.ID_PELICULA = pc.PELICULA 
INNER JOIN FACTURA f ON f.PELICULA = p.ID_PELICULA 
INNER JOIN CLIENTE c2 ON c2.ID_CLIENTE = f.CLIENTE 
INNER JOIN CIUDAD c3 ON c3.ID_CIUDAD = c2.CIUDAD 
GROUP BY c3.NOMBRE , c.CATEGORIA 
ORDER BY c3.NOMBRE  , COUNT(f.PELICULA) DESC))
WHERE NumeroFila = 1 AND Categoria='Horror';

/* 15.Mostrar el nombre del pa�s, la ciudad y el promedio de rentas por ciudad. Por
ejemplo: si el pa�s tiene 3 ciudades, se deben sumar todas las rentas de la
ciudad y dividirlo dentro de tres (n�mero de ciudades del pa�s). */

SELECT Nombre_Pais, Ciudad, ROUND(Cantidad_Rentas_Ciudad / Cantidad_Ciudades,2) AS Promedio FROM 
(SELECT COUNT(f.CLIENTE) AS Cantidad_Rentas_Ciudad, c2.NOMBRE AS Ciudad, p2.NOMBRE AS Pais
FROM FACTURA f INNER JOIN CLIENTE c ON c.ID_CLIENTE = f.CLIENTE 
INNER JOIN CIUDAD c2 ON c.CIUDAD = c2.ID_CIUDAD 
INNER JOIN PAIS p2 ON p2.ID_PAIS = c2.PAIS 
GROUP BY c2.NOMBRE , p2.NOMBRE  )
INNER JOIN 
(SELECT COUNT(c2.ID_CIUDAD) AS Cantidad_Ciudades ,p.NOMBRE AS Nombre_Pais
FROM CIUDAD c2 INNER JOIN PAIS p ON p.ID_PAIS = c2.PAIS 
GROUP BY p.NOMBRE 
ORDER BY  p.NOMBRE , COUNT(c2.ID_CIUDAD) DESC) ON Pais = Nombre_Pais;


/* 16.Mostrar el nombre del pa�s y el porcentaje de rentas de pel�culas de la
categor�a �Sports�. */
SELECT Pais, ROUND((Rentas_Categoria/Rentas_Pais)*100,2) AS Porcentaje
FROM 
(SELECT p.NOMBRE AS Pais, c3.CATEGORIA AS Categoria ,COUNT(f.CLIENTE) AS Rentas_Categoria 
FROM PAIS p INNER JOIN CIUDAD c ON c.PAIS = p.ID_PAIS 
INNER JOIN CLIENTE c2 ON c2.CIUDAD = c.ID_CIUDAD 
INNER JOIN FACTURA f ON f.CLIENTE = c2.ID_CLIENTE 
INNER JOIN PELICULA p2 ON f.PELICULA = p2.ID_PELICULA 
INNER JOIN PELICULA_CATEGORIA pc ON pc.PELICULA = p2.ID_PELICULA 
INNER JOIN CATEGORIA c3 ON c3.ID_CATEGORIA = pc.CATEGORIA 
WHERE c3.CATEGORIA = 'Sports'
GROUP BY p.NOMBRE, c3.CATEGORIA)
INNER JOIN 
(SELECT p.NOMBRE AS Nombre_Pais, COUNT(f.CLIENTE) AS Rentas_Pais 
FROM PAIS p INNER JOIN CIUDAD c ON c.PAIS = p.ID_PAIS 
INNER JOIN CLIENTE c2 ON c2.CIUDAD = c.ID_CIUDAD 
INNER JOIN FACTURA f ON f.CLIENTE = c2.ID_CLIENTE 
GROUP BY p.NOMBRE) ON Pais=Nombre_Pais
GROUP BY Pais,(Rentas_Categoria/Rentas_Pais)*100 ;

/* 17.Mostrar la lista de ciudades de Estados Unidos y el n�mero de rentas de
pel�culas para las ciudades que obtuvieron m�s rentas que la ciudad
�Dayton�. */

SELECT Ciudad, Rentas
FROM 
(SELECT c.NOMBRE AS Ciudad, COUNT(f.CLIENTE) AS Rentas 
FROM FACTURA f INNER JOIN CLIENTE c2 ON c2.ID_CLIENTE= f.CLIENTE
INNER JOIN CIUDAD c ON c.ID_CIUDAD = c2.CIUDAD 
INNER JOIN PAIS p ON p.ID_PAIS = c.PAIS
WHERE p.NOMBRE = 'United States'
GROUP BY c.NOMBRE ORDER BY c.NOMBRE)
INNER JOIN
(SELECT c.NOMBRE AS Nombre_Ciudad, COUNT(f.CLIENTE) AS Rentas_Dayton 
FROM FACTURA f INNER JOIN CLIENTE c2 ON c2.ID_CLIENTE= f.CLIENTE
INNER JOIN CIUDAD c ON c.ID_CIUDAD = c2.CIUDAD 
INNER JOIN PAIS p ON p.ID_PAIS = c.PAIS
WHERE p.NOMBRE = 'United States' AND c.NOMBRE = 'Dayton'
GROUP BY c.NOMBRE ORDER BY c.NOMBRE) ON Rentas > Rentas_Dayton;

/* 18.Mostrar el nombre, apellido y fecha de retorno de pel�cula a la tienda de todos
los clientes que hayan rentado m�s de 2 pel�culas que se encuentren en
lenguaje Ingl�s en donde el empleado que se las vendi� ganar� m�s de 15
d�lares en sus rentas del d�a en la que el cliente rent� la pel�cula. */

SELECT c.NOMBRE AS Nombre_Cliente, c.APELLIDO AS Apellido_Cliente, TRUNC(f.FECHA_RETORNO) AS Retorno
FROM IDIOMA i INNER JOIN PELICULA_IDIOMA pi2 ON i.ID_IDIOMA = pi2.IDIOMA 
INNER JOIN PELICULA p ON p.ID_PELICULA = pi2.PELICULA 
INNER JOIN FACTURA f ON f.PELICULA = p.ID_PELICULA 
INNER JOIN  CLIENTE c ON f.CLIENTE = c.ID_CLIENTE 
WHERE i.LENGUAJE LIKE '%English%'
GROUP BY c.NOMBRE , c.APELLIDO , TRUNC( f.FECHA_RETORNO) 
HAVING COUNT(f.CLIENTE) > 2 AND SUM(f.MONTO_A_PAGAR)>15 ;

/* 19.Mostrar el n�mero de mes, de la fecha de renta de la pel�cula, nombre y
apellido de los clientes que m�s pel�culas han rentado y las que menos en
una sola consulta. */



/* 20.Mostrar el porcentaje de lenguajes de pel�culas m�s rentadas de cada ciudad
durante el mes de julio del a�o 2005 de la siguiente manera: ciudad,
lenguaje, porcentaje de renta.*/


SELECT Lenguaje, Ciudad, ROUND((Rentas_Lenguaje/Rentas)*100,2) AS Porcentaje
FROM 
(SELECT c.NOMBRE AS Ciudad, i.LENGUAJE AS Lenguaje ,COUNT(f.CLIENTE) AS Rentas_Lenguaje,TO_CHAR(f.FECHA_RENTA, 'yyyy') AS Ano, TO_CHAR(f.FECHA_RENTA, 'mm') AS Mes
FROM CIUDAD c INNER JOIN CLIENTE c2 ON c2.CIUDAD = c.ID_CIUDAD 
INNER JOIN FACTURA f ON f.CLIENTE = c2.ID_CLIENTE 
INNER JOIN PELICULA p2 ON f.PELICULA = p2.ID_PELICULA 
INNER JOIN PELICULA_IDIOMA pi2 ON p2.ID_PELICULA = pi2.PELICULA 
INNER JOIN IDIOMA i ON i.ID_IDIOMA = pi2.IDIOMA 
GROUP BY c.NOMBRE , i.LENGUAJE ,TO_CHAR(f.FECHA_RENTA, 'yyyy'), TO_CHAR(f.FECHA_RENTA, 'mm')
HAVING TO_CHAR(f.FECHA_RENTA, 'yyyy')=2005 AND TO_CHAR(f.FECHA_RENTA, 'mm')=07)
INNER JOIN 
(SELECT c.NOMBRE AS Nombre_Ciudad, COUNT(f.CLIENTE) AS Rentas 
FROM FACTURA f INNER JOIN CLIENTE c2 ON c2.ID_CLIENTE= f.CLIENTE
INNER JOIN CIUDAD c ON c.ID_CIUDAD = c2.CIUDAD 
GROUP BY c.NOMBRE ORDER BY c.NOMBRE) ON Nombre_Ciudad = Ciudad
GROUP BY Lenguaje, Ciudad, ROUND((Rentas_Lenguaje/Rentas)*100,2);



