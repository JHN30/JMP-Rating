/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('bronze.euroleague_players', 'U') IS NOT NULL
    DROP TABLE bronze.euroleague_players;
GO

CREATE TABLE bronze.euroleague_players (
    season_player_id                   NVARCHAR(50),
    season_code                        NVARCHAR(30),
    player_id                          NVARCHAR(50),
    player_last_name                   NVARCHAR(50),
	player_first_name                  NVARCHAR(50),
    team_id                            NVARCHAR(20),

    games_played                       FLOAT,
    games_started                      FLOAT,
    minutes                            FLOAT,

    points                             INT,
    two_points_made                    INT,
    two_points_attempted               INT,
    three_points_made                  INT,
    three_points_attempted             INT,
    free_throws_made                   INT,
    free_throws_attempted              INT,

    offensive_rebounds                 INT,
    defensive_rebounds                 INT,
    total_rebounds                     INT,

    assists                            INT,
    steals                             INT,
    turnovers                          INT,
    blocks_favour                      INT,
    blocks_against                     INT,
    fouls_committed                    INT,
    fouls_received                     INT,
    valuation                          INT,
    plus_minus                         INT,

    minutes_per_game                   FLOAT,
    points_per_game                    FLOAT,
    two_points_made_per_game           FLOAT,
    two_points_attempted_per_game      FLOAT,
    two_points_percentage              FLOAT,
    three_points_made_per_game         FLOAT,
    three_points_attempted_per_game    FLOAT,
    three_points_percentage            FLOAT,
    free_throws_made_per_game          FLOAT,
    free_throws_attempted_per_game     FLOAT,
    free_throws_percentage             FLOAT,

    offensive_rebounds_per_game        FLOAT,
    defensive_rebounds_per_game        FLOAT,
    total_rebounds_per_game            FLOAT,
    assists_per_game                   FLOAT,
    steals_per_game                    FLOAT,
    turnovers_per_game                 FLOAT,
    blocks_favour_per_game             FLOAT,
    blocks_against_per_game            FLOAT,
    fouls_committed_per_game           FLOAT,
    fouls_received_per_game            FLOAT,
    valuation_per_game                 FLOAT,
    plus_minus_per_game                FLOAT
);
GO

