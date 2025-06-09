# Market Basket Analysis on BigQuery: TheLook eCommerce Dataset

---

## Overview

This project showcases a **Market Basket Analysis (MBA)** leveraging Google BigQuery and the public `thelook_ecommerce` dataset. The goal is to identify frequently co-purchased products within real-world e-commerce transactions, uncovering valuable purchasing patterns that can drive strategic business decisions for online retailers.

---

## Business Problem

For e-commerce businesses, understanding how products relate to each other in customer purchases is critical. By identifying which products are often bought together, businesses can optimize their online store layout, personalize product recommendations, create effective bundles, and improve marketing strategies, ultimately enhancing customer experience and boosting revenue.

---

## Project Objective

The primary objectives of this analysis are to:

* Utilize a large-scale, real-world e-commerce dataset (`thelook_ecommerce`) on BigQuery to perform an MBA.
* Identify **association rules** between products (e.g., "Customers who buy Product A also tend to buy Product B").
* Calculate key association rule metrics: **Support** and **Confidence**.
* Derive actionable **business recommendations** based on the discovered purchasing patterns.

---

## Key Concepts

* **Market Basket Analysis (MBA):** A data mining technique used to uncover relationships between items that are frequently purchased together in transactions.
* **Support:** Indicates how frequently an itemset (a combination of products) appears across all transactions.
    * `Support(X) = (Number of transactions containing X) / (Total number of transactions)`
* **Confidence:** Measures the likelihood that a customer will buy item Y given that they have already bought item X.
    * `Confidence(X -> Y) = (Number of transactions containing X and Y) / (Number of transactions containing X)`

---

## Dataset

This analysis uses the **`thelook_ecommerce` public dataset** available in Google BigQuery. This dataset simulates transactional data from an e-commerce platform.

The primary table used is `bigquery-public-data.thelook_ecommerce.order_items`, which contains individual product entries for each order. Key columns utilized include:

* `order_id`: Serves as the unique transaction identifier.
* `product_id`: Unique identifier for each product.
* `product_name`: The descriptive name of the product.

---

## Tools Used

* **Google BigQuery:** Google's fully managed, serverless data warehouse, used for storing and querying the large-scale `thelook_ecommerce` dataset.
* **Standard SQL:** For writing and executing the analytical queries.
* **Google Cloud Console / BigQuery UI:** For interacting with BigQuery and running queries.

---

## Methodology

The Market Basket Analysis was performed using a series of SQL queries executed directly within Google BigQuery:

1.  **Total Order Count:** Determined the total number of unique orders in the dataset to serve as the denominator for Support calculations.
2.  **Item Pair Identification:** A self-join on the `order_items` table was performed to identify all distinct pairs of products purchased within the same order. This step ensures that each pair (A, B) is counted only once, and that `product_id` is used to prevent self-pairing.
3.  **Pair Support Calculation:** The `Support` for each identified item pair was calculated by counting the number of orders containing both items and dividing by the total number of orders. A practical minimum support threshold was applied (`HAVING COUNT(DISTINCT order_id) >= [threshold]`) to focus on statistically significant and frequent patterns, given the large dataset size.
4.  **Confidence Calculation:** For each significant rule (X -> Y), `Confidence` was calculated by dividing the number of orders containing both X and Y by the number of orders containing only X. This involved using Common Table Expressions (CTEs) to efficiently manage intermediate results for pair counts and individual item counts. Filtering was applied to focus on rules exceeding specific support thresholds for both the pair and the antecedent.

---

## Key Insights & Business Recommendations

By analyzing product co-occurrence patterns from the `thelook_ecommerce` dataset, the business can gain valuable insights. While specific outcomes depend on the exact BigQuery query results and chosen thresholds, typical actionable recommendations might include:

* **Optimized Product Placement:** Strategically placing highly associated items closer together on e-commerce pages (e.g., "Customers who bought X also bought Y" sections).
* **Enhanced Cross-Selling:** Developing targeted product recommendations and personalized prompts based on items already in a customer's cart or purchase history.
* **Effective Bundling Strategies:** Creating attractive product bundles (e.g., "Buy X and get Y for a discount") for items with high confidence scores.
* **Improved Inventory Management:** More accurately forecasting demand for complementary products, ensuring both are in stock.
* **Targeted Marketing Campaigns:** Designing promotions and advertisements that feature groups of commonly purchased products.

These insights directly contribute to increasing average order value, improving customer satisfaction, and optimizing overall e-commerce operations.

---

## How to Run the Project

1.  **Access BigQuery:**
    * Navigate to the Google Cloud Console and open the BigQuery UI.
    * Ensure you have a Google Cloud project with billing enabled (though querying public datasets usually incurs minimal to no cost).
2.  **Run Analysis Queries:**
    * In the BigQuery query editor, paste and execute the SQL queries provided (similar to the ones discussed in the previous conversation) to perform the Market Basket Analysis on the `bigquery-public-data.thelook_ecommerce.order_items` table.
    * Remember to adjust the `HAVING` clause thresholds in the queries based on the scale of the dataset to get relevant results.
3.  **Review Results:** Examine the output of the confidence query to identify strong association rules and derive business insights.

---

## Future Enhancements

* **Lift Metric:** Implement the calculation of the `Lift` metric in SQL, which provides a more nuanced understanding of an association rule's strength by controlling for the individual popularity of items.
* **Visualizations:** Connect BigQuery to a business intelligence tool (e.g., Looker Studio, Tableau, Power BI) to create interactive dashboards visualizing the top association rules.
* **Temporal Analysis:** Incorporate time-based analysis to understand how purchasing patterns change seasonally or over time.
* **Itemsets of Size 3+:** Extend the SQL queries to identify and analyze associations involving three or more products for deeper insights (this can become computationally intensive for very large datasets and may benefit from specialized libraries in Python if SQL performance becomes a bottleneck).

---

This project demonstrates strong SQL skills, experience with large-scale data platforms like BigQuery, and the ability to translate data insights into practical business strategies.
