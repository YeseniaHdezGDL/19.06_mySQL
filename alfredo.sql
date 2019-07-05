USE classicmodels;
SELECT customerName, contactLastName, phone, country, city FROM customers;
SELECT customerName, contactLastName, phone, country, city FROM customers WHERE city IN ('NYC');
SELECT * FROM customers WHERE country IN ('Australia');

SELECT customerName FROM customers ORDER BY creditLimit DESC LIMIT 1;
SELECT customerName, max(creditLimit) as maximo FROM customers;

SELECT customerName, contactLastName, phone, country, MAX(creditLimit) AS maximo FROM customers WHERE country = 'Australia';
SELECT customerName, contactLastName, phone, country, MAX(creditLimit) AS maximo FROM customers WHERE city = 'NYC';

Select country, MAX(customerNumber) AS countwitMoreCustoms FROM customers;
SELECT country, count(*) from customers GROUP BY country ORDER BY country DESC;
SELECT MAX(COUNT(creditLimit));

/*Count all employees*/
SELECT count(*) FROM employees;

/*Count employees by job tittle*/
SELECT count(jobTitle) FROM employees GROUP BY jobTitle;
SELECT jobtitle, COUNT(*) AS num FROM employees GROUP BY jobTitle ORDER BY num DESC;

/*Order employees by Number*/

/*Get employees by office*/
SELECT 
	o.city,
    e.firstName
FROM employees AS e, offices as o
WHERE
	e.officeCode = o.officeCode;
    
SELECT
	o.city,
    e.firstName
FROM employees AS e INNER JOIN offices AS o
ON
	e.officeCode = o.officeCode;

/*Get employees reporter*/

USE tienda_zapatos;
INSERT INTO empleados (nombre) VALUES ('Yesenia');

SELECT * FROM empleados;

UPDATE empleados SET nombre = 'Maria' WHERE empleado_id = 1;





 