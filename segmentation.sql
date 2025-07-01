-- (Include all previous CTEs: SnapshotDate, RFM_Values, RFM_Scores)
WITH SnapshotDate AS (
    SELECT MAX(created_at) AS latest_order_date
    FROM `bigquery-public-data.thelook_ecommerce.orders`
),
RFM_Values AS (
    SELECT
        o.user_id,
        DATE_DIFF(CAST(sd.latest_order_date AS DATE), CAST(MAX(o.created_at) AS DATE), DAY) AS Recency,
        COUNT(DISTINCT o.order_id) AS Frequency,
        SUM(oi.sale_price) AS Monetary
    FROM
        `bigquery-public-data.thelook_ecommerce.orders` AS o
    JOIN
        `bigquery-public-data.thelook_ecommerce.order_items` AS oi
        ON o.order_id = oi.order_id
    CROSS JOIN
        SnapshotDate AS sd
    GROUP BY
        o.user_id
),
RFM_Scores AS (
    SELECT
        user_id,
        Recency,
        Frequency,
        Monetary,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM
        RFM_Values
),
CustomerSegments AS (
    SELECT
        user_id,
        Recency,
        Frequency,
        Monetary,
        R_Score,
        F_Score,
        M_Score,
        CASE
            WHEN R_Score = 5 AND F_Score = 5 AND M_Score = 5 THEN 'Champions'
            WHEN R_Score = 5 AND F_Score BETWEEN 4 AND 5 THEN 'Loyal Customers' -- General high R, F
            WHEN R_Score = 4 AND F_Score = 5 AND M_Score = 5 THEN 'Loyal Customers'
            WHEN R_Score BETWEEN 4 AND 5 AND F_Score BETWEEN 1 AND 2 THEN 'New Customers' -- High R, low F/M
            WHEN R_Score BETWEEN 3 AND 4 AND F_Score BETWEEN 3 AND 4 AND M_Score BETWEEN 3 AND 4 THEN 'Promising'
            WHEN R_Score BETWEEN 1 AND 2 AND F_Score BETWEEN 4 AND 5 THEN 'At Risk' -- Low R, high F/M
            WHEN R_Score BETWEEN 1 AND 2 AND F_Score BETWEEN 1 AND 2 THEN 'Lost Customers' -- Low R, F, M
            ELSE 'Other'
        END AS CustomerSegment
    FROM
        RFM_Scores
)
SELECT
    CustomerSegment,
    COUNT(user_id) AS NumberOfCustomers,
    AVG(Recency) AS AvgRecency,
    AVG(Frequency) AS AvgFrequency,
    AVG(Monetary) AS AvgMonetary,
    -- Calculate percentage of total customers in each segment
    COUNT(user_id) * 100.0 / (SELECT COUNT(DISTINCT user_id) FROM `bigquery-public-data.thelook_ecommerce.orders`) AS PercentageOfCustomers
FROM
    CustomerSegments
GROUP BY
    CustomerSegment
ORDER BY
    NumberOfCustomers DESC;
