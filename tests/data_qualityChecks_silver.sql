/*
Usage Notes: 
    >> Run these checks after loading data into silver layer.
    >> Investigate and resolve any discrepancies found during the checks.

*/

/* ------------------------------------------------------------
Checking the customer Info (bronze.crm_cust_info) table 
-------------------------------------------------------------*/
select count(*) from bronze.crm_cust_info;

-- Check for Duplicates and Null in primary key
--Expectation : No results
select cst_id, count(*)
from  bronze.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

-- Primary key must be unique and not null

-- Check for unwanted space
--Expectation : No results
select cst_firstname
from bronze.crm_cust_info
where cst_firstname != trim(cst_firstname); -- same for the last_name or other column which have unwanted spaces.

-- Data Standardization & Consistancy
select distinct cst_gndr
from bronze.crm_cust_info;

select distinct cst_marital_status
from bronze.crm_cust_info;


/* check the silver layer after inserting data into silver.crm_cust_info */

select count(*)
from silver.crm_cust_info;


select cst_id, count(*) as total_cst_id
from  silver.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

select cst_lastname
from silver.crm_cust_info
where cst_lastname != trim(cst_lastname);

select distinct cst_gndr
from silver.crm_cust_info;

select distinct cst_marital_status
from silver.crm_cust_info;



/* ------------------------------------------------------------
Checking the Product Info (bronze.crm_prd_info) table 
-------------------------------------------------------------*/

-- Check for Duplicates and Null in primary key
--Expectation : No results
select * from bronze.crm_prd_info;

select prd_id, count(*)
from bronze.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;

select prd_cost, count(*)
from bronze.crm_prd_info
group by prd_cost
having prd_cost<0 or prd_cost is null;

-- Check for unwanted space
--Expectation : No results
select prd_nm
from bronze.crm_prd_info
where prd_nm != trim(prd_nm);

-- Data Standardization & Consistancy
select distinct prd_line
from bronze.crm_prd_info;

--Check for Invalid Date Orders
select * 
from bronze.crm_prd_info
where prd_start_dt > prd_end_dt ;


/*  check the silver layer after inserting data into silver.crm_prd_info */

select *
from silver.crm_prd_info;


select prd_id, count(*) as total_prd_id
from  silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;

select prd_nm
from silver.crm_prd_info
where prd_nm != trim(prd_nm);

select prd_cost, count(*)
from silver.crm_prd_info
group by prd_cost
having prd_cost<0 or prd_cost is null;

select distinct prd_line
from silver.crm_prd_info;

--Check for Invalid Date Orders
select * 
from silver.crm_prd_info
where prd_start_dt > prd_end_dt ;



/* ------------------------------------------------------------
Checking the sales Details (bronze.crm_sales_details) table 
------------------------------------------------------------- */

--Checking the Integrity of the selected columns
select *
from bronze.crm_sales_details
where sls_cust_id not in (select cst_id from silver.crm_cust_info);

select *
from bronze.crm_sales_details
where sls_prd_key not in (select prd_key from silver.crm_prd_info);

--Check Invalid Dates

select sls_order_dt
from bronze.crm_sales_details
where	sls_order_dt <= 0 
		or len(sls_order_dt) != 8
		or sls_order_dt > 20500101
		or sls_order_dt <20000101;

--Check Invalid order Dates
--Order date must  always be earlier than Ship date and due date.

select  *
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or  sls_order_dt > sls_due_dt

-- Check Data Consistency between sales, quantity and price
-- >> Sales = Quantity * Price
-- >> Negative, Zero, NULLs are not allowed

select distinct
sls_sales, sls_quantity, sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
	or sls_sales is null or sls_quantity is null or sls_price is null
	or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_quantity, sls_price;



/* check the silver layer after inserting data into silver.crm_sales_details */

--Checking the Integrity of the selected columns
select *
from silver.crm_sales_details
where sls_cust_id not in (select cst_id from silver.crm_cust_info);

select *
from silver.crm_sales_details
where sls_prd_key not in (select prd_key from silver.crm_prd_info);

--Check Invalid Dates

SELECT sls_order_dt
FROM silver.crm_sales_details
WHERE 
    TRY_CONVERT(VARCHAR(8), sls_order_dt, 112) IS NULL
    OR LEN(CONVERT(VARCHAR(8), sls_order_dt, 112)) != 8
    OR sls_order_dt > '2050-01-01'
    OR sls_order_dt < '2000-01-01';

--Check Invalid order Dates
--Order date must  always be earlier than Ship date and due date.

select  *
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or  sls_order_dt > sls_due_dt

-- Check Data Consistency between sales, quantity and price
-- >> Sales = Quantity * Price
-- >> Negative, Zero, NULLs are not allowed

select distinct
sls_sales, sls_quantity, sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
	or sls_sales is null or sls_quantity is null or sls_price is null
	or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_quantity, sls_price;

select * from
silver.crm_sales_details;


/* ------------------------------------------------------------
Checking the sales Details (bronze.erp_cust_az12) table 
------------------------------------------------------------- */

select * from bronze.erp_cust_az12;
select * from bronze.crm_cust_info;

-- Check invalid or out_of_range dates

select bdate 
from bronze.erp_cust_az12
where bdate < '2000-01-01' OR bdate > GETDATE()

--Data Standardization and Consistency

select distinct gen
from bronze.erp_cust_az12;


/* check the silver layer after inserting data into silver.erp_cust_az12 */

-- Check invalid or out_of_range dates

select bdate 
from silver.erp_cust_az12
where  bdate > GETDATE()

--Data Standardization and Consistency

select distinct gen
from silver.erp_cust_az12;


/* ------------------------------------------------------------
Checking the sales Details (bronze.erp_loc_a101) table 
------------------------------------------------------------- */
select * from bronze.erp_loc_a101;

select 
replace(cid,'-', '') as cid,
cntry 
from bronze.erp_loc_a101 where cid not in (select cst_key from silver.crm_cust_info);

--Data Standardization and Consistency

select distinct 
cntry as old_cntry,

Case when upper(trim(cntry)) in ('US','USA') then 'United States' 
	when upper(trim(cntry)) = 'DE' then 'Germeny'
	when upper(trim(cntry)) = '' OR cntry is null then 'n/a'
	else trim(cntry)
end as cntry
from bronze.erp_loc_a101
order by cntry;


/* check the silver layer after inserting data into silver.erp_loc_a101 */

select 
replace(cid,'-', '') as cid,
cntry 
from silver.erp_loc_a101 where cid not in (select cst_key from silver.crm_cust_info);

select cid
from silver.erp_loc_a101 where cid like '%-%';

--Data Standardization and Consistency

select distinct 
cntry 
from silver.erp_loc_a101
order by cntry;

/* ------------------------------------------------------------
Checking the sales Details (bronze.erp_px_cat_g1v2) table 
------------------------------------------------------------- */

select *
from bronze.erp_px_cat_g1v2;

select 
cat, subcat, maintenance
from bronze.erp_px_cat_g1v2
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance)


--Data standardization and Consistancy

select distinct cat
from bronze.erp_px_cat_g1v2

select distinct subcat
from bronze.erp_px_cat_g1v2

select distinct maintenance
from bronze.erp_px_cat_g1v2

/* check the silver layer after inserting data into silver.erp_loc_a101 */

select *
from silver.erp_px_cat_g1v2;

/* Below is the most last step in our silver layer. Just execute the thing.*/

-- EXEC bronze.load_bronze;

-- EXEC silver.load_silver;
