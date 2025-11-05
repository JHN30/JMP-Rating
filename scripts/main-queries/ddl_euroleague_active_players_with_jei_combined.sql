DROP TABLE IF EXISTS silver.player_jei_active_latestteam_2025;

WITH active_players AS (
    SELECT DISTINCT player_id
    FROM silver.euroleague_players
    WHERE season_code = 'E2025'
),
filtered AS (
    SELECT *
    FROM silver.euroleague_players p
    WHERE p.player_id IN (SELECT player_id FROM active_players)
      AND CAST(SUBSTRING(p.season_code, 2, 4) AS INT) <= 2025
),
player_jei AS (
    SELECT
        player_id,
        player_first_name,
        player_last_name,
        team_id,
        season_code,
        games_played,
        CAST(SUBSTRING(season_code, 2, 4) AS INT) AS season_year,
        CAST(((
                0.30 * (
                    (points / NULLIF(MAX(points) OVER(), 0)) * 0.25 +
                    (points_per_game / NULLIF(MAX(points_per_game) OVER(), 0)) * 0.25 +
                    (two_points_made / NULLIF(MAX(two_points_made) OVER(), 0)) * 0.05 +
                    (two_points_percentage / 100.0) * 0.10 +
                    (three_points_made / NULLIF(MAX(three_points_made) OVER(), 0)) * 0.05 +
                    (three_points_percentage / 100.0) * 0.10 +
                    (free_throws_made / NULLIF(MAX(free_throws_made) OVER(), 0)) * 0.05 +
                    (free_throws_percentage / 100.0) * 0.10
                )
                + 0.15 * (
                    (offensive_rebounds / NULLIF(MAX(offensive_rebounds) OVER(), 0)) * 0.25 +
                    (defensive_rebounds / NULLIF(MAX(defensive_rebounds) OVER(), 0)) * 0.25 +
                    (total_rebounds / NULLIF(MAX(total_rebounds) OVER(), 0)) * 0.25 +
                    (total_rebounds_per_game / NULLIF(MAX(total_rebounds_per_game) OVER(), 0)) * 0.25
                )
                + 0.15 * (
                    (assists / NULLIF(MAX(assists) OVER(), 0)) * 0.40 +
                    (assists_per_game / NULLIF(MAX(assists_per_game) OVER(), 0)) * 0.40 -
                    (turnovers / NULLIF(MAX(turnovers) OVER(), 0)) * 0.10 -
                    (turnovers_per_game / NULLIF(MAX(turnovers_per_game) OVER(), 0)) * 0.10
                )
                + 0.20 * (
                    (steals / NULLIF(MAX(steals) OVER(), 0)) * 0.20 +
                    (steals_per_game / NULLIF(MAX(steals_per_game) OVER(), 0)) * 0.20 +
                    (blocks_favour / NULLIF(MAX(blocks_favour) OVER(), 0)) * 0.15 +
                    (blocks_favour_per_game / NULLIF(MAX(blocks_favour_per_game) OVER(), 0)) * 0.15 +
                    (1 - (fouls_committed / NULLIF(MAX(fouls_committed) OVER(), 0))) * 0.10 +
                    (1 - (fouls_committed_per_game / NULLIF(MAX(fouls_committed_per_game) OVER(), 0))) * 0.10 +
                    (fouls_received / NULLIF(MAX(fouls_received) OVER(), 0)) * 0.05 +
                    (fouls_received_per_game / NULLIF(MAX(fouls_received_per_game) OVER(), 0)) * 0.05
                )
                + 0.20 * (
                    (valuation / NULLIF(MAX(valuation) OVER(), 0)) * 0.40 +
                    (valuation_per_game / NULLIF(MAX(valuation_per_game) OVER(), 0)) * 0.30 +
                    (plus_minus / NULLIF(MAX(plus_minus) OVER(), 0)) * 0.15 +
                    (plus_minus_per_game / NULLIF(MAX(plus_minus_per_game) OVER(), 0)) * 0.15
                )
            ) * 1000
        ) AS DECIMAL(6,2)) AS JMP_Efficiency_Index
    FROM filtered
),
weighted AS (
    SELECT
        p.player_id,
        p.player_first_name,
        p.player_last_name,
        p.team_id,
        p.season_code,
        p.season_year,
        p.games_played,
        p.JMP_Efficiency_Index,
        MAX(p.season_year) OVER (PARTITION BY p.player_id) AS max_season,
        EXP(-0.25 * (MAX(p.season_year) OVER (PARTITION BY p.player_id) - p.season_year)) AS RecencyWeight
    FROM player_jei p
),
player_agg AS (
    SELECT
        player_id,
        player_first_name,
        player_last_name,
        COUNT(DISTINCT season_code) AS Seasons_Played,
        SUM(games_played) AS Total_Games,
        SUM(JMP_Efficiency_Index * games_played * RecencyWeight) /
        NULLIF(SUM(games_played * RecencyWeight), 0) AS RecencyWeightedAvg_JEI
    FROM weighted
    GROUP BY player_id, player_first_name, player_last_name
),
latest_team AS (
    SELECT DISTINCT
        player_id,
        FIRST_VALUE(team_id) OVER (PARTITION BY player_id ORDER BY season_year DESC) AS latest_team_id
    FROM weighted
)
SELECT
    pa.player_id,
    pa.player_first_name,
    pa.player_last_name,
    lt.latest_team_id AS team_id,
    ROUND((1 - EXP(-1.0 * pa.Total_Games / 15.0)) * pa.RecencyWeightedAvg_JEI, 2) AS FinalWeighted_JEI
INTO silver.player_jei_active_latestteam_2025
FROM player_agg pa
JOIN latest_team lt ON pa.player_id = lt.player_id;
