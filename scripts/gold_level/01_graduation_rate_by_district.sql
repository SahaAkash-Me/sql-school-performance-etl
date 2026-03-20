-- ============================================================
-- Script      : Gold Layer Report 01
-- Report Name : Graduation Rate by District
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Gold (Aggregated and Reporting Ready)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : gold
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Calculates graduation rate per district.
--               Ranks districts from highest to lowest rate.
--               Filters only Graduation Rate measure rows.
-- ============================================================

SELECT
    DistrictName,
    SchoolYear,
    SUM(Numerator) AS TotalGraduates,
    SUM(Denominator) AS TotalStudents,
    ROUND(CAST(SUM(Numerator) AS FLOAT) / NULLIF(SUM(Denominator), 0) * 100, 2)	AS GraduationRate_Pct,
    RANK() OVER(ORDER BY CAST(SUM(Numerator) AS FLOAT)/ NULLIF(SUM(Denominator), 0) DESC)	AS DistrictRank
FROM silver.school_performance
WHERE
    Measure      = 'Graduation Rate'
    AND StudentGroup = 'All Students'
    AND Numerator    IS NOT NULL
    AND Denominator  IS NOT NULL
GROUP BY
    DistrictName,
    SchoolYear
ORDER BY
    GraduationRate_Pct DESC;