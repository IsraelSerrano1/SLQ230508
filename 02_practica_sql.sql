--distinct

-- Se quiere saber a qué paises se les vende usar la tabla de clientes
select distinct(country) from customers;
-- Se quiere saber a qué ciudades se les vende usar la tabla de clientes
select distinct(city) from customers;
-- Se quiere saber a qué ciudades se les ha enviado una orden
select distinct(ship_city) from orders;
--Se quiere saber a qué ciudades se les vende en el pais USA usar la tabla de clientes
select distinct(city) from customers where country = 'USA';


--Agrupacion

-- Se quiere saber a qué paises se les vende usar la tabla de clientes nota hacerla usando group by
select country from customers group by country;
--Cuantos clientes hay por pais
select country, count(customer_id) as customer_quantity from customers group by country;
--Cuantos clientes hay por ciudad en el pais USA
select city, count(customer_id) as customer_queantity from customers 
where country = 'USA' group by city;
--Cuantos productos hay por proveedor de la categoria 1
select supplier_id, count(product_id) as products_quantity from products 
where category_id = 1 group by supplier_id;

--Filtro con having

-- Cuales son los proveedores que nos surten más de 1 producto, 
-- mostrar el proveedor mostrar la cantidad de productos
select supplier_id, count(product_id) as products_quantity from products 
group by supplier_id having count(product_id)>1;
-- Cuales son los proveedores que nos surten más de 1 producto, 
-- mostrar el proveedor mostrar la cantidad de productos, pero únicamente de la categoria 1
select supplier_id, count(product_id) as products_quantity from products
where category_id = 1 group by supplier_id having count(product_id)>1; 
--CONTAR LAS ORDENES POR EMPLEADO DE LOS PAISES USA, CANADA, SPAIN (ShipCountry) 
--MOSTRAR UNICAMENTE LOS EMPLEADOS CUYO CONTADOR DE ORDENES SEA MAYOR A 20
select employee_id, count(order_id) as order_quantity from orders 
where ship_country in ('USA', 'Canada', 'Spain') group by employee_id having count(order_id) > 20;
--OBTENER EL PRECIO PROMEDIO DE LOS PRODUCTOS POR PROVEEDOR UNICAMENTE DE AQUELLOS 
--CUYO PROMEDIO SEA MAYOR A 20
select supplier_id, avg(unit_price) as price_average from products 
group by supplier_id having avg(unit_price) > 20;
--OBTENER LA SUMA DE LAS UNIDADES EN EXISTENCIA (UnitsInStock) POR CATEGORIA, 
--Y TOMANDO EN CUENTA UNICAMENTE LOS PRODUCTOS CUYO PROVEEDOR (SupplierID) 
--SEA IGUAL A 17, 19, 16 DICIONALMENTE CUYA SUMA POR CATEGORIA SEA MAYOR A 300--
select category_id, sum(units_in_stock) as stock from products 
where supplier_id in (17,19,16) group by category_id 
having sum(units_in_stock) > 300;
--CONTAR LAS ORDENES POR EMPLEADO DE LOS PAISES (ShipCountry) SA, CANADA, SPAIN cuYO CONTADOR SEA MAYOR A 25
select employee_id , count(order_id) as orders_quantity from orders 
where ship_country in ('USA', 'Canada', 'Spain') group by employee_id
having count(order_id) > 25;
--OBTENER LAS VENTAS (Quantity * UnitPrice) AGRUPADAS POR PRODUCTO (Orders details) 
--Y CUYA SUMA DE VENTAS SEA MAYOR A 50.000
select product_id, sum(quantity * unit_price) as sales from order_details 
group by product_id having sum(quantity * unit_price) > 50000;

--Mas de una tabla 

--OBTENER EL NUMERO DE ORDEN, EL ID EMPLEADO, NOMBRE Y APELLIDO DE LAS TABLAS DE ORDENES Y EMPLEADOS
select o.order_id, e.employee_id, e.first_name, e.last_name from orders o 
inner join employees e on o.employee_id = e.employee_id;
--OBTENER EL PRODUCTID, PRODUCTNAME, SUPPLIERID, COMPANYNAME DE LAS TABLAS DE PRODUCTOS Y PROVEEDORES (SUPPLIERS)
select p.product_id, p.product_name, S.supplier_id, S.company_name from products p 
inner join suppliers S on p.supplier_id = S.supplier_id;
--OBTENER LOS DATOS DEL DETALLE DE ORDENES CON EL NOMBRE DEL PRODUCTO DE 
--LAS TABLAS DE DETALLE DE ORDENES Y DE PRODUCTOS
select p.product_name, o.order_id, o.product_id, o.unit_price, o.quantity,o.discount from products p
inner join order_details o on p.product_id = o.product_id;
--OBTENER DE LAS ORDENES EL ID, SHIPPERID, NOMBRE DE LA COMPAÑÍA DE ENVIO (SHIPPERS)
select o.order_id, s.shipper_id, s.company_name from orders o 
inner join shippers s on o.ship_via = s.shipper_id;
--Obtener el número de orden, país de envío (shipCountry) y el nombre del empleado de la tabla ordenes y empleados Queremos que salga el Nombre y Apellido del Empleado en una sola columna.
select o.order_id, o.ship_country, concat(e.first_name,' ',e.last_name) as employee_name from orders o 
inner join employees e on o.employee_id = e.employee_id;


--Combinando la mayoría de conceptos

--CONTAR EL NUMERO DE ORDENES POR EMPLEADO OBTENIENDO EL ID EMPLEADO Y EL NOMBRE COMPLETO 
--DE LAS TABLAS DE ORDENES Y DE EMPLEADOS join y group by / columna calculada
select e.employee_id, concat(e.first_name, ' ', e.last_name)as employee_name, count(o.order_id) as orders 
from employees e inner join orders o on e.employee_id = o.employee_id 
group by e.employee_id, employee_name;
--OBTENER LA SUMA DE LA CANTIDAD VENDIDA Y EL PRECIO PROMEDIO POR NOMBRE DE PRODUCTO 
--DE LA TABLA DE ORDERS DETAILS Y PRODUCTS
select p.product_name, sum( o.quantity * o.unit_price) as sales, avg(o.unit_price) average_price 
from products p inner join order_details o on p.product_id = o.product_id 
group by p.product_name;
--OBTENER LAS VENTAS (UNITPRICE * QUANTITY) POR CLIENTE DE LAS TABLAS ORDER DETAILS, ORDERS
select o.customer_id, sum( d.unit_price * d.quantity ) as sales from orders o 
join order_details d on o.order_id = d.order_id group by o.customer_id;
--OBTENER LAS VENTAS (UNITPRICE * QUANTITY) POR EMPLEADO MOSTRANDO EL APELLIDO (LASTNAME)
--DE LAS TABLAS EMPLEADOS, ORDENES, DETALLE DE ORDENES
select e.last_name, sum(d.unit_price * d.quantity ) as sales from orders o
inner join employees e on o.employee_id = e.employee_id
inner join order_details d on o.order_id = d.order_id group by e.last_name;