Market Basket Analysis using SQL
Overview
This project demonstrates a Market Basket Analysis (MBA) performed using SQL to identify frequently co-occurring products in retail transactions. The goal is to uncover hidden purchasing patterns that can inform strategic business decisions, such as product placement, cross-selling initiatives, and promotional campaigns.

Business Problem
A common challenge for retail businesses is understanding customer purchasing behavior beyond individual product sales. Knowing which products are bought together can unlock significant opportunities for revenue growth and improved customer experience. This project addresses the need to systematically identify these relationships from transactional data.

Project Objective
The primary objective of this analysis is to:

Identify association rules between products (e.g., "Customers who buy Product A also tend to buy Product B").

Calculate key metrics like Support and Confidence for these rules.

Translate these data-driven insights into actionable business recommendations for a retail store.

Key Concepts
Market Basket Analysis (MBA): A data mining technique used to discover relationships between items in large datasets. It identifies combinations of items that frequently occur together in transactions.

Support: Indicates how frequently an itemset appears in all transactions.

Support(X) = (Number of transactions containing X) / (Total number of transactions)

Confidence: Measures the likelihood that a customer will buy item Y given that they have already bought item X.

Confidence(X -> Y) = (Number of transactions containing X and Y) / (Number of transactions containing X)

Dataset
The analysis utilizes a simulated transactional dataset stored in a SQL table. The SalesTransactions table contains the following columns:

TransactionID (INT): Unique identifier for each customer transaction.

ProductID (INT): Unique identifier for each product.

ProductName (VARCHAR): The name of the product.

An example of the data structure and sample records are provided within the SQL script.

Tools Used
SQL Database: Any relational database management system (e.g., PostgreSQL, MySQL, SQL Server, SQLite) capable of running standard SQL queries.

SQL Client: For executing queries (e.g., DBeaver, SQL Developer, pgAdmin, or even a command-line client).

Methodology
The Market Basket Analysis was performed using a series of SQL queries:

Data Setup: Created the SalesTransactions table and populated it with sample data representing customer purchases.

Total Transaction Count: Calculated the total number of unique transactions to serve as a denominator for Support calculations.

Item Pair Identification: Used a self-join on the SalesTransactions table to identify all distinct pairs of products purchased within the same transaction. Filters were applied to exclude duplicate pairs (e.g., (A, B) and (B, A)) and ensure pairs involved different products.

Pair Support Calculation: Determined the Support for each identified item pair by counting transactions containing both items and dividing by the total number of transactions. A minimum support threshold was applied to focus on frequent patterns.

Confidence Calculation: For each significant rule (X -> Y), Confidence was calculated by dividing the number of transactions containing both X and Y by the number of transactions containing X. This step involved a Common Table Expression (CTE) to efficiently combine item pair counts with individual item counts.

Key Insights & Business Recommendations
The analysis revealed several strong association rules, providing actionable insights for the retail business. For instance, based on the sample data, some top rules include:

Rule: Shampoo -> Conditioner (Confidence: 1.00)

Insight: When a customer buys Shampoo, they invariably buy Conditioner.

Recommendation:

Product Placement: Always place Shampoo and Conditioner next to each other.

Bundling: Offer Shampoo and Conditioner as a bundled package at a slightly reduced price.

Inventory Management: Ensure both products are consistently in stock to avoid lost sales of either item.

Rule: Eggs -> Milk (Confidence: 1.00)

Insight: Every time a customer purchases Eggs, they also purchase Milk.

Recommendation:

Cross-Promotions: Implement "buy eggs, get a discount on milk" promotions.

Layout: Consider strategic placement to facilitate these co-purchases.

Rule: Milk -> Bread (Confidence: 0.67)

Insight: Customers buying Milk have a high likelihood (67%) of also buying Bread.

Recommendation:

Checkout Suggestions: Prompt cashiers or online systems to suggest Bread when Milk is scanned.

End-Cap Displays: Feature both items together in high-traffic areas.

These insights allow the business to:

Optimize Store Layout: Place highly associated items closer together.

Enhance Cross-Selling: Develop targeted recommendations and promotions.

Improve Inventory Management: Forecast demand for associated items more accurately.

Increase Sales & Customer Satisfaction: By making it easier for customers to find related products.

How to Run the Project
Clone the Repository:

git clone https://github.com/YourUsername/market-basket-analysis-sql.git
cd market-basket-analysis-sql

Set Up Database:

Connect to your preferred SQL database (e.g., PostgreSQL, MySQL).

Execute the create_and_insert_data.sql script (or copy the CREATE TABLE and INSERT statements from this README) to create the SalesTransactions table and populate it.

Run Analysis Queries:

Execute the analysis queries (e.g., for calculating total transactions, item pair support, and rule confidence) provided in market_basket_analysis_queries.sql (or directly from this README) in your SQL client.

Review Results: Examine the output of the queries, particularly the confidence scores, to identify strong association rules.

Future Enhancements
Lift Calculation: Implement calculation of the Lift metric, which provides a more robust measure of association by accounting for the popularity of the consequent.

Larger Datasets: Apply the analysis to a significantly larger, real-world transactional dataset to identify more complex patterns.

Visualization: Integrate with a data visualization tool (e.g., Tableau, Power BI) to create interactive dashboards of association rules.

More Complex Itemsets: Extend the analysis to find associations between itemsets of size 3 or more (requires more complex SQL or an external tool for large scale).

Feel free to explore the SQL queries and adapt them for your own datasets!
