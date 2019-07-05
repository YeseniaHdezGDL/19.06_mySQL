CREATE DATABASE Tienda_zapatos;
USE Tienda_zapatos;
CREATE TABLE zapatos(
	zapato_id INT NOT NULL AUTO_INCREMENT,
	talla INT NOT NULL,
    precio NUMERIC NOT NULL,
    descripción VARCHAR(45) NULL,
    altura VARCHAR(30),
    modelo VARCHAR(100),
	CONSTRAINT zapatos_PK PRIMARY KEY (zapato_id)
);
CREATE TABLE colores(
	color_id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    CONSTRAINT colores_PK PRIMARY KEY (color_id)
);
ALTER TABLE zapatos ADD color_id INT NOT NULL;
ALTER TABLE zapatos ADD CONSTRAINT zapatos_FK FOREIGN KEY (color_id) REFERENCES colores(color_id);
CREATE TABLE materiales (
	material_id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(64) NOT NULL,
    descripción TEXT NULL,
    CONSTRAINT materiales_PK PRIMARY KEY (material_id)
);
ALTER TABLE zapatos ADD material_id INT NOT NULL;
ALTER TABLE zapatos ADD CONSTRAINT zapatos_FK_1 FOREIGN KEY (material_id) REFERENCES materiales(material_id);

CREATE TABLE ventas (
	ventas_id INT NOT NULL AUTO_INCREMENT,
	fechas VARCHAR(20) NOT NULL,
	CONSTRAINT ventas_PK PRIMARY KEY (ventas_id)
);
ALTER TABLE ventas ADD zapato_id INT NOT NULL;
ALTER TABLE ventas ADD CONSTRAINT ventas_FK FOREIGN KEY (zapato_id) REFERENCES zapatos(zapato_id);

CREATE TABLE empleados (
	empleado_id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(128) NOT NULL,
    CONSTRAINT empleados_PK PRIMARY KEY (empleado_id)
);
SELECT * FROM zapatos;
SHOW COLUMNS FROM zapatos;

ALTER TABLE ventas ADD empleado_id INT NOT NULL;
ALTER TABLE ventas ADD CONSTRAINT ventas_FK_1 FOREIGN KEY (empleado_id) REFERENCES empleados(empleado_id);

CREATE TABLE existencias (
	existencia_id INT NOT NULL AUTO_INCREMENT,
    fecha_entrada VARCHAR(20) NOT NULL,
    fecha_salida VARCHAR(20) NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT existencias_PK PRIMARY KEY (existencia_id)
);
ALTER TABLE existencias ADD zapato_id INT NOT NULL;
ALTER TABLE existencias ADD CONSTRAINT existencias_FK FOREIGN KEY (zapato_id) REFERENCES zapatos(zapato_id);

CREATE TABLE sucursales (
	sucursales_id INT NOT NULL AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    CONSTRAINT sucursales_pk primary key (sucursal_id)
);

CREATE TABLE sucursales_existencias (
	sucursal_existencia_id INT NOT NULL AUTO_INCREMENT,
    sucursal_id INT NOT NULL,
    existencia_id INT NOT NULL,
    CONSTRAINT sucursales_existencias_PK PRIMARY KEY (sucursal_existencia_id),
    CONSTRAINT sucursales_existencias_FK FOREIGN KEY (sucursal_id) REFERENCES sucursales(sucursal_id),
    CONSTRAINT sucursales_existencias_FK_1 FOREIGN KEY (existencia_id) REFERENCES existencias(existencia_id)
);