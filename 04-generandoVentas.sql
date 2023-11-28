/*Muestra de funciones creadas*/

SELECT f_cliente_aleatorio() AS CLIENTE,
f_producto_aleatorio() AS PRODUCTO,
f_vendedor_aleatorio() AS VENDEDOR;

/*obtener numero de facturas*/

SELECT MAX(NUMERO) FROM facturas;

/**/

CALL sp_venta('20231126', 15, 100);

SELECT MAX(NUMERO) FROM facturas;

SELECT COUNT(*) FROM facturas;

SELECT NUMERO FROM FACTURAS ORDER BY NUMERO DESC LIMIT 88000; #La variable esta guardad como varchar, por lo que toma como maximo el 9999

CREATE TABLE facturas(
	NUMERO INT NOT NULL,
    FECHA DATE,
    DNI VARCHAR(11) NOT NULL, #Las claves extranjeras no pueden ser null (al igual que las primary key)
    MATRICULA VARCHAR(5) NOT NULL,
    IMPUESTO FLOAT,
    PRIMARY KEY(NUMERO),
    FOREIGN KEY(DNI) REFERENCES clientes(DNI), 
    FOREIGN KEY(MATRICULA) REFERENCES vendedores(MATRICULA)
);

CREATE TABLE items(
NUMERO INT NOT NULL,
CODIGO VARCHAR(10) NOT NULL,
CANTIDAD INT,
PRECIO FLOAT,
PRIMARY KEY(NUMERO, codigo),
FOREIGN KEY(NUMERO) REFERENCES facturas(NUMERO),
FOREIGN KEY(CODIGO) REFERENCES productos(CODIGO)
);

INSERT INTO items
SELECT NUMERO, CODIGO_DEL_PRODUCTO AS CODIGO, CANTIDAD, PRECIO FROM jugos_ventas.items_facturas ;

INSERT INTO facturas
SELECT NUMERO, FECHA_VENTA AS FECHA, DNI, MATRICULA, IMPUESTO
FROM jugos_ventas.facturas;


/**/
CALL sp_venta('20210619', 3, 100);


/*Generacion de factiruacion*/

SELECT A.FECHA, SUM(B.CANTIDAD*B.PRECIO) AS FACTURACION FROM
facturas A
INNER JOIN
items B
ON A.NUMERO = B.NUMERO
WHERE A.FECHA = '20210619'
GROUP BY A.FECHA;

CALL sp_venta('20210619', 3, 100); #Al probar sigue agregando

/*Modificar el store procedure para que no se repita la factura con otro numero*/

CALL sp_venta('20210619', 100, 100); #Al probar genera items sin duplicidad gracias al where

/*
En la tabla de facturas tenemos el valor del impuesto. En la tabla de ítems tenemos 
la cantidad y la facturación. Calcula el valor del impuesto pago en el año de 2021
 redondeando al mayor entero.
*/

SELECT YEAR(FECHA), CEIL(SUM(IMPUESTO * (CANTIDAD * PRECIO))) 
AS RESULTADO
FROM facturas F
INNER JOIN items I ON F.NUMERO = I.NUMERO
WHERE YEAR(FECHA) = 2021
GROUP BY YEAR(FECHA);

/*
 Se debe hacer triggers para que llame un stored procedures y permita trar todas las modificaicones
*/

CREATE TABLE facturacion(
FECHA DATE NULL,
VENTA_TOTAL FLOAT
);

DELIMITER //
CREATE TRIGGER TG_FACTURACION_INSERT 
AFTER INSERT ON items
FOR EACH ROW BEGIN
  DELETE FROM facturacion;
  INSERT INTO facturacion
  SELECT A.FECHA, SUM(B.CANTIDAD * B.PRECIO) AS VENTA_TOTAL
  FROM facturas A
  INNER JOIN
  items B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.FECHA;
END //

DELIMITER //
CREATE TRIGGER TG_FACTURACION_DELETE
AFTER DELETE ON items
FOR EACH ROW BEGIN
  DELETE FROM facturacion;
  INSERT INTO facturacion
  SELECT A.FECHA, SUM(B.CANTIDAD * B.PRECIO) AS VENTA_TOTAL
  FROM facturas A
  INNER JOIN
  items B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.FECHA;
END //

DELIMITER //
CREATE TRIGGER TG_FACTURACION_UPDATE
AFTER UPDATE ON items
FOR EACH ROW BEGIN
  DELETE FROM facturacion;
  INSERT INTO facturacion
  SELECT A.FECHA, SUM(B.CANTIDAD * B.PRECIO) AS VENTA_TOTAL
  FROM facturas A
  INNER JOIN
  items B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.FECHA;
END //

/*Luego de crear*/

SELECT * FROM facturacion; #VACIA

CALL sp_venta('20231127',15,100);

SELECT * FROM facturacion WHERE FECHA = '20231127';

DROP TRIGGER TG_FACTURACION_INSERT;
DROP TRIGGER TG_FACTURACION_DELETE;
DROP TRIGGER TG_FACTURACION_UPDATE;

DELIMITER //
CREATE TRIGGER TG_FACTURACION_INSERT 
AFTER INSERT ON items
FOR EACH ROW BEGIN
 CALL sp_triggers;
END //

DELIMITER //
CREATE TRIGGER TG_FACTURACION_DELETE
AFTER DELETE ON items
FOR EACH ROW BEGIN
  CALL sp_triggers;
END //

DELIMITER //
CREATE TRIGGER TG_FACTURACION_UPDATE
AFTER UPDATE ON items
FOR EACH ROW BEGIN
  CALL sp_triggers;
END //
