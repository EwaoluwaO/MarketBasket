# E-commerce Business Analytics Portfolio Project: Deep Dive into TheLook eCommerce Data

---

## Overview

This comprehensive portfolio project demonstrates a multifaceted business analysis of the `thelook_ecommerce` public dataset hosted on Google BigQuery. It builds upon a foundational understanding of analytical techniques first explored with a simulated dataset. Through three distinct analytical approaches – **Sales Performance Analysis**, **RFM Customer Segmentation**, and **Market Basket Analysis** – this project aims to extract actionable insights from real-world e-commerce transactional data. The goal is to empower businesses with data-driven strategies to optimize sales, enhance customer engagement, and improve overall operational efficiency.

---

## Business Problem

E-commerce businesses operate in a highly competitive and dynamic environment. To thrive, they need a deep understanding of their sales performance, customer behavior, and product relationships. This project addresses critical business questions such as:
* What are our key sales trends and performance indicators?
* Who are our most valuable customers, and how can we tailor our engagement with different customer groups?
* Which products are frequently purchased together, and how can we leverage this for better merchandising and cross-selling?

---

## Foundational Analysis: Simulated Data Exploration

Before tackling the large-scale BigQuery dataset, an initial Market Basket Analysis was conducted using a smaller, simulated transactional dataset. This foundational step was crucial for:
* Solidifying the understanding of core Market Basket Analysis concepts (Support, Confidence).
* Developing and testing the SQL query logic in a controlled environment.
* Proving the methodology's effectiveness before scaling to a real-world dataset.

This initial analysis involved creating a simple `SalesTransactions` table with `TransactionID`, `ProductID`, and `ProductName`, and then applying SQL self-joins and aggregations to identify product pairs and calculate their support and confidence. The insights gained from this exercise directly informed the approach taken for the more complex `thelook_ecommerce` dataset.

---

## Dataset & Tools

All primary analyses in this project leverage the **`bigquery-public-data.thelook_ecommerce`** public dataset, a rich simulated e-commerce dataset available on Google BigQuery.

* **Google BigQuery:** Google's fully managed, serverless data warehouse, ideal for querying large-scale datasets efficiently.
* **Standard SQL:** The primary language used for all data extraction, transformation, and analysis.
* **Google Cloud Console / BigQuery UI:** The interface used for executing SQL queries and reviewing results.

---

## Project Analyses & Insights

This project is structured around three core analytical components:

### 1. Sales Performance Analysis

#### Objective
To understand the overall health and trends of the e-commerce business by analyzing key sales metrics over time and across different dimensions.

#### Key Metrics & Concepts
* **Total Revenue:** Sum of all completed sales.
* **Total Orders:** Count of unique, completed transactions.
* **Average Order Value (AOV):** Revenue per order, indicating average customer spend.
* **Sales Trends:** Performance changes over periods (e.g., monthly, quarterly).
* **Top Products/Categories:** Identifying best-selling items and product groups.
* **Sales by Demographics:** Analyzing revenue and orders across customer gender and age groups.

#### Methodology
* Utilized `bigquery-public-data.thelook_ecommerce.orders`, `order_items`, `products`, and `users` tables.
* Joined tables to link order, item, product, and user data.
* Aggregated data using `SUM()` and `COUNT(DISTINCT)` to calculate KPIs.
* Applied `FORMAT_DATE()` for time-series analysis and `CASE` statements for age group segmentation.
* Filtered all sales to only include `status = 'Complete'` for accurate reporting.

#### Key Insights & Business Recommendations
* **Performance Overview:** Provides a snapshot of total sales, order volume, and average transaction size, crucial for high-level business reporting.
* **Trend Identification:** Reveals growth, decline, or seasonality in sales, enabling proactive planning for marketing campaigns, inventory management, and resource allocation.
* **Product/Category Focus:** Pinpoints high-performing products and categories, guiding merchandising decisions, promotional strategies, and future product development.
* **Demographic Targeting:** Uncovers which customer segments (by gender, age) contribute most to sales, allowing for tailored marketing messages and personalized product recommendations to maximize ROI.

---

### 2. RFM Customer Segmentation

#### Objective
To segment the customer base into distinct groups based on their purchasing behavior (Recency, Frequency, Monetary value) to enable highly targeted marketing and customer retention strategies.

#### Key Concepts
* **Recency (R):** How recently a customer made a purchase (e.g., days since last order).
* **Frequency (F):** How often a customer makes purchases (e.g., number of unique orders).
* **Monetary (M):** How much money a customer has spent (e.g., total revenue generated).
* **RFM Scores:** Customers are ranked and assigned scores (e.g., 1-5) for each RFM component using `NTILE()`.
* **Customer Segments:** Defined groups (e.g., Champions, Loyal Customers, At-Risk) based on combinations of RFM scores.

#### Methodology
* Used `bigquery-public-data.thelook_ecommerce.orders` and `order_items` tables.
* Calculated Recency (using `DATE_DIFF` from a snapshot date), Frequency (`COUNT(DISTINCT order_id)`), and Monetary value (`SUM(sale_price)`) for each unique user.
* Applied `NTILE(5)` window functions to assign R, F, and M scores (1-5) to each customer.
* Used `CASE` statements to define various customer segments based on their combined RFM scores.

#### Key Insights & Business Recommendations
* **Customer Value Identification:** Clearly identifies high-value customers (Champions, Loyal) who deserve special attention and loyalty programs.
* **Targeted Marketing:** Enables the creation of personalized campaigns for each segment (e.g., win-back offers for "At-Risk" customers, welcome series for "New Customers").
* **Resource Allocation:** Helps prioritize marketing spend and customer service efforts towards segments with the highest potential for retention or growth.
* **Customer Lifecycle Management:** Provides a framework to understand where customers are in their journey and how to move them to higher-value segments.

---

### 3. Market Basket Analysis (MBA)

#### Objective
To discover which products are frequently purchased together within the same transactions, providing insights for optimized product placement, cross-selling, and bundling strategies.

#### Key Concepts
* **Association Rules:** "If X is bought, then Y is likely bought too."
* **Support:** The proportion of transactions that contain a specific itemset (combination of products).
* **Confidence:** The likelihood that item Y is purchased when item X has already been purchased.

#### Methodology
* Utilized the `bigquery-public-data.thelook_ecommerce.order_items` table.
* Performed a self-join on `order_items` to identify all distinct pairs of products within the same `order_id`.
* Calculated the `Support` for each item pair by counting co-occurrences and dividing by the total number of orders. A minimum support threshold was applied to focus on frequent patterns.
* Calculated the `Confidence` for each directional rule (X -> Y) by dividing the count of (X and Y) by the count of (X).
* Filtered results to display only rules meeting predefined minimum support and confidence thresholds.

#### Key Insights & Business Recommendations
* **Optimized Product Placement:** Guides the strategic arrangement of products on e-commerce pages and in recommendation engines (e.g., "Customers who bought this also bought...").
* **Enhanced Cross-Selling:** Informs personalized product suggestions during browsing or at checkout, increasing average order value.
* **Effective Bundling:** Identifies strong product associations perfect for creating attractive bundled offers that encourage larger purchases.
* **Promotional Strategies:** Helps design targeted promotions and advertisements featuring complementary products.

---

## Future Enhancements

* **Data Visualization:** Integrate the BigQuery results with a business intelligence tool (e.g., Looker Studio, Tableau, Power BI) to create interactive dashboards for each analysis, making insights more accessible and impactful.
* **Advanced RFM:** Explore more sophisticated RFM scoring methods or integrate with clustering algorithms (e.g., K-Means in Python) for more dynamic segmentation.
* **Lift Metric:** Add the calculation of the `Lift` metric to the Market Basket Analysis for a more robust measure of association rule strength.
* **Predictive Modeling:** Use the segmented customer data to build predictive models for churn, future spending, or product recommendations.
* **A/B Testing Integration:** Design hypothetical A/B tests based on the recommendations to validate their impact on real business metrics.

---

This project showcases strong proficiency in SQL, experience with large-scale cloud data platforms, and the critical ability to transform raw data into strategic business intelligence.
