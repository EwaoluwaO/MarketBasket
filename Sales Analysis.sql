 --Overall Sales Performance (Total Revenue, Total Orders, AOV)
SELECT
    COUNT(DISTINCT oi.order_id) AS TotalCompletedOrders,
    SUM(oi.sale_price) AS TotalRevenue,
    SUM(oi.sale_price) / COUNT(DISTINCT oi.order_id) AS AverageOrderValue
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
WHERE
    oi.status = 'Complete'; -- Only consider completed sales

--Monthly Sales Trends
SELECT
    FORMAT_DATE('%Y-%m', o.created_at) AS SaleMonth,
    COUNT(DISTINCT oi.order_id) AS MonthlyOrders,
    SUM(oi.sale_price) AS MonthlyRevenue,
    SUM(oi.sale_price) / COUNT(DISTINCT oi.order_id) AS MonthlyAverageOrderValue
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN
    `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON oi.order_id = o.order_id
WHERE
    oi.status = 'Complete' -- Only completed items
GROUP BY
    SaleMonth
ORDER BY
    SaleMonth;

--Top 10 Selling Products by Revenue
SELECT
    p.name AS ProductName,
    SUM(oi.sale_price) AS TotalRevenue,
    COUNT(oi.product_id) AS UnitsSold
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN
    `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
WHERE
    oi.status = 'Complete'
GROUP BY
    ProductName
ORDER BY
    TotalRevenue DESC
LIMIT 10;

--Top 10 Selling Product Categories by Revenue
SELECT
    p.category AS ProductCategory,
    SUM(oi.sale_price) AS TotalRevenue,
    COUNT(oi.product_id) AS UnitsSold
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN
    `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
WHERE
    oi.status = 'Complete'
GROUP BY
    ProductCategory
ORDER BY
    TotalRevenue DESC
LIMIT 10;

--: Sales by Customer Gender
SELECT
    u.gender,
    COUNT(DISTINCT oi.order_id) AS TotalOrders,
    SUM(oi.sale_price) AS TotalRevenue,
    SUM(oi.sale_price) / COUNT(DISTINCT oi.order_id) AS AverageOrderValue
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN
    `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON oi.order_id = o.order_id
JOIN
    `bigquery-public-data.thelook_ecommerce.users` AS u
    ON o.user_id = u.id
WHERE
    oi.status = 'Complete'
    AND u.gender IS NOT NULL -- Exclude rows where gender is not recorded
GROUP BY
    u.gender
ORDER BY
    TotalRevenue DESC;
-- Sales by Customer Age Group
SELECT
    CASE
        WHEN u.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN u.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN u.age BETWEEN 45 AND 54 THEN '45-54'
        WHEN u.age >= 55 THEN '55+'
        ELSE 'Unknown'
    END AS AgeGroup,
    COUNT(DISTINCT oi.order_id) AS TotalOrders,
    SUM(oi.sale_price) AS TotalRevenue,
    SUM(oi.sale_price) / COUNT(DISTINCT oi.order_id) AS AverageOrderValue
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN
    `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON oi.order_id = o.order_id
JOIN
    `bigquery-public-data.thelook_ecommerce.users` AS u
    ON o.user_id = u.id
WHERE
    oi.status = 'Complete'
    AND u.age IS NOT NULL -- Exclude rows where age is not recorded
GROUP BY
    AgeGroup
ORDER BY
    TotalRevenue DESC;
