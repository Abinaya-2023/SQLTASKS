
-- Case Study- SushiLand

SELECT * FROM sushiland.menu;

SELECT * FROM sushiland.members;

SELECT * FROM sushiland.sales;

-- Question 1 
-- What is the total amount spent by each customer at the restaurant?
-- Answer Query

SELECT 
members.Customer_Id, 
SUM(menu.price) as TotalAmount
FROM 
sushiland.members as members
INNER JOIN
sushiland.sales as sales
ON
members.Customer_Id= sales.Customer_Id
INNER JOIN 
sushiland.menu as menu
ON 
sales.Product_Id= menu.Product_ID
GROUP BY members.Customer_Id
ORDER BY 1;


-- Question 2
-- How many days each customer has visted the restaurant?
-- Answer Query

SELECT
Customer_Id,
COUNT(DISTINCT Order_Date) AS Number_of_days_visited
FROM
sushiland.sales
GROUP BY Customer_Id;


-- Question 3
-- What was the first item ordered by each customer from the menu?
-- Answer Query


SELECT 
sales.Customer_Id,
sales.Order_Date,
menu.Product_Name
FROM
sushiland.menu AS menu
INNER JOIN
sushiland.sales AS sales
ON sales.Product_Id= menu.Product_ID
WHERE sales.OrderID
IN
(SELECT 
MIN(sales.OrderId)
FROM sushiland.sales AS sales
GROUP BY 
sales.Customer_Id)
ORDER BY 1;

-- Question 4
-- What is the most purchased item on the menu and how many items it was purchased?
-- Answer Query

-- Total number of times each product is ordered

SELECT 
m.Product_Name,
COUNT(s.OrderId) AS number_of_orders
FROM
sushiland.sales AS s
INNER JOIN
sushiland.menu AS m
ON s.Product_Id= m.Product_ID
GROUP BY m.Product_ID;


-- Most ordered food by all customers

WITH more_counts AS(SELECT 
m.Product_Name,
COUNT(s.OrderId) AS number_of_orders
FROM
sushiland.sales AS s
INNER JOIN
sushiland.menu AS m
ON s.Product_Id= m.Product_ID
GROUP BY m.Product_ID)
SELECT * 
FROM
more_counts
WHERE
 number_of_orders=
(SELECT MAX(number_of_orders) FROM more_counts);


-- Question 5
-- Which is the most popular item for each customer?
-- Answer Query

WITH favo_food AS
(SELECT 
sales.Customer_Id,
menu.Product_Name,
COUNT(sales.Product_ID) AS Order_count,
DENSE_RANK() OVER (PARTITION BY sales.Customer_Id ORDER BY COUNT(sales.Product_ID) DESC) AS Rank_of_food
FROM
sushiland.sales AS sales
INNER JOIN
sushiland.menu AS menu
ON sales.Product_ID= menu.Product_ID
GROUP BY 
sales.Customer_Id, menu.Product_Name
ORDER BY 1)
SELECT 
Customer_Id,
Product_Name,
Order_count
FROM
favo_food
WHERE 
Rank_of_food=1;

-- Question 6
-- Which item was purchased first by the customer after they became a number?
-- Answer Query

WITH first_item AS
(SELECT 
c.Customer_Id,
c.Join_Date,
b.Order_Date,
a.Product_Name
FROM sushiland.menu as a
INNER JOIN
sushiland.sales as b
ON a.Product_ID = b.Product_Id
INNER JOIN
sushiland.members as c
ON b.Customer_Id= c.Customer_Id
WHERE b.Order_Date>=c.Join_Date)
, first_order AS
(SELECT
Customer_Id,
Join_Date,
MIN(Order_Date) AS Order_Date,
Product_Name,
ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY MIN(Order_Date) ASC) AS row_num
FROM
first_item
GROUP BY Customer_Id, Join_Date, Product_Name)
SELECT
Customer_Id,
Join_Date,
Order_Date,
Product_Name
FROM
first_order
WHERE row_num=1;

-- Question 7
-- Which item was purchased before the customer became a member?
-- Answer Query


SELECT 
c.Customer_Id,
c.Join_Date,
b.Order_Date,
a.Product_Name
FROM sushiland.menu as a
INNER JOIN
sushiland.sales as b
ON a.Product_ID = b.Product_Id
INNER JOIN
sushiland.members as c
ON b.Customer_Id= c.Customer_Id
WHERE b.Order_Date<c.Join_Date
ORDER BY b.Customer_Id;

-- Question 8
-- What is the total items and amount spent by each customer before they became a member?
-- Answer Query

WITH cte AS
(SELECT 
c.Customer_Id,
c.Join_Date,
b.Order_Date,
COUNT(a.Product_Id) AS Order_Count,
SUM(a.Price) AS Total_Amount
FROM sushiland.menu as a
INNER JOIN
sushiland.sales as b
ON a.Product_ID = b.Product_Id
INNER JOIN
sushiland.members as c
ON b.Customer_Id= c.Customer_Id
GROUP BY c.Customer_Id, c.Join_Date, b.Order_Date, a.Product_ID
ORDER BY b.Customer_Id)
SELECT 
Customer_Id,
SUM(Order_Count) AS Total_orders,
SUM(Total_Amount) AS Total_amount
FROM
cte
WHERE
Order_Date<Join_Date
GROUP BY 
Customer_Id
ORDER BY 1;

-- Bonus Question
-- (Re)create the table with customer id, order date, product name, product price, and Y/N on whether the customer was a member when placing the order. 
-- Answer Query

WITH temp AS
(SELECT 
mem.Customer_Id,
mem.Join_Date,
s.Order_Date,
m.Product_Name,
m.Price,
CASE
WHEN s.Order_Date>= mem.Join_Date THEN "Y"
ELSE "N"
END AS membership
FROM
sushiland.sales AS s
LEFT JOIN
sushiland.menu AS m
ON s.Product_Id= m.Product_ID
LEFT JOIN
sushiland.members AS mem
ON s.Customer_Id = mem.Customer_Id)
SELECT 
Customer_Id,
Order_Date,
Product_Name,
Price,
membership
FROM
temp
ORDER BY 1, 2;
