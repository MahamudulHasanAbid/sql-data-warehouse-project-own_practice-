/* =================================================
When a column/data is number and perform aggregate function that is "Measure"
Measure Exploration also an important part of EDA(Exploratory Data Analysis) 
We can say Measure Exploration = Big numbers
>> Σ[Measure] -> Using aggregation
================================================== */

-- Find total sales
Select 'Total Sales' as measure_name, sum(sales_amount) as measure_value 
from [gold.fact_sales];
-- Find how many Items are sold
Select  'Total Items' as measure_name, Count(quantity) as measure_value
from [gold.fact_sales];
-- Find average selling price
Select 'Average Selling price' as measure_name, Avg(price) as measure_value
from [gold.fact_sales];
-- Find total no. of orders
Select 'Total_orders' as measure_name,  count(distinct order_number) as measure_value
from [gold.fact_sales];				-- IN an order multiple product might be purchaced, therefore, distinct must be use for orders
-- Find total no. of products
Select 'Total_products' as measure_name, count( product_key) as measure_value
from [gold.dim_products];
-- Find total no. of customers
Select 'Total_customers' as measure_name, count(distinct customer_key) as measure_value
from [gold.dim_customers];
-- Find total no. of customers that have placed an order.
Select 'Total_customers' as measure_name, count(distinct customer_key) as measure_value
from [gold.fact_sales];


-- Instead of doing all of those separate query use just one query to print them --
Select 'Total Sales' as measure_name, sum(sales_amount) as measure_value from [gold.fact_sales]
union all
Select  'Total Items', Count(quantity) from [gold.fact_sales]
union all
Select 'Average Selling price' , Avg(price) from [gold.fact_sales]
union all
Select 'Total_orders' ,  count(distinct order_number)from [gold.fact_sales]
union all
Select 'Total_products' , count( product_key) from [gold.dim_products]
union all
Select 'Total_customers' , count(distinct customer_key) from [gold.dim_customers]
union all
Select 'customers_withAtleast_1order' , count(distinct customer_key) from [gold.fact_sales];

