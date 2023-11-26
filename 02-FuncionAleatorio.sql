/*Funcion para crear numeros aleatorios*/

SELECT RAND(); #Devuelve numeros aleatorios entre 0 y 1

/*Creacion de algoritmo para hacer un numero aleatorio entre x e Y*/

#(RAND() * (MAX-MIN+1)) + MIN


SELECT (RAND() * (250 -20+1))+20 AS ALEATORIO;

#Para generar un numero entero

SELECT FLOOR((RAND() * (250 -20+1))+20) AS ALEATORIO;

/*Crear una funcion para insertar un valor minimo y maximo*/

SET GLOBAL log_bin_trust_function_creators = 1; #Este comando permite crear funciones

SELECT f_aleatorio(1,10) AS RESULTADO;