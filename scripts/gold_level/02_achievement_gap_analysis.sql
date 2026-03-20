-- ============================================================
-- Script      : Gold Layer Report 02
-- Report Name : Achievement Gap Analysis
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Gold (Aggregated and Reporting Ready)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : gold
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Compares performance of each student group
--               against All Students baseline.
--               Gap = All Students Rate - Student Group Rate
--               Positive gap means group is below average.
--               Negative gap means group is above average.
-- ============================================================

WITH AllStudents AS
(
    -- Get All Students rate as the baseline
    SELECT
        Measure,
        ROUND(
            CAST(SUM(Numerator) AS FLOAT)
            / NULLIF(SUM(Denominator), 0) * 100
        , 2)                                AS AllStudents_Pct
    FROM silver.school_performance
    WHERE
        StudentGroup = 'All Students'
        AND Numerator   IS NOT NULL
        AND Denominator IS NOT NULL
    GROUP BY
        Measure
),
StudentGroups AS
(
    -- Get each student group rate
    SELECT
        Measure,
        StudentGroup,
        ROUND(
            CAST(SUM(Numerator) AS FLOAT)
            / NULLIF(SUM(Denominator), 0) * 100
        , 2)                                AS Group_Pct
    FROM silver.school_performance
    WHERE
        StudentGroup != 'All Students'
        AND Numerator   IS NOT NULL
        AND Denominator IS NOT NULL
    GROUP BY
        Measure,
        StudentGroup
)
SELECT
    sg.Measure,
    sg.StudentGroup,
    a.AllStudents_Pct,
    sg.Group_Pct,
    ROUND(a.AllStudents_Pct - sg.Group_Pct, 2)     AS AchievementGap,
    CASE
        WHEN sg.Group_Pct >= a.AllStudents_Pct      THEN 'Above Average'
        WHEN sg.Group_Pct >= a.AllStudents_Pct - 5  THEN 'Near Average'
        WHEN sg.Group_Pct >= a.AllStudents_Pct - 10 THEN 'Below Average'
        ELSE                                             'Significantly Below'
    END                                             AS PerformanceCategory
FROM StudentGroups   sg
JOIN AllStudents     a  ON sg.Measure = a.Measure
ORDER BY
    sg.Measure,
    AchievementGap DESC;