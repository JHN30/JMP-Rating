-- ==============================================
-- Rating 2.0 (EuroLeague-only)
-- ==============================================
WITH rating20 AS (
    SELECT
        team_id,
        ROUND(SUM(contrib), 0) AS Team_Weighted_JEI_20
    FROM (
        SELECT
            team_id,
            FinalWeighted_JEI,
            EXP(-0.09 * (DENSE_RANK() OVER (PARTITION BY team_id ORDER BY FinalWeighted_JEI DESC) - 1)) AS w,
            FinalWeighted_JEI * EXP(-0.09 * (DENSE_RANK() OVER (PARTITION BY team_id ORDER BY FinalWeighted_JEI DESC) - 1)) AS contrib
        FROM silver.player_jei_active_latestteam_2025
    ) AS w20
    GROUP BY team_id
),
rating20_ranked AS (
    SELECT
        team_id,
        Team_Weighted_JEI_20,
        DENSE_RANK() OVER (ORDER BY Team_Weighted_JEI_20 DESC) AS Rank_20
    FROM rating20
),

-- ==============================================
-- Rating 2.1 (EuroLeague + EuroCup)
-- ==============================================
rating21 AS (
    SELECT
        team_id,
        ROUND(SUM(contrib), 0) AS Team_Weighted_JEI_21
    FROM (
        SELECT
            team_id,
            Combined_JEI,
            EXP(-0.07 * (DENSE_RANK() OVER (PARTITION BY team_id ORDER BY Combined_JEI DESC) - 1)) AS w,
            Combined_JEI * EXP(-0.07 * (DENSE_RANK() OVER (PARTITION BY team_id ORDER BY Combined_JEI DESC) - 1)) AS contrib
        FROM silver.player_jei_combined_2025_with_player_id
    ) AS w21
    GROUP BY team_id
),
rating21_ranked AS (
    SELECT
        team_id,
        Team_Weighted_JEI_21,
        DENSE_RANK() OVER (ORDER BY Team_Weighted_JEI_21 DESC) AS Rank_21
    FROM rating21
),

-- ==============================================
-- Combine and compare
-- ==============================================
combined AS (
    SELECT
        COALESCE(r20.team_id, r21.team_id) AS team_id,
        r20.Team_Weighted_JEI_20,
        r21.Team_Weighted_JEI_21,
        r20.Rank_20,
        r21.Rank_21,
        ROUND(COALESCE(r21.Team_Weighted_JEI_21, 0) - COALESCE(r20.Team_Weighted_JEI_20, 0), 1) AS JEI_Change,
        CASE 
            WHEN COALESCE(r20.Team_Weighted_JEI_20, 0) = 0 THEN NULL
            ELSE ROUND((COALESCE(r21.Team_Weighted_JEI_21, 0) - COALESCE(r20.Team_Weighted_JEI_20, 0))
                       / r20.Team_Weighted_JEI_20 * 100.0, 1)
        END AS Percent_Change,
        CASE 
            WHEN r20.Rank_20 IS NULL THEN NULL
            WHEN r21.Rank_21 IS NULL THEN NULL
            ELSE (r20.Rank_20 - r21.Rank_21)
        END AS Rank_Change
    FROM rating20_ranked r20
    FULL OUTER JOIN rating21_ranked r21
        ON r20.team_id = r21.team_id
)
SELECT
    team_id,
    Team_Weighted_JEI_20,
    Team_Weighted_JEI_21,
    JEI_Change,
    Percent_Change,
    Rank_20,
    Rank_21,
    CASE 
        WHEN Rank_Change > 0 THEN '+' + CAST(Rank_Change AS NVARCHAR)
        WHEN Rank_Change < 0 THEN CAST(Rank_Change AS NVARCHAR)
        ELSE '0'
    END AS Rank_Change_Display
FROM combined
ORDER BY Rank_21 ASC;
