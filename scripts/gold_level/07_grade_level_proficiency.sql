-- ============================================================
-- Script      : Gold Layer Report 07
-- Report Name : Grade Level Proficiency
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Gold (Aggregated and Reporting Ready)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : gold
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Shows ELA, Math and Science proficiency
--               rates broken down by grade level.
--               Helps identify which grades struggle most.
--               Sorted by grade and measure for easy reading.
-- ============================================================

SELECT
    GradeLevel,
    Measure,
    SUM(Numerator)                                          AS TotalProficient,
    SUM(Denominator)                                        AS TotalStudents,
    ROUND(
        CAST(SUM(Numerator) AS FLOAT)
        / NULLIF(SUM(Denominator), 0) * 100
    , 2)                                                    AS ProficiencyRate_Pct,

    -- Performance label
    CASE
        WHEN ROUND(
                CAST(SUM(Numerator) AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 80                                     THEN 'Strong'
        WHEN ROUND(
                CAST(SUM(Numerator) AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 60                                     THEN 'Proficient'
        WHEN ROUND(
                CAST(SUM(Numerator) AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 40                                     THEN 'Developing'
        ELSE                                                     'Needs Support'
    END                                                     AS PerformanceLabel,

    -- Rank within each measure
    RANK() OVER (
        PARTITION BY Measure
        ORDER BY
            CAST(SUM(Numerator) AS FLOAT)
            / NULLIF(SUM(Denominator), 0) DESC
    )                                                       AS RankWithinMeasure

FROM silver.school_performance
WHERE
    Measure IN (
        'ELA Proficiency',
        'Math Proficiency',
        'Science Proficiency'
    )
    AND GradeLevel   != 'n/a'
    AND GradeLevel   != 'All Grades'
    AND StudentGroup  = 'All Students'
    AND Numerator     IS NOT NULL
    AND Denominator   IS NOT NULL
GROUP BY
    GradeLevel,
    Measure
ORDER BY
    Measure,
    GradeLevel;