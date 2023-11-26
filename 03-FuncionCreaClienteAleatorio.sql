SELECT COUNT(*) FROM clientes; #Devuelve la cantidad de registros

SELECT * FROM clientes; #Devuelve todos los clientes

SELECT * FROM clientes LIMIT 5; #Devuelve los primeros 5 clientes

SELECT * FROM clientes LIMIT 5,1; #Devuelve despues del cliente x el siguiente elemento
/*SELECT * FROM clientes LIMIT 5,3; #Devuelve despues del cliente x los siguientes elementos*/

SELECT * FROM clientes LIMIT 16,1; #Devuelve nulo si estoy fuera del rango

SELECT * FROM clientes LIMIT 0,1;

SELECT f_cliente_aleatorio() AS CLIENTE_DNI;