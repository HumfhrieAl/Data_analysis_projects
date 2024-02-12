--Getting sales trend
CREATE VIEW sales_trend AS(
            SELECT
            p.productName,
            p.categoryname,
            sh.orderdate,
            SUM(lineTotal) AS totalsales
FROM product AS p
JOIN salesorderdetail AS so ON p.productid = so.productid
JOIN salesorderheader AS sh ON sh.salesorderid = so.salesorderid
GROUP BY 1,2,3
ORDER BY 4 DESC
);

--Getting the top performing product
SELECT
   p.productname,
   p.categoryname,
   SUM(sd.linetotal) AS topproducts
FROM product AS p
JOIN salesorderdetail sd ON sd.productid = p.productid
JOIN salesorderheader sh ON sh.salesorderid = sd.salesorderid
GROUP BY 1,2
ORDER BY 3 DESC;

--Getting the key customers
SELECT
    DISTINCT (sh.customerid),
    sd.orderqty,
    count(sh.salesorderid),
    SUM(st.totalsales) AS Top_customer
FROM salesorderheader AS sh
INNER JOIN public.salesorderdetail sd on sd.salesorderid = sh.salesorderid
INNER JOIN sales_trend AS st ON st.orderdate = sh.orderdate
GROUP BY 1,2
ORDER BY 4 DESC;

--Getting Analysis on Customer Retention
SELECT
    sh.customerid,
    COUNT(DISTINCT sh.salesorderid) AS totalorders,
    MIN(sh.orderdate) AS firstorderdate,
    MAX(sh.orderdate) AS lastorderdate,
    SUM(sd.linetotal) AS totalspent
FROM salesorderheader sh
JOIN salesorderdetail AS sd ON sd.salesorderid = sh.salesorderid
GROUP BY 1
HAVING COUNT(DISTINCT sh.salesorderid)>1;

--Getting customer repeat count
SELECT
    sh.customerid,
    COUNT(DISTINCT sh.salesorderid) AS Repeatcount,
    sh.orderdate
FROM salesorderheader sh
JOIN salesorderdetail sd ON sd.salesorderid = sh.salesorderid
GROUP BY 1,3
--HAVING COUNT(DISTINCT sh.salesorderid) > 1
ORDER BY 2 DESC ;

--Getting the salesperson performance
SELECT
    salespersonid,
    st.totalsales
FROM salespersons sp
JOIN salesorderheader sh ON sh.territoryid = sp.territoryid
JOIN sales_trend st on sh.orderdate = st.orderdate
GROUP BY 1,2
ORDER BY 2 DESC;

--for revenue
select
    salesorderid,
    sum(orderqty * unitprice) as revenue
from salesorderdetail
group by 1;

--for total sales
select
    sum(linetotal) As total_sales
from salesorderdetail;

--getting Average  order value
create view Revenue_totalorders as(
select
    sum(orderqty * unitprice)  as revenue,
    sum(distinct salesorderid) as totalorders
from salesorderdetail
    );
select
    (revenue/totalorders) as averagetotalorders
from Revenue_totalorders;