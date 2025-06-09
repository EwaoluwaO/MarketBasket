WITH order_itemsfull AS (
  select *
  from bigquery-public-data.thelook_ecommerce.order_items oi
  left join bigquery-public-data.thelook_ecommerce.products p on p.id=oi.id

),
 ItemPairs AS (
    -- Step 1: Find all unique pairs of items within the same order (direction matters for confidence)
    SELECT
        t1.name AS Item1,
        t2.name AS Item2,
        t1.order_id
    FROM
        order_itemsfull AS t1
    JOIN
        order_itemsfull AS t2
    ON
        t1.order_id = t2.order_id
        AND t1.product_id != t2.product_id -- We need all distinct ordered pairs for confidence calculation
),
PairCounts AS (
    -- Step 2: Count orders for each ordered pair (e.g., A->B is different from B->A for confidence)
    SELECT
        Item1,
        Item2,
        COUNT(DISTINCT order_id) AS OrdersWithBothXY
    FROM
        ItemPairs
    GROUP BY
        Item1,
        Item2
),
ItemCounts AS (
    -- Step 3: Count orders for each individual item (for the 'antecedent' X)
    SELECT
        name AS Item,
        COUNT(DISTINCT order_id) AS OrdersWithX
    FROM
        order_itemsfull
    GROUP BY
        name
)
-- Step 4: Calculate Confidence (OrdersWithBothXY / OrdersWithX)
SELECT
    pc.Item1 AS Antecedent_X,
    pc.Item2 AS Consequent_Y,
    pc.OrdersWithBothXY,
    ic.OrdersWithX,
    CAST(pc.OrdersWithBothXY AS BIGNUMERIC) / ic.OrdersWithX AS Confidence
FROM
    PairCounts AS pc
JOIN
    ItemCounts AS ic
ON
    pc.Item1 = ic.Item -- Join on the antecedent (Item1)

ORDER BY
    Confidence DESC, OrdersWithBothXY DESC;
