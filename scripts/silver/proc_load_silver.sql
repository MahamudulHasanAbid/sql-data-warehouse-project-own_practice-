/*
=============================================================
Stored Procedure; Load Silver Layer (Bronze -> Silver)
=============================================================

Script Purpose:
	This stored procedure does the ETL process to populate the 'silver' schema tables from the 'bronze' schema. and performs:
		- Truncate the silver tables before loading data.
		- Inserts transformed and cleansed data from Bronze into silver tables.

Parameters:
	None.
	This stored procedure does not accept any parameters or return any values.

*/


-- EXEC silver.load_silver;


Create or Alter Procedure silver.load_silver as
BEGIN
	Declare @start_time DateTime, @end_time DateTime, @batch_start_time DateTime, @batch_end_time DateTime;
	BEGIN TRY
	SET @batch_start_time = GETDATE();
		print'=================================================';
		print'Loading Silver Layer';
		print'=================================================';

		print'-------------------------------------------------';
		print'Loading CRM Tables';
		print'-------------------------------------------------';

		print'************************************************************************';
		/* Creating and Cleaning the customer Info (silver.crm_cust_info) table */
		
		SET @start_time = GETDATE()
		print'Truncating table : silver.crm_cust_info';
		truncate table silver.crm_cust_info;
		print'Isnerting data into : silver.crm_cust_info';

		Insert into silver.crm_cust_info(
		cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date
		)


		select cst_id, cst_key, 
		trim(cst_firstname) as cst_firstname, 
		trim(cst_lastname) as cst_lastname, 

		 case when upper(trim(cst_marital_status)) = 'S' then 'Single'
				when upper(trim(cst_marital_status)) = 'M' then 'Married'
				else  'n/a'
			end as cst_marital_status,

		 case when upper(trim(cst_gndr)) = 'M' then 'Male'
				when upper(trim(cst_gndr)) = 'F' then 'Female'
				else  'n/a'
			end as cst_gndr, 

		 cst_create_date
		from(
		select * ,
		ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null) t 
		where flag_last = 1 ;

		SET @end_time = GETDATE()
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + 'seconds';
		print'************************************************************************';

		print'************************************************************************';
		/* Creating and Cleaning the product Info (silver.crm_prd_info) table */

		SET @start_time = GETDATE()
		print'Truncating table : silver.crm_prd_info';
		truncate table silver.crm_prd_info;
		print'Inserting data into  : silver.crm_prd_info';

		Insert into silver.crm_prd_info(
		prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
		)


		select 
			prd_id, 
			REPLACE(SUBSTRING(prd_key, 1,5), '-','_') as cat_id, -- Derived Column from source's prd_key
			SUBSTRING(prd_key, 7,len(prd_key)) as prd_key, -- Derived Column from source's prd_key
			prd_nm, 
			coalesce(prd_cost, 0) as prd_cost,
			Case upper(trim(prd_line)) 
					when 'M' then 'Mountain'
					when 'R' then 'Road'
					when 'S' then 'Other Sales'
					when 'T' then 'Touring'
					else 'n/a' 
			end as prd_line,
			cast(prd_start_dt as date) as prd_start_dt, 
			cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) -1 as date) as prd_end_dt
		from bronze.crm_prd_info;

		SET @end_time = GETDATE()
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + 'seconds';
		print'************************************************************************';

		print'************************************************************************';
		/* Creating and Cleaning the Sales Details (silver.crm_sales_details) table */

		-- select top 1 * from bronze.crm_sales_details;

		SET @start_time = GETDATE()
		print'Truncating table : silver.crm_sales_details';
		truncate table silver.crm_sales_details;
		print'Inserting data into : silver.crm_sales_details';

		Insert into silver.crm_sales_details(
			sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
		)

		select 
		sls_ord_num,
		sls_prd_key, 
		sls_cust_id,

		Case when sls_order_dt <=0 or len(sls_order_dt) !=8 then NULL
			else cast(cast(sls_order_dt as varchar) as date)
		end as sls_order_dt,

		Case when sls_ship_dt <=0 or len(sls_ship_dt) !=8 then NULL
			else cast(cast(sls_ship_dt as varchar) as date)
		end as sls_ship_dt,

		Case when sls_due_dt <=0 or len(sls_due_dt) !=8 then NULL
			else cast(cast(sls_due_dt as varchar) as date)
		end as sls_due_dt,

		Case when sls_sales is null OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
			then sls_quantity * ABS(sls_price)
			else sls_sales
		end as sls_sales,

		sls_quantity,

		Case when sls_price is null OR sls_price <= 0
			then sls_sales / nullif(sls_quantity, 0)
			else sls_price
		end as sls_price
		from bronze.crm_sales_details;

		SET @end_time = GETDATE()
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + 'seconds';
		print'************************************************************************';

		print'-------------------------------------------------';
		print'Loading ERP Tables';
		print'-------------------------------------------------';


		print'************************************************************************';
		/* Creating and Cleaning the Sales Details (silver.erp_cust_az12) table */

		SET @start_time =GETDATE()
		print'Truncating table : silver.erp_cust_az12';
		truncate table silver.erp_cust_az12;
		print'Inserting data into  : silver.erp_cust_az12';

		Insert into silver.erp_cust_az12(
		cid, bdate, gen
		)

		select 
		Case when cid like 'NAS%' then SUBSTRING(cid, 4, len(cid))
			else cid
		end as cid,

		Case when bdate > GETDATE() then NULL
			else bdate
		end as bdate,

		Case when upper(trim(gen))  in('M', 'MALE') then 'Male'
			when upper(trim(gen)) in('F', 'FEMALE') then 'Female'
			else 'n/a'
		end as gen
		from bronze.erp_cust_az12;

		SET @end_time = GETDATE()
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + 'seconds';
		print'************************************************************************';

		print'************************************************************************';
		/* Creating and Cleaning the Sales Details (silver.erp_loc_a101) */

		SET @start_time = GETDATE()
		print'Truncating table : silver.erp_loc_a101';
		truncate table silver.erp_loc_a101;
		print'Inserting data into  : silver.erp_loc_a101';

		Insert into silver.erp_loc_a101(
		cid, cntry
		)

		select 
		replace(cid,'-', '') as cid,

		Case when upper(trim(cntry)) in ('US','USA') then 'United States' 
			when upper(trim(cntry)) = 'DE' then 'Germany'
			when upper(trim(cntry)) = '' OR cntry is null then 'n/a'
			else trim(cntry)
		end as cntry

		from bronze.erp_loc_a101

		SET @end_time = GETDATE()
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + 'seconds';
		print'************************************************************************';

		print'************************************************************************';
		/* Creating and Cleaning the Sales Details (silver.erp_px_cat_g1v2) */

		SET @start_time = GETDATE()
		print'Truncating table : silver.erp_px_cat_g1v2';
		truncate table silver.erp_px_cat_g1v2;
		print'Inserting data into  : silver.erp_px_cat_g1v2';

		INSERT INTO silver.erp_px_cat_g1v2 (
			id, cat, subcat, maintenance
		)
		SELECT id, cat, subcat, maintenance
		FROM bronze.erp_px_cat_g1v2;

		--no cleaning is needed for this table as bronze layer satisfy the checking criteria.

		SET @end_time = GETDATE()
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + 'seconds';
		print'************************************************************************';

		SET @batch_end_time = GETDATE();
		print'########################################################';
		print'>> Loading Silver layer is Completed.';
		print'>> Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
		print'########################################################';
	END TRY
	Begin CATCH
		print'########################################################';
		print'Error OCCURED DURING LOADING BRONZE LAYER';
		print'Error Message'+ error_message();
		print'Error Message' + cast(error_number() as nvarchar);
		print'Error Message' + cast(error_state() as nvarchar);
		print'########################################################';
	END CATCH
END
