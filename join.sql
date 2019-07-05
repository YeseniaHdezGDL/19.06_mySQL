USE classicmodels;
/**/
SELECT lastname, firstname, jobtitle FROM employees;
SELECT lastname FROM employees ORDER BY lastname; /*aquí te regresa todos aunque se repitan*/
SELECT DISTINCT lastname FROM employees ORDER BY lastname; /*aquí regresa lastname sin repetirse*/
SELECT DISTINCT state, city FROM customers;
SELECT DISTINCT state FROM customers;
SELECT state FROM customers;
SELECT DISTINCT state FROM customers ORDER BY state;
SELECT contactLastname, contactFirstname FROM customers ORDER BY contactLastname; /*ordena default de manera ascendente*/
SELECT contactLastname, contactFirstname FROM customers ORDER BY contactLastname DESC;
SELECT lastname, firstname, jobtitle FROM employees WHERE jobtitle = 'Sales Rep' AND officeCode = 1;
SELECT * FROM employees WHERE jobtitle = 'Sales Rep' AND officeCode = 1;
SELECT lastname, firstname, jobtitle FROM employees WHERE jobtitle = 'Sales Rep' AND officeCode = 1;
SELECT lastname, firstname, jobtitle FROM employees WHERE officecode > 5;
SELECT lastname, firstname, jobtitle FROM employees WHERE officecode < 5;
SELECT lastname, firstname, jobtitle FROM employees WHERE officecode <= 5;
SELECT lastname, firstname, jobtitle FROM employees WHERE officecode BETWEEN 2 AND 5;
SELECT lastname, firstname, jobtitle FROM employees WHERE firstname LIKE '%a';
SELECT lastname, firstname, jobtitle FROM employees WHERE firstname LIKE 'a%';
SELECT * FROM customers WHERE country IN ('USA', 'France');
SELECT * FROM customers WHERE salesRepEmployeeNumber IS NULL;
SELECT customername, country, state, creditlimit FROM customers WHERE country = 'USA' AND state = 'CA' AND creditlimit > 100000;
SELECT customername, country FROM customers WHERE country = 'USA' OR country = 'France';
SELECT customername, country, creditlimit FROM customers WHERE country = 'USA' OR country = 'France' AND creditlimit > 100000;
SELECT customername, country, creditlimit FROM customers WHERE (country = 'USA' OR country = 'France') AND creditlimit > 100000;
SELECT CONCAT_WS(', ', lastName, firstname) AS `Full name` FROM employees;
SELECT c.customername, e.lastname, e.firstname, e.officecode FROM customers c INNER JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber WHERE e.officecode = 2;

USE classicmodels;
SELECT status FROM orders GROUP BY status;
SELECT lastname, firstname FROM employees WHERE officeCode IN (SELECT officeCode FROM offices WHERE country = 'USA');
SELECT * FROM orders WHERE orderNumber IN (SELECT * FROM customers WHERE country = 'USA');
SELECT * FROM customers WHERE country = 'USA';

/*OJO se tiene que seleccionar columna común entre ambas tablas*/
SELECT * FROM orders WHERE customerNumber IN (SELECT customerNumber FROM customers WHERE country = 'USA');

SELECT customerNumber, customerName FROM customers WHERE EXISTS (SELECT 2 FROM orders WHERE orders.customerNumber = customers.customerNumber);
SELECT customerNumber, customerName FROM customers WHERE NOT EXISTS (SELECT 2 FROM orders WHERE orders.customerNumber = customers.customerNumber);

SELECT * FROM productLines;
INSERT INTO productLines (productLine, textDescription) VALUES ('Vocho', 'El mejor carro de todos los tiempos');
INSERT INTO productLines (productLine) VALUES ('Vocho', 'El mejor carro de todos los tiempos'); /*error xq hay dos valores y sólo una columna seleccionada*/
SELECT lastname, email FROM employees WHERE employeeNumber = 1056;
UPDATE employees SET lastname = 'Hill', email = 'mary.hill@classicmodelcars.com' WHERE employeeNumber = 1056;
SELECT lastname, email FROM employees WHERE employeeNumber = 1056;
DELETE FROM productLines WHERE productLine = 'Vocho';
SELECT * FROM productLines;
SELECT AVG(buyPrice) average_buy_price FROM products;
SELECT COUNT(*) AS Total FROM products;
SELECT SUM(buyPrice) sum_buy_price FROM products;
SELECT productCode, SUM(priceEach * quantityOrdered) total FROM orderdetails GROUP BY productCode;

SELECT productName, buyPrice FROM products WHERE buyPrice = (SELECT MAX(buyPrice) precio_mas_alto FROM Products);

SELECT MIN(buyPrice) precio_mas_bajo, productName FROM Products;
SELECT productName, buyPrice FROM products WHERE buyPrice = (SELECT MIN(buyPrice) precio_mas_bajo FROM Products);

/*Ejercicios*/
/*Lista oficinas ordenadas por country, state, city*/
SELECT country, state, city FROM offices WHERE officeCode;
SELECT country, state, city FROM offices ORDER BY country, state, city;

/*líneas de productos que contienen cars*/
SELECT * FROM products WHERE productLine LIKE '%car%';
SELECT * FROM products WHERE productName LIKE '%Ford%';
SELECT * FROM products WHERE productName LIKE '%1968%';

/*Pagos mayores a 100,000*/
SELECT * FROM payments WHERE amount > 100000;

/*Mínimo pago recibido*/
SELECT customerNumber, amount FROM payments WHERE amount = (SELECT MIN(amount) min_payment FROM payments);

SELECT * FROM customers WHERE customerNumber IN
(SELECT customerNumber FROM payments WHERE amount = (SELECT MIN(amount) min_payment FROM payments));

SELECT * FROM customers INNER JOIN payments ON customers.customerNumber = payments.customerNumber 
	WHERE payments.amount = (SELECT MIN(amount) min_payment FROM payments);

/*empleados que trabajan en Boston*/
SELECT * FROM employees INNER JOIN offices ON employees.officeCode = offices.officeCode
	WHERE offices.city = 'Boston';
    
/*pagos de Atelier graphique*/
SELECT * FROM customers c INNER JOIN payments p ON c.customerNumber = p.customerNumber
	WHERE c.customerName = 'Atelier graphique';
    
/*Empleados que se llaman Larry o Barry*/
SELECT * FROM employees WHERE firstName LIKE '%Larry%' OR firstName LIKE '%Barry%';

/*Quien le reporta a William Patterson*/
SELECT * FROM employees WHERE lastname LIKE '%Patterson%' AND firstname LIKE '%William%';
SELECT reportsTo FROM employees WHERE lastname LIKE '%Patterson%' AND firstname LIKE '%William%';

/*Productos vendidos por fecha de orden*/
SELECT * FROM orders;
SELECT orderDate, customerNumber FROM orders ORDER BY shippedDate;

/*Producto que nunca se ha vendido*/
SELECT * FROM products;
SELECT customerNumber, customerName FROM customers WHERE EXISTS (SELECT 2 FROM orders WHERE orders.customerNumber = customers.customerNumber);

/*VIEWS*/
USE classicmodels;
CREATE VIEW customerOrders AS 
	SELECT 
		d.orderNumber, 
        customerName, 
        SUM(quantityOrdered * priceEach) total 
	FROM orderDetails d 
		INNER JOIN orders o ON o.orderNumber = d.orderNumber 
        INNER JOIN customers c ON c.customerNumber = c.customerNumber 
        GROUP BY d.orderNumber 
        ORDER BY total DESC;
SELECT * FROM customerOrders WHERE total > 100000;

CREATE TABLE employees_audit(
	id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    changeDat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

DELIMITER $$
CREATE TRIGGER before_employee_update
	BEFORE UPDATE ON employees
    FOR EACH ROW
BEGIN
	INSERT INTO employees_audit
    SET action='update',
    employeeNumber = OLD.employeeNumber,
		lastName = OLD.lastName,
        changeData = NOW();
END$$
DELIMITER ;

UPDATE employees SET lastName = 'Phan' WHERE employeeNumber = 1056;
ALTER TABLE employees_audit CHANGE changeDat changeData DATETIME DEFAULT NULL;
UPDATE employees SET lastName = 'Phan' WHERE employeeNumber = 1056;
SELECT * FROM employees_audit;

DELIMITER //
CREATE PROCEDURE GetAllProducts()
	BEGIN
    SELECT * FROM products;
    END //
DELIMITER ;

CALL GetAllProducts();

DELIMITER //
CREATE PROCEDURE testVariables()
	BEGIN
		DECLARE total_count INT DEFAULT 0;
        SELECT
			COUNT(*) INTO total_count
		FROM
			products;
		SELECT total_count;
    END //
DELIMITER ;

CALL testVariables();

DELIMITER //
CREATE PROCEDURE GetOfficeByCountry(IN countryName VARCHAR(255))
BEGIN
	SELECT *
    FROM offices
    WHERE country = countryName;
END //
DELIMITER ;

CALL GetOfficeByCountry('USA');
CALL GetOfficeByCountry('France');

DELIMITER $$
CREATE PROCEDURE CountOrderByStatus(
IN orderStatus VARCHAR(25),
OUT total INT)
BEGIN
	SELECT count(orderNumber)
    INTO total
    FROM orders
    WHERE status = orderStatus;
END $$
DELIMITER ;

CALL CountOrderByStatus('Shipped',@total);
SELECT @total;

DELIMITER $$
CREATE PROCEDURE set_counter(INOUT count INT(4), IN inc INT(4))
BEGIN
	SET count = count + inc;
END $$
DELIMITER ;

SET @counter = 1;
CALL set_counter(@counter, 1); -- 2
CALL set_counter(@counter, 1); -- 3
CALL set_counter(@counter, 5); -- 8
SELECT @counter; -- 8

SELECT
	SUM(CASE
		WHEN status = 'Shipped' THEN 1
        ELSE 0
	END) AS 'Shipped',
    SUM(CASE
		WHEN status = 'On Hold' THEN 1
        ELSE 0
	END) AS 'On Hold',
    COUNT(*) AS Total
FROM orders;

SELECT SUM(IF(status='Shipped', 1,0)) FROM orders
WHERE orderDate BETWEEN '2003-06-01' AND '2003-06-30';

SELECT
	SUM(IF(status = 'Shipped', 1, 0)) /
    NULLIF(SUM(IF(status = 'Cancelled', 1, 0)), 0)
FROM 
	orders
WHERE
	orderDate BETWEEN '2003-01-01' AND '2003-12-30';
    
    SELECT 
		customerName, city, COALESCE(state, 'N/A') AS res, country
	FROM
		customers;
        
CREATE TABLE IF NOT EXISTS revenues(
	company_id INT PRIMARY KEY,
    q1 DECIMAL (19, 2),
    q2 DECIMAL (19, 2),
    q3 DECIMAL (19, 2),
    q4 DECIMAL (19, 2)
);

SELECT * FROM revenues;

INSERT INTO revenues (company_id, q1, q2, q3, q4)
VALUES(1, 100, 120, 110, 130);

SELECT
	company_id,
    LEAST(q1, q2, q3, q4) low,
    GREATEST(q1, q2, q3, q4) high
FROM
	revenues;
    
SELECT * FROM offices WHERE !ISNULL(state);
SELECT * FROM offices;

SELECT CURDATE();
SELECT DATEDIFF('2011-08-17', '2019-08-08');

SELECT YEAR(NOW());
SELECT MONTH('2010-01-01');
SELECT DAY(last_day('2016-02-03'));

SELECT date_sub('2017-07-04', INTERVAL 365 DAY) result;

SELECT CONCAT('MySQL',' ','CONCAT');
SELECT CONCAT(lastname,' ','CONCAT') FROM employees LIMIT 1;

SELECT INSTR('MySQL INSTR', 's');

SELECT CHAR_LENGTH('otra cadena');

SELECT REPLACE('this text is about of', 'about', 'sobre');

SELECT RIGHT('MySQL', 2);
SELECT LEFT('MySQL', 2);
SELECT RTRIM(' MySQL TRIM Function ');

SELECT CEIL(1.1);
SELECT FLOOR(1.9);
SELECT MOD(11, 3);

SELECT ROUND(10.1, 3);
SELECT ROUND(10.1, 4);

SELECT TRUNCATE(10.1233534, 5);
