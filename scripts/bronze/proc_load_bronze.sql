/*
=============================================================
Stored Procedure; Load Bronze Layer (Source -> Bronze)
=============================================================

Script Purpose:


Parameters:


*/


-- EXEC bronze.load_bronze;

Create OR Alter procedure bronze.load_bronze as
BEGIN
	Declare @start_time DateTime, @end_time DateTime, @batch_start_time DateTime, @batch_end_time DateTime;
	BEGIN TRY
	SET @batch_start_time = GETDATE();
		print'=================================================';
		print'Loading Bronze Layer';
		print'=================================================';

		print'-------------------------------------------------';
		print'Loading CRM Tables';
		print'-------------------------------------------------';

		print'************************************************************************';
		SET @start_time = GETDATE();
		print'>> Truncating Table: bronze.crm_cust_info:';
		TRUNCATE table bronze.crm_cust_info;

		print'>> Inserting Data into Table: bronze.crm_cust_info:';
		BULK INSERT bronze.crm_cust_info
		from 'G:\Data Analytics\SQL\Data_with_Bara\Data_Warehouse_Project_own\Source_data\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time = GETDATE();
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print'************************************************************************';


		SET @start_time = GETDATE();
		print'>> Truncating Table: bronze.crm_prd_info:';
		TRUNCATE table bronze.crm_prd_info;

		print'>> Inserting Data into Table: bronze.crm_prd_info:';
		BULK INSERT bronze.crm_prd_info
		from 'G:\Data Analytics\SQL\Data_with_Bara\Data_Warehouse_Project_own\Source_data\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time = GETDATE();
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar ) + 'seconds';
		print'************************************************************************';


		SET @start_time= GETDATE();
		print'>> Truncating Table: bronze.crm_sales_details:';
		TRUNCATE table bronze.crm_sales_details;

		print'>> Inserting Data into Table: bronze.crm_sales_details:';
		BULK INSERT bronze.crm_sales_details
		from 'G:\Data Analytics\SQL\Data_with_Bara\Data_Warehouse_Project_own\Source_data\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print'************************************************************************';


		print'-------------------------------------------------';
		print'Loading ERP Tables';
		print'-------------------------------------------------';
		print'************************************************************************';
		SET @start_time= GETDATE();
		print'>> Truncating Table: bronze.erp_cust_az12:';
		TRUNCATE table bronze.erp_cust_az12;

		print'>> Inserting Data into Table: bronze.erp_cust_az12:';
		BULK INSERT bronze.erp_cust_az12
		from 'G:\Data Analytics\SQL\Data_with_Bara\Data_Warehouse_Project_own\Source_data\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print'************************************************************************';


		SET @start_time= GETDATE();
		print'>> Truncating Table: bronze.erp_loc_a101:';
		TRUNCATE table bronze.erp_loc_a101;

		print'>> Inserting Data into Table: bronze.erp_loc_a101:';
		BULK INSERT bronze.erp_loc_a101
		from 'G:\Data Analytics\SQL\Data_with_Bara\Data_Warehouse_Project_own\Source_data\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'second';
		print'************************************************************************';


		SET @start_time= GETDATE();
		print'>> Truncating Table: bronze.erp_px_cat_g1v2:';
		TRUNCATE table bronze.erp_px_cat_g1v2;

		print'>> Inserting Data into Table: bronze.erp_px_cat_g1v2:';
		BULK INSERT bronze.erp_px_cat_g1v2
		from 'G:\Data Analytics\SQL\Data_with_Bara\Data_Warehouse_Project_own\Source_data\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		print'>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print'************************************************************************';



		SET @batch_end_time = GETDATE();
		print'########################################################';
		print'>> Loading Bronze layer is Completed.';
		print'>> Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
		print'########################################################';
	END TRY

	BEGIN CATCH
		print'########################################################';
		print'Error OCCURED DURING LOADING BRONZE LAYER';
		print'Error Message'+ error_message();
		print'Error Message' + cast(error_number() as nvarchar);
		print'Error Message' + cast(error_state() as nvarchar);
		print'########################################################';
	END CATCH
END
