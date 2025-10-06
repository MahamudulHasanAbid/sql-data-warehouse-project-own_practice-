/* ===============================================
Order the value of dimensions by Measure
Like,
	Top N performers | Bottom N performers
Ranking Analysis = Rank [Dimension] BY Σ[Measure]
=============================================== */
use DataWarehouseAnalytics;

-- Which 5 products generate highest revenue

	 -- select top 3 * from [gold.dim_products];
	 -- select top 3 * from [gold.fact_sales];

	Select top 5 
	dp.product_name, dp.subcategory, sum(fs.sales_amount) as total_revenue
	from [gold.fact_sales] fs
	left join [gold.dim_products] dp
	on fs.product_key = dp.product_key
	group by dp.product_name, dp.subcategory
	order by total_revenue desc;

	-- Same query using window function
	Select * 
	from(
		Select 
		dp.product_name, dp.subcategory, 
		sum(fs.sales_amount) as total_revenue,
		row_number() over(order by sum(fs.sales_amount) desc) as highest_ranking
		from [gold.fact_sales] fs
		left join [gold.dim_products] dp
		on fs.product_key = dp.product_key
		group by dp.product_name, dp.subcategory)t
	where highest_ranking <= 5;

-- What are the 5 worst-performing products in terms of sales
	Select top 5 
	dp.product_name, dp.subcategory, sum(fs.sales_amount) as total_revenue
	from [gold.fact_sales] fs
	left join [gold.dim_products] dp
	on fs.product_key = dp.product_key
	group by dp.product_name, dp.subcategory
	order by total_revenue ;

	-- Same query using window function
	Select * 
	from(
		Select 
		dp.product_name, dp.subcategory, 
		sum(fs.sales_amount) as total_revenue,
		row_number() over(order by sum(fs.sales_amount) asc) as lowest_ranking
		from [gold.fact_sales] fs
		left join [gold.dim_products] dp
		on fs.product_key = dp.product_key
		group by dp.product_name, dp.subcategory)t
	where lowest_ranking <= 5;
	

-- Find top 10 customers who have generated highest revenue

	Select top 10 
	fs.customer_key ,concat(dc.first_name,' ', dc.last_name) as customer_name,
	sum(fs.sales_amount) as total_revenue
	from [gold.fact_sales] fs
	left join [gold.dim_customers] dc 
	on fs.customer_key = dc.customer_key
	group by fs.customer_key, concat(dc.first_name,' ', dc.last_name)
	order by total_revenue desc;

	-- Using window function
	
	Select * 
	from(
		Select 
		fs.customer_key ,concat(dc.first_name,' ', dc.last_name) as customer_name,
		sum(fs.sales_amount) as total_revenue,
		row_number() over(order by sum(fs.sales_amount) desc) as highest_ranking
		from [gold.fact_sales] fs
		left join [gold.dim_customers] dc 
		on fs.customer_key = dc.customer_key
		group by fs.customer_key, concat(dc.first_name,' ', dc.last_name))t
	where  highest_ranking<= 10;
-- Find top 3 customers with fewest orders placed

Select top 5
fs.customer_key,
concat(dc.first_name,' ', dc.last_name) as customer_name, 
count( distinct order_number) as total_orders
from [gold.fact_sales] fs
left join [gold.dim_customers] dc
on fs.customer_key = dc.customer_key
group by fs.customer_key, concat(dc.first_name,' ', dc.last_name)
order by total_orders asc;


-- Using window functions
select * 
from(
	Select 
	fs.customer_key, concat(dc.first_name,' ', dc.last_name) as customer_name, 
	count( distinct fs.order_number) as total_orders,
	ROW_NUMBER() over(order by count( distinct fs.order_number) asc) as lowest_ranking
	from [gold.fact_sales] fs
	left join [gold.dim_customers] dc
	on fs.customer_key = dc.customer_key
	group by fs.customer_key, concat(dc.first_name,' ', dc.last_name)) t
where lowest_ranking <= 5;
