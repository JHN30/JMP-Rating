WITH ranked AS (
    SELECT
        team_id,
        player_first_name,
        player_last_name,
        FinalWeighted_JEI,
        DENSE_RANK() OVER (PARTITION BY team_id ORDER BY FinalWeighted_JEI DESC) AS rnk
    FROM silver.player_jei_active_latestteam_2025
),
weighted AS (
    SELECT
        team_id,
        player_first_name,
        player_last_name,
        FinalWeighted_JEI,
        rnk,
        /* β = 0.15 is a good starting point; lower it for more depth, or make it higher for more star bias */
        EXP(-0.09 * (rnk - 1)) AS w,
        FinalWeighted_JEI * EXP(-0.09 * (rnk - 1)) AS contrib
    FROM ranked
)
SELECT
    team_id,
    ROUND(SUM(contrib), 0) AS Team_Weighted_JEI,
    SUM(w)       AS Effective_Player_Count, -- “depth” after decay
    COUNT(*)     AS Player_Count            -- raw roster size (for reference)
FROM weighted
GROUP BY team_id
ORDER BY Team_Weighted_JEI DESC;
