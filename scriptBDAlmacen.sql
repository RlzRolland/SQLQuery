CREATE SCHEMA almacen AUTHORIZATION postgres;

CREATE TABLE almacen.cajeros (
	cajero int4 NOT NULL,
	nomapels varchar(255) NULL,
	CONSTRAINT cajeros_pkey PRIMARY KEY (cajero)
);

CREATE TABLE almacen.maquinas_registradoras (
	maquina int4 NOT NULL,
	piso int4 NULL,
	CONSTRAINT maquinas_registradoras_pkey PRIMARY KEY (maquina)
);


CREATE TABLE almacen.productos (
	producto int4 NOT NULL,
	nombre varchar(100) NULL,
	precio money NULL,
	CONSTRAINT productos_pkey PRIMARY KEY (producto)
);

CREATE TABLE almacen.venta (
	cajero int4 NULL,
	maquina int4 NULL,
	producto int4 NULL,
	CONSTRAINT fkcajero FOREIGN KEY (cajero) REFERENCES almacen.cajeros(cajero),
	CONSTRAINT fkmaquinas FOREIGN KEY (maquina) REFERENCES almacen.maquinas_registradoras(maquina),
	CONSTRAINT fkproducto FOREIGN KEY (producto) REFERENCES almacen.productos(producto)
);

INSERT INTO almacen.cajeros (cajero,nomapels) VALUES
	 (1,'cajero1'),
	 (2,'cajero2'),
	 (3,'cajero3');

INSERT INTO almacen.maquinas_registradoras (maquina,piso) VALUES
	 (1,2),
	 (2,4),
	 (3,1);

INSERT INTO almacen.productos (producto,nombre,precio) VALUES
	 (1,'television',5.000,00 €),
	 (2,'licuadora',450,00 €),
	 (3,'playstation 5',12.000,00 €),
	 (4,'audifonos',850,00 €);

INSERT INTO almacen.venta (cajero,maquina,producto) VALUES
	 (1,1,2),
	 (1,2,3),
	 (2,2,4),
	 (3,3,1),
	 (2,1,1),
	 (2,3,1),
	 (1,3,4),
	 (2,3,2);

/*Mostrar el número de ventas de cada producto, ordenado de más a menos ventas.*/

select producto, count(producto) as contador from almacen.venta group by producto order by contador desc

/*Obtener un informe completo de ventas, indicando el nombre del cajero que realizo la venta, nombre y precios de los productos vendidos, y el piso en el que se encuentra la máquina registradora donde se realizó la venta.*/

select almacen.cajeros.nomapels, almacen.productos.nombre, almacen.productos.precio, almacen.maquinas_registradoras.piso from
almacen.cajeros, almacen.venta, almacen.productos, almacen.maquinas_registradoras where almacen.venta.cajero = almacen.cajeros.cajero and
almacen.venta.producto = almacen.productos.producto and almacen.venta.maquina = almacen.maquinas_registradoras.maquina

/*Obtener las ventas totales realizadas en cada piso.*/

select almacen.maquinas_registradoras.piso, count(almacen.venta.maquina) as conteo from almacen.venta,
almacen.maquinas_registradoras where almacen.maquinas_registradoras.maquina = almacen.venta.maquina group by almacen.venta.maquina, 
almacen.maquinas_registradoras.piso 

/*Obtener el código y nombre de cada cajero junto con el importe total de sus ventas.*/

select almacen.cajeros.nomapels, almacen.venta.cajero, sum(almacen.productos.precio) as SumaTotal from almacen.cajeros, almacen.venta, almacen.productos where 
almacen.cajeros.cajero = almacen.venta.cajero and almacen.productos.producto = almacen.venta.producto group by almacen.cajeros.nomapels,
almacen.venta.cajero 

/*Obtener el código y nombre de aquellos cajeros que hayan realizado ventas en pisos cuyas ventas totales sean inferiores a los 5000 pesos.*/

select almacen.cajeros.nomapels, almacen.venta.cajero, sum(almacen.productos.precio) as SumaTotal from almacen.cajeros, almacen.venta, 
almacen.productos where almacen.cajeros.cajero = almacen.venta.cajero and almacen.productos.producto = almacen.venta.producto 
and almacen.productos.precio < cast(5000.00 as money) group by almacen.cajeros.nomapels,
almacen.venta.cajero 


