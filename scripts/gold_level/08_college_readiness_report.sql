-- ============================================================
-- Script      : Gold Layer Report 08
-- Report Name : College Readiness Report
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Gold (Aggregated and Reporting Ready)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : gold
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Measures college readiness by district.
--               Combines AP, IB, Cambridge, College in High
--               School and Running Start participation.
--               Calculates an overall College Readiness Score
--               and ranks districts from most to least ready.
-- ============================================================

SELECT
    DistrictName,
    County,

    -- Individual program counts
    ISNULL(SUM(NumberTakingAP), 0)                          AS Total_AP,
    ISNULL(SUM(NumberTakingIB), 0)                          AS Total_IB,
    ISNULL(SUM(NumberTakingCambridge), 0)                   AS Total_Cambridge,
    ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)       AS Total_CollegeInHighSchool,
    ISNULL(SUM(NumberTakingRunningStart), 0)                AS Total_RunningStart,
    ISNULL(SUM(NumberTakingCTETechPrep), 0)                 AS Total_CTETechPrep,

    -- Total college ready students across all programs
    (
        ISNULL(SUM(NumberTakingAP), 0)
        + ISNULL(SUM(NumberTakingIB), 0)
        + ISNULL(SUM(NumberTakingCambridge), 0)
        + ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)
        + ISNULL(SUM(NumberTakingRunningStart), 0)
        + ISNULL(SUM(NumberTakingCTETechPrep), 0)
    )                                                       AS Total_CollegeReadyStudents,

    -- Total student population
    SUM(Denominator)                                        AS TotalStudents,

    -- College Readiness Score = Total in any program / Total students
    ROUND(
        CAST(
            ISNULL(SUM(NumberTakingAP), 0)
            + ISNULL(SUM(NumberTakingIB), 0)
            + ISNULL(SUM(NumberTakingCambridge), 0)
            + ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)
            + ISNULL(SUM(NumberTakingRunningStart), 0)
            + ISNULL(SUM(NumberTakingCTETechPrep), 0)
        AS FLOAT)
        / NULLIF(SUM(Denominator), 0) * 100
    , 2)                                                    AS CollegeReadiness_Score,

    -- Readiness category
    CASE
        WHEN ROUND(
                CAST(
                    ISNULL(SUM(NumberTakingAP), 0)
                    + ISNULL(SUM(NumberTakingIB), 0)
                    + ISNULL(SUM(NumberTakingCambridge), 0)
                    + ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)
                    + ISNULL(SUM(NumberTakingRunningStart), 0)
                    + ISNULL(SUM(NumberTakingCTETechPrep), 0)
                AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 50                                     THEN 'Highly Ready'
        WHEN ROUND(
                CAST(
                    ISNULL(SUM(NumberTakingAP), 0)
                    + ISNULL(SUM(NumberTakingIB), 0)
                    + ISNULL(SUM(NumberTakingCambridge), 0)
                    + ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)
                    + ISNULL(SUM(NumberTakingRunningStart), 0)
                    + ISNULL(SUM(NumberTakingCTETechPrep), 0)
                AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 30                                     THEN 'Moderately Ready'
        WHEN ROUND(
                CAST(
                    ISNULL(SUM(NumberTakingAP), 0)
                    + ISNULL(SUM(NumberTakingIB), 0)
                    + ISNULL(SUM(NumberTakingCambridge), 0)
                    + ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)
                    + ISNULL(SUM(NumberTakingRunningStart), 0)
                    + ISNULL(SUM(NumberTakingCTETechPrep), 0)
                AS FLOAT)
                / NULLIF(SUM(Denominator), 0) * 100
             , 2) >= 10                                     THEN 'Developing'
        ELSE                                                     'Needs Improvement'
    END                                                     AS ReadinessCategory,

    -- District rank by college readiness score
    RANK() OVER (
        ORDER BY
            CAST(
                ISNULL(SUM(NumberTakingAP), 0)
                + ISNULL(SUM(NumberTakingIB), 0)
                + ISNULL(SUM(NumberTakingCambridge), 0)
                + ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)
                + ISNULL(SUM(NumberTakingRunningStart), 0)
                + ISNULL(SUM(NumberTakingCTETechPrep), 0)
            AS FLOAT)
            / NULLIF(SUM(Denominator), 0) DESC
    )                                                       AS DistrictRank

FROM silver.school_performance
WHERE
    Denominator  IS NOT NULL
    AND County   != 'n/a'
    AND DistrictName != 'n/a'
GROUP BY
    DistrictName,
    County
ORDER BY
    CollegeReadiness_Score DESC;