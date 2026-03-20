-- ============================================================
-- Script      : Gold Layer Report 03
-- Report Name : Advanced Course Participation
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Gold (Aggregated and Reporting Ready)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : gold
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Summarizes advanced course participation
--               counts by district and student group.
--               Covers AP, IB, College in High School,
--               Cambridge, Running Start, CTE Tech Prep.
--               Calculates total advanced course takers
--               and participation rate per district.
-- ============================================================

SELECT
    DistrictName,
    StudentGroup,
    SUM(NumberTakingAP)                     AS Total_AP,
    SUM(NumberTakingIB)                     AS Total_IB,
    SUM(NumberTakingCollegeInTheHighSchool)  AS Total_CollegeInHighSchool,
    SUM(NumberTakingCambridge)              AS Total_Cambridge,
    SUM(NumberTakingRunningStart)           AS Total_RunningStart,
    SUM(NumberTakingCTETechPrep)            AS Total_CTETechPrep,

    -- Total across all advanced programs
    (
        ISNULL(SUM(NumberTakingAP), 0)
        + ISNULL(SUM(NumberTakingIB), 0)
        + ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)
        + ISNULL(SUM(NumberTakingCambridge), 0)
        + ISNULL(SUM(NumberTakingRunningStart), 0)
        + ISNULL(SUM(NumberTakingCTETechPrep), 0)
    )                                       AS Total_AdvancedParticipants,

    -- Participation rate based on denominator
    ROUND(
        CAST(
            ISNULL(SUM(NumberTakingAP), 0)
            + ISNULL(SUM(NumberTakingIB), 0)
            + ISNULL(SUM(NumberTakingCollegeInTheHighSchool), 0)
            + ISNULL(SUM(NumberTakingCambridge), 0)
            + ISNULL(SUM(NumberTakingRunningStart), 0)
            + ISNULL(SUM(NumberTakingCTETechPrep), 0)
        AS FLOAT)
        / NULLIF(SUM(Denominator), 0) * 100
    , 2)                                    AS AdvancedParticipation_Pct

FROM silver.school_performance
WHERE
    Measure = 'AP/IB/CHS Participation'
    AND Denominator IS NOT NULL
GROUP BY
    DistrictName,
    StudentGroup
ORDER BY
    Total_AdvancedParticipants DESC;