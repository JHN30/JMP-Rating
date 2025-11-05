/*
===============================================================================
Table: silver.team_ratings_2025_weighted_2_1
===============================================================================
Purpose:
    Team-level weighted JEI ratings for Rating 2.1 (EuroLeague + EuroCup data).

Details:
    - Aggregates player-level Combined_JEI from 
      silver.player_jei_combined_2025_with_player_id
    - Applies exponential decay weighting by player rank within team
    - β = 0.07 → balanced 9-player effective depth
    - Produces totals, averages, EuroLeague/EuroCup breakdowns, and depth stats
===============================================================================
*/

-- Drop old version if it exists
IF OBJECT_ID('silver.team_ratings_2025_weighted_2_1', 'U') IS NOT NULL
    DROP TABLE silver.team_ratings_2025_weighted_2_1;

-- Create the new version of the table
SELECT
    team_id,
    ROUND(SUM(contrib), 0) AS Team_Weighted_JEI,
    ROUND(SUM(Combined_JEI), 0) AS Team_Total_JEI,
    ROUND(SUM(contrib_euroleague), 0) AS Team_Weighted_JEI_Euroleague,
    ROUND(SUM(contrib_eurocup), 0) AS Team_Weighted_JEI_Eurocup,
    ROUND(SUM(w), 2) AS Effective_Player_Count,       -- depth after exponential decay
    COUNT(*) AS Player_Count,                         -- raw roster size
    ROUND(SUM(CASE WHEN Data_Source = 'Euroleague + Eurocup' THEN 1 ELSE 0 END)
          * 100.0 / COUNT(*), 1) AS Percent_From_Eurocup,
    ROUND(AVG(Combined_JEI), 2) AS Team_Avg_JEI
INTO silver.team_ratings_2025_weighted_2_1
FROM (
    SELECT
        team_id,
        player_id,
        player_first_name,
        player_last_name,
        Combined_JEI,
        JEI_Euroleague,
        JEI_Eurocup,
        Data_Source,
        DENSE_RANK() OVER (PARTITION BY team_id ORDER BY Combined_JEI DESC) AS rnk,
        EXP(-0.07 * (DENSE_RANK() OVER (PARTITION BY team_id ORDER BY Combined_JEI DESC) - 1)) AS w,
        Combined_JEI * EXP(-0.07 * (DENSE_RANK() OVER (PARTITION BY team_id ORDER BY Combined_JEI DESC) - 1)) AS contrib,
        JEI_Euroleague * EXP(-0.07 * (DENSE_RANK() OVER (PARTITION BY team_id ORDER BY Combined_JEI DESC) - 1)) AS contrib_euroleague,
        COALESCE(JEI_Eurocup, 0) * EXP(-0.07 * (DENSE_RANK() OVER (PARTITION BY team_id ORDER BY Combined_JEI DESC) - 1)) AS contrib_eurocup
    FROM silver.player_jei_combined_2025_with_player_id
) AS weighted
GROUP BY team_id
ORDER BY Team_Weighted_JEI DESC;
