--Total Sales & Profit by Region--
SELECT Region, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_profit
FROM `utopian-pact-418210.Super_store.Orders`
GROUP BY Region
ORDER BY Total_profit ASC;


--Identify Loss-Making Categories--
SELECT Category, Status
FROM `utopian-pact-418210.Super_store.Orders`
WHERE Status = "Loss";


--OR__


SELECT Category, SUM(Profit) AS Total_Profit
FROM `utopian-pact-418210.Super_store.Orders`
GROUP BY Category
HAVING Total_Profit < 0;


--Check Discount Impact--


SELECT Discount, SUM(Profit) AS Total_profit
FROM `utopian-pact-418210.Super_store.Orders`
GROUP BY Discount
ORDER BY Discount;


--Monthly Trend Analysis--


SELECT FORMAT_DATE('%Y-%m',Order_Date) AS Month, SUM(Sales) AS Total_sales, SUM(Profit) AS Total_profit
FROM `utopian-pact-418210.Super_store.Orders`
GROUP BY Month
ORDER BY Month ASC;

--Customer Lifetime Value (CLV)--

SELECT 
  Customer_Name,
  COUNT(DISTINCT Order_ID) AS total_orders,
  SUM(Sales) AS lifetime_sales,
  SUM(Profit) AS lifetime_profit,
  ROUND(SUM(Profit)/SUM(Sales),3) AS profit_margin
FROM `utopian-pact-418210.Super_store.Orders`
GROUP BY Customer_Name
ORDER BY lifetime_sales DESC
LIMIT 15;

--Repeat vs One-Time Customers--

WITH customer_orders AS (
  SELECT 
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS order_count
  FROM `utopian-pact-418210.Super_store.Orders`
  GROUP BY Customer_Name
)

SELECT 
  CASE 
    WHEN order_count = 1 THEN 'One-Time'
    ELSE 'Repeat'
  END AS customer_type,
  COUNT(*) AS total_customers
FROM customer_orders
GROUP BY customer_type;

--Average Discount by Category--

SELECT 
  Category,
  ROUND(AVG(Discount),2) AS avg_discount,
  SUM(Profit) AS total_profit
FROM `utopian-pact-418210.Super_store.Orders`
GROUP BY Category
ORDER BY avg_discount DESC;

--States That Generate High Sales but Low Margin--

SELECT 
  State,
  SUM(Sales) AS total_sales,
  SUM(Profit) AS total_profit,
  ROUND(SUM(Profit)/SUM(Sales),3) AS profit_margin
FROM `utopian-pact-418210.Super_store.Orders`
GROUP BY State
HAVING SUM(Sales) > 100000
ORDER BY profit_margin ASC;

--Orders with Extreme Discounts Causing Heavy Loss--

SELECT 
  Order_ID,
  Product_Name,
  Discount,
  Sales,
  Profit
FROM `utopian-pact-418210.Super_store.Orders`
WHERE Discount > 0.5
AND Profit < 0
ORDER BY Discount DESC;

--Identify Seasonal Peak Category--

SELECT 
  FORMAT_DATE('%Y-%m', Order_Date) AS month,
  Category,
  SUM(Sales) AS total_sales
FROM `utopian-pact-418210.Super_store.Orders`
GROUP BY month, Category
ORDER BY month, total_sales DESC;



