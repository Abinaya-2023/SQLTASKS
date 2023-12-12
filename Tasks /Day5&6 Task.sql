SELECT * FROM functions_sample.sales_data;

-- Question 1 Answer Query
-- Question 1 query without using rank()

SELECT
CustomerName
,ROUND(SUM(SalesAmount),2) AS total_sales
FROM
functions_sample.sales_data
GROUP BY 
CustomerName
ORDER BY 
total_sales DESC
LIMIT 5;

-- Question 1 query with rank()

WITH temp_sales AS(
SELECT 
CustomerName
,ROUND(SUM(SalesAmount),2) AS SalesAmount
FROM
functions_sample.sales_data
GROUP BY 
CustomerName)
SELECT *
,DENSE_RANK() OVER (ORDER BY SalesAmount DESC) AS rnk
FROM
temp_sales
LIMIT 5;

-- Question 2 Answer Query

WITH temp_sales2 AS(
SELECT 
CustomerName
,ROUND(SUM(SalesAmount),2) AS SalesAmount
FROM
functions_sample.sales_data
GROUP BY 
CustomerName)
SELECT *
,DENSE_RANK() OVER (ORDER BY SalesAmount ASC) AS rnk
FROM
temp_sales2
LIMIT 5;

-- Without rank()

SELECT
CustomerName
,ROUND(SUM(SalesAmount),2) AS total_sales
FROM
functions_sample.sales_data
GROUP BY 
CustomerName
ORDER BY 
total_sales 
LIMIT 5;


-- Question 3 Answer Query

SELECT 
ProductName,
COUNT(OrderQty) AS total_quantity_ordered
FROM
functions_sample.sales_data
GROUP BY 
ProductName
ORDER BY 
COUNT(OrderQty) DESC;

-- Question 4 Answer Query

WITH l_count AS(
SELECT 
ProductName,
COUNT(OrderQty) AS total_quantity_ordered
FROM
functions_sample.sales_data
GROUP BY
 ProductName
ORDER BY 
COUNT(OrderQty) DESC)
SELECT * FROM l_count
 WHERE
 total_quantity_ordered = (SELECT MIN(total_quantity_ordered) FROM l_count);

-- Question 5 Answer Query

SELECT
CustomerName
,COUNT(SalesOrderID) AS number_of_orders
FROM
functions_sample.sales_data
GROUP BY
CustomerName
ORDER BY
number_of_orders DESC;

-- Question 6 Answer Query

WITH o_count AS(
SELECT 
CustomerName,
COUNT(SalesOrderID) as Order_count
FROM 
functions_sample.sales_data
GROUP BY 
CustomerName
ORDER BY
Order_count DESC)
SELECT *,
DENSE_RANK() OVER (ORDER BY Order_count DESC) AS rnk
FROM
o_count
LIMIT 10; 

-- Question 7 Answer Query

SELECT 
CustomerName
,COUNT(SalesOrderID) AS order_count
FROM 
functions_sample.sales_data
GROUP BY 
CustomerName
HAVING
order_count < 50
ORDER BY
order_count;

-- Question 8 Answer Query


-- Without Sorting the SalesAmount in DESC 

SELECT
DATE_FORMAT(OrderDate, '%Y/%M') AS month_year
,ROUND(SUM(SalesAmount), 2) AS SalesAmount
FROM
functions_sample.sales_data
GROUP BY month_year;

-- After sorting the SalesAmount in DESC

SELECT
DATE_FORMAT(OrderDate, '%Y/%M') AS month_year
,ROUND(SUM(SalesAmount), 2) AS SalesAmount
FROM
functions_sample.sales_data
GROUP BY month_year
ORDER BY SalesAmount DESC;

-- Question 9 Answer Query

WITH m_sales AS(
SELECT
DATE_FORMAT(OrderDate, '%Y/%M') AS month_year
,ROUND(SUM(SalesAmount), 2) AS CurrentSalesAmount
FROM
functions_sample.sales_data
GROUP BY month_year),
monthly_sales AS(
SELECT *
, COALESCE(LAG(CurrentSalesAmount) OVER (ORDER BY month_year),NULL) AS PreviousMonthSales
FROM
m_sales)
SELECT *
, CASE
WHEN CurrentSalesAmount>PreviousMonthSales THEN 'Increase'
ELSE 'Decrease' 
END AS 
SaleStatus
FROM
monthly_sales;

-- Question 10 Answer Query

WITH CTE AS(
SELECT 
DISTINCT CategoryName
,ProductName
,UnitPrice
FROM
functions_sample.sales_data
),
product AS (
SELECT 
CategoryName,
ProductName,
ROW_NUMBER() OVER (PARTITION BY CategoryName ORDER BY UnitPrice DESC) as row_number_by_price 
FROM
CTE)
SELECT * 
FROM 
product
WHERE 
row_number_by_price = 1;








