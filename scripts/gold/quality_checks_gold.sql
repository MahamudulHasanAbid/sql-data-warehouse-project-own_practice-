/* This file have no comment or not decorized Just pasted what I did. Later I will develop the code with proper comments.*/

-- use DataWarehouse;
select 
ci.cst_gndr,
ca.GEN,
CASE when ci.cst_gndr != 'n/a' then ci.cst_gndr
	 else coalesce( ca.GEN, 'n/a')
end as new_gender
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca on ci.cst_key = ca.CID
left join silver.erp_loc_a101 la on ci.cst_key = la.CID;


select distinct gender from gold.dim_customers;


select prd_key, count(*) from
(
	select 
	pn.prd_id, 
	pn.cat_id, 
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost, 
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat, 
	pc.SUBCAT,
	pc.MAINTENANCE
	from silver.crm_prd_info pn
	left join silver.erp_px_cat_g1v2 pc on pn.cat_id = pc.ID
	where prd_end_dt is null -- As the business case is only for current data (Filter out all historical data).
) t 
group by prd_key
having count(*) > 1


select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details;



-- forign key integrety (Dimension)

select * from gold.fact_sales fs
left join gold.dim_customers dc on fs.customer_key = dc.customer_key
left join gold.dim_products dp on fs.product_key = dp.product_key
where dc.customer_key is  null;

select top 1 * from gold.dim_customers;
select top 1 * from gold.dim_products;

