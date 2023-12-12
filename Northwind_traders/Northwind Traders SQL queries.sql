CREATE VIEW sales_trends AS(
--Getting the sales trends of all time
SELECT
	p."productName",
	o."orderDate",
	c."categoryName",
	(od.quantity*od.unitprice) AS sales_trend
FROM products AS p
JOIN order_details AS od ON od."productID" = p."productID"
JOIN orders AS o ON o."orderID" = od."orderID"
JOIN category AS c ON c."categoryID"::int = p."categoryID"
GROUP BY 1,2,3,4
ORDER BY 4 DESC 
);


CREATE VIEW product_performance AS(
--Getting the product performance of each product from the total sales
WITH CTE AS(
SELECT 
	p."productName",
	st.sales_trend,
	SUM(od.quantity*od.unitprice) AS Total_sales
FROM products AS p
JOIN order_details AS od ON od."productID" = p."productID"
JOIN sales_trends AS st ON st."productName" = p."productName"
GROUP BY 1, 2
)
SELECT 
	"productName",
	sales_trend,
	Total_sales
FROM CTE
	GROUP BY 1,2,3
ORDER BY 3 DESC
);


CREATE VIEW key_customers AS(
--Getting the Key customers of the company
SELECT 
	o."customerID",
	COUNT(o."orderID"),
	c."companyName",
	SUM(st.sales_trend) AS Key_customers,
	c.country,
	c.city
FROM customers AS c
JOIN orders AS o ON o."customerID" = c."customerID"
JOIN order_details AS od ON od."orderID" = o."orderID"
JOIN sales_trends AS st ON st."orderDate" = o."orderDate"
GROUP BY 1,3,5,6
ORDER BY 4 DESC
);

CREATE VIEW shipping_costs AS(
--Getting the shipping cost
SELECT
	o."customerID",
	o."shipperID",
	--COUNT(DISTINCT o."orderID") AS order_volume,
	SUM(o.freight) AS shipping_cost
FROM orders AS o
JOIN shippers AS sh ON  sh."shipperID" = o."shipperID"
GROUP BY 1,2
ORDER BY 3 DESC
);


CREATE VIEW shipment AS(
--shipping analysis
SELECT
	sh."shipperID",
	sh."companyName",
	o."orderID",
	o."customerID",
	sc.shipping_cost,
	(AVG(DATE_PART('DAY', o."requiredDate"::DATE) - DATE_PART('DAY', o."shippedDate"::DATE))) AS AVG_deliv_diff,
	ROUND(SUM(o.freight)/COUNT(DISTINCT o."orderID"),3) AS shipping_cost_per_order
FROM shippers sh
JOIN orders o ON o."shipperID" = sh."shipperID"
JOIN order_details od ON od."orderID" = o."orderID"
JOIN shipping_costs AS sc ON sc."shipperID" = o."shipperID"
GROUP BY 1,2,3,4,5
ORDER BY 6 DESC
);
	
/*
select * from orders
join order_details on order_details."orderID" = orders."orderID"
join customers c on c."customerID" = orders."customerID"
	
	
select * from shippers