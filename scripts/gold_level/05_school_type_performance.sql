-- ============================================================
-- Script      : Gold Layer Report 05
-- Report Name : School Type Performance Comparison
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Gold (Aggregated and Reporting Ready)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : gold
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Compares performance across school types
--               Traditional vs Charter vs Alternative vs Magnet.
--               Shows pass rate for each measure by school type.
--               Helps answer : Do Charter schools outperform
--               Traditional schools?
-- ============================================================

SELECT
    CurrentSchoolType,
    Measure,
    COUNT(DISTINCT SchoolName)                              AS TotalSchools,
    SUM(Numerator)                                          AS TotalNumerator,
    SUM(Denominator)                                        AS TotalDenominator,
    ROUND(
        CAST(SUM(Numerator) AS FLOAT)
        / NULLIF(SUM(Denominator), 0) * 100
    , 2)                                                    AS PassRate_Pct,
    RANK() OVER (
        PARTITION BY Measure
        ORDER BY
            CAST(SUM(Numerator) AS FLOAT)
            / NULLIF(SUM(Denominator), 0) DESC
    )                                                       AS RankWithinMeasure
FROM silver.school_performance
WHERE
    CurrentSchoolType != 'n/a'
    AND StudentGroup      = 'All Students'
    AND Numerator         IS NOT NULL
    AND Denominator       IS NOT NULL
GROUP BY
    CurrentSchoolType,
    Measure
ORDER BY
    Measure,
    PassRate_Pct DESC;