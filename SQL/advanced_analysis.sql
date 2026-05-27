-- Cumulative sales
WITH monthly_sales AS (
    SELECT 
        strftime('%Y-%m', "Order Date") AS month,
        SUM(Sales) AS total_sales
    FROM veri_seti
    GROUP BY month
)
SELECT 
    month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY month) AS cumulative_sales
FROM monthly_sales;

-- Category ranking
WITH category_sales AS (
    SELECT 
        Category,
        SUM(Sales) AS total_sales
    FROM veri_seti
    GROUP BY Category
)
SELECT 
    Category,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM category_sales;

-- Profit margin
WITH profit_calc AS (
    SELECT 
        Category,
        SUM(Sales) AS total_sales,
        SUM(Profit) AS total_profit,
        SUM(Profit) * 1.0 / SUM(Sales) AS profit_margin
    FROM veri_seti
    GROUP BY Category
)
SELECT 
    Category,
    total_sales,
    total_profit,
    profit_margin
FROM profit_calc;

-- Discount impact
WITH discount_data AS (
    SELECT 
        Discount,
        AVG(Profit) AS avg_profit
    FROM veri_seti
    GROUP BY Discount
)
SELECT 
    Discount,
    avg_profit,
    LAG(avg_profit) OVER (ORDER BY Discount) AS previous_profit,
    avg_profit - LAG(avg_profit) OVER (ORDER BY Discount) AS profit_change
FROM discount_data;

-- Top state per region
WITH state_sales AS (
    SELECT 
        Region,
        State,
        SUM(Sales) AS total_sales
    FROM veri_seti
    GROUP BY Region, State
)
SELECT 
    Region,
    State,
    total_sales
FROM (
    SELECT 
        Region,
        State,
        total_sales,
        RANK() OVER (PARTITION BY Region ORDER BY total_sales DESC) AS rnk
    FROM state_sales
)
WHERE rnk = 1;