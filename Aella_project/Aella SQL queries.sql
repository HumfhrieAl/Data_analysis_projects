CREATE VIEW sales_trend AS (
--Getting the sales trend of all time
SELECT
	p.productName,
	p.categoryname,
	sh.orderdate,
	ROUND(so.unitprice * so.lineTotal) AS sales
FROM product AS p
JOIN salesorderdetail AS so ON p.productid = so.productid
JOIN salesorderheader AS sh ON sh.salesorderid = so.salesorderid
GROUP BY 1,2,3,4
ORDER BY 4 DESC
);