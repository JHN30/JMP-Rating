/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
    Actions Performed:
        - Truncates Silver tables.
        - Inserts transformed and cleansed data from Bronze into Silver tables.
        
Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver_euroleague;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver_euroleague 
AS
BEGIN
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading Euroleague table';
        PRINT '------------------------------------------------';

        -- Loading silver.euroleague_players
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.euroleague_players';
        TRUNCATE TABLE silver.euroleague_players;

        PRINT '>> Inserting Data Into: silver.euroleague_players';
        INSERT INTO silver.euroleague_players (
            season_player_id,
            season_code,
            player_id,
            player_last_name,
            player_first_name,
            team_id,
            games_played,
            games_started,
            minutes,
            points,
            two_points_made,
            two_points_attempted,
            three_points_made,
            three_points_attempted,
            free_throws_made,
            free_throws_attempted,
            offensive_rebounds,
            defensive_rebounds,
            total_rebounds,
            assists,
            steals,
            turnovers,
            blocks_favour,
            blocks_against,
            fouls_committed,
            fouls_received,
            valuation,
            plus_minus,
            minutes_per_game,
            points_per_game,
            two_points_made_per_game,
            two_points_attempted_per_game,
            two_points_percentage,
            three_points_made_per_game,
            three_points_attempted_per_game,
            three_points_percentage,
            free_throws_made_per_game,
            free_throws_attempted_per_game,
            free_throws_percentage,
            offensive_rebounds_per_game,
            defensive_rebounds_per_game,
            total_rebounds_per_game,
            assists_per_game,
            steals_per_game,
            turnovers_per_game,
            blocks_favour_per_game,
            blocks_against_per_game,
            fouls_committed_per_game,
            fouls_received_per_game,
            valuation_per_game,
            plus_minus_per_game
        )
        SELECT
            season_player_id,
            season_code,
            player_id,
            SUBSTRING(TRIM(player_last_name), 2, LEN(TRIM(player_last_name))) AS player_last_name,
            SUBSTRING(TRIM(player_first_name), 1, LEN(TRIM(player_first_name)) - 1) AS player_first_name,
            team_id,
            games_played,
            games_started,
            minutes,
            points,
            two_points_made,
            two_points_attempted,
            three_points_made,
            three_points_attempted,
            free_throws_made,
            free_throws_attempted,
            offensive_rebounds,
            defensive_rebounds,
            total_rebounds,
            assists,
            steals,
            turnovers,
            blocks_favour,
            blocks_against,
            fouls_committed,
            fouls_received,
            valuation,
            plus_minus,
            minutes_per_game,
            points_per_game,
            two_points_made_per_game,
            two_points_attempted_per_game,
            two_points_percentage,
            three_points_made_per_game,
            three_points_attempted_per_game,
            three_points_percentage,
            free_throws_made_per_game,
            free_throws_attempted_per_game,
            free_throws_percentage,
            offensive_rebounds_per_game,
            defensive_rebounds_per_game,
            total_rebounds_per_game,
            assists_per_game,
            steals_per_game,
            turnovers_per_game,
            blocks_favour_per_game,
            blocks_against_per_game,
            fouls_committed_per_game,
            fouls_received_per_game,
            valuation_per_game,
            plus_minus_per_game
        FROM bronze.euroleague_players
        WHERE minutes > 2;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @batch_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';

    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;
