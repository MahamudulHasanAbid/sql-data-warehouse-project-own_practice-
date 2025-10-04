/* =========================================
This is the most important part of EDA cause
	>> It helps to understand the scope of data
	>> It helps to understand the Timespan
	>> ,, ,, to Identify the boundary(earliest - latest) dates
	>> MIN[date dimension] / MAX[date dimension]
========================================= */

-- Find first & last order
Select  min(order_date) as first_order_date,
		max(order_date) as last_order_date
from [gold.fact_sales];

-- How many years of sales are available
Select 'Total sales year' as descrip, DATEDIFF(year, min(order_date), max(order_date)) as sales_period
from [gold.fact_sales]

-- Select youngest and oldest customer
Select 
max(birthdate) as youngest_customer_birthday, 
datediff(year, max(birthdate) , GETDATE()) as youngest_customer_age,
min(birthdate) as oldest_customer_birthday, 
datediff(year, min(birthdate) , GETDATE()) as oldest_customer_age
from [gold.dim_customers];
