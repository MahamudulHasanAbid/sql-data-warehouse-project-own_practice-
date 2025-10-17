/* ==============================================================
#Build Report for Customers
----------------------------

Purpose:
----------
	This report consolidates key customer metrics and behaviors
Hghlights:
-----------
	1. Gathers essential fields (names, ages, transactions, details)
	2. Segments customers into categories (VIP, Regular, New)
	3.Aggregate customer-level metrics:
		>> total orders
		>> total sales
		>> total quantity purchased
		>> total products
		>> lifespan(in months)
	4. Calculate valueable KPIs:
		>> recency(months since last order)
		>> average order value
		>> average monthly spend


============================================================== */

 -- use datawarehouseanalytics;

 Create View gold_report_customers as
 WITH base_query as(
/* ---------------------------------------------------------
1) Base Query: Retrieves core columns from tables
--------------------------------------------------------- */
Select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name, ' ', c.last_name ) as customer_name,
datediff(year, c.birthdate, getdate()) as age
from [gold.fact_sales] f
left join [gold.dim_customers] c
on f.customer_key =  c.customer_key
where order_date is not null)

, customer_aggregation as(
/* ------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metics at the customer level
------------------------------------------------------------------ */

select 
customer_key,
customer_number,
customer_name,
age,
count(Distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(Distinct product_key) as total_products,
max(order_date) as last_order_date,
datediff(month, min(order_date), max(order_date)) as lifespan
from base_query
group by
customer_key,
customer_number,
customer_name,
age)

/* ---------------------------------------------------------
3) Final Query:Combine all customer results into one output
--------------------------------------------------------- */

Select 
customer_key,
customer_number,
customer_name,
age,
case when age<20 then 'under 20'
	 when age between 20 and 29 then '20 - 29'
	 when age between 30 and 50 then '30 - 50'
	 else '50 and above'
end as age_group,

case when lifespan >= 12 and total_sales > 5000 then 'VIP'
	 when lifespan >= 12 and total_sales <= 5000 then 'Regular'
	 else 'New'
end customer_segment,
last_order_date,
datediff(month, last_order_date, getdate()) as recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
-- Compute average order value (AVO)
case when total_orders =  0 then 0
	 else total_sales / total_orders 
end as avg_order_value,
-- Compute average monthly spend
case when lifespan = 0 then total_sales
	 else total_sales / lifespan
end as avg_monthly_spend
from customer_aggregation

-- select * from gold_report_customers;
