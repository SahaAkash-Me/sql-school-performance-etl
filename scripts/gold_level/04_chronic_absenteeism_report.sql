-- ============================================================
-- Script      : Gold Layer Report 04
-- Report Name : Chronic Absenteeism Report
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Gold (Aggregated and Reporting Ready)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : gold
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Identifies chronic absenteeism rates
--               by county and district.
--               Ranks counties from worst to best.
--               Flags districts above 20% as High Risk.
-- ============================================================

SELECT
    County,
    DistrictName,
    SUM(Numerator)                                          AS TotalAbsent,
    SUM(Denominator)                                        AS TotalStudents,
    ROUND(
        CAST(SUM(Numerator) AS FLOAT)
        / NULLIF(SUM(Denominator), 0) * 100
    , 2)                                                    AS AbsenteeismRate_Pct,

    -- Risk flag based on absenteeism threshold
    CASE
        WHEN ROUND(
                CAST(SUM(Numerator) AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 30                                     THEN 'Critical'
        WHEN ROUND(
                CAST(SUM(Numerator) AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 20                                     THEN 'High Risk'
        WHEN ROUND(
                CAST(SUM(Numerator) AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 10                                     THEN 'Moderate'
        ELSE                                                     'Low Risk'
    END                                                     AS RiskCategory,

    RANK() OVER (
        ORDER BY
            CAST(SUM(Numerator) AS FLOAT)
            / NULLIF(SUM(Denominator), 0) DESC
    )                                                       AS AbsenteeismRank

FROM silver.school_performance
WHERE
    Measure      = 'Chronic Absenteeism'
    AND StudentGroup = 'All Students'
    AND Numerator    IS NOT NULL
    AND Denominator  IS NOT NULL
GROUP BY
    County,
    DistrictName
ORDER BY
    AbsenteeismRate_Pct DESC;