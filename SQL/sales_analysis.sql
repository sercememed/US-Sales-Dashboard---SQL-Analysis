-- Category sales
SELECT 
    Category,
    SUM(Sales) AS total_sales
FROM veri_seti
GROUP BY Category
ORDER BY total_sales DESC;

-- Region sales
SELECT 
    Region,
    SUM(Sales) AS total_sales
FROM veri_seti
GROUP BY Region
ORDER BY total_sales DESC;

-- Monthly trend
SELECT 
    strftime('%Y-%m', "Order Date") AS month,
    SUM(Sales) AS total_sales
FROM veri_seti
GROUP BY month
ORDER BY month;

-- Subcategory performance
SELECT 
    Category,
    Subcategory,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM veri_seti
GROUP BY Category, Subcategory
ORDER BY total_sales DESC;

-- Loss-making products
SELECT 
    Subcategory,
    SUM(Profit) AS total_profit
FROM veri_seti
GROUP BY Subcategory
HAVING total_profit < 0
ORDER BY total_profit;