/*
===============================================================================
Stored Procedure: Load Bronze Layer - EuroCup
===============================================================================
Script Purpose:
    This stored procedure loads EuroCup player data into the 'bronze' schema 
    from an external CSV file. It performs the following actions:

    - Truncates the bronze.eurocup_players table before loading data.
    - Uses the `BULK INSERT` command to import data from a CSV file into the table.
    - Logs execution progress and duration for traceability.

Parameters:
    None.

Usage Example:
    EXEC bronze.load_bronze_eurocup;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze_eurocup AS
BEGIN
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Loading Bronze Layer - EuroCup';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading EuroCup Players Table';
        PRINT '------------------------------------------------';

        -- Step 1: Truncate existing table
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.eurocup_players';
        TRUNCATE TABLE bronze.eurocup_players;

        -- Step 2: Bulk insert new data
        PRINT '>> Inserting Data Into: bronze.eurocup_players';
        BULK INSERT bronze.eurocup_players
        FROM 'C:\Users\Korisnik\Desktop\JMP Rating\eurocup_players.csv' /* YOUR PATH TO CSV FILE */
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',
            ERRORFILE = 'C:\Temp\eurocup_players_error.log', /* YOUR PATH TO ERROR FOLDER (USUAL DESTINATION C:\Temp) */
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '------------------------------------------------';

        -- Step 3: End of batch logging
        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading Bronze Layer (EuroCup) Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';
    END TRY

    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER (EuroCup)';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State:   ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;
GO
