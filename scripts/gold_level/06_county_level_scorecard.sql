-- ============================================================
-- Script      : Gold Layer Report 06
-- Report Name : County Level Scorecard
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Gold (Aggregated and Reporting Ready)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : gold
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Overall performance scorecard per county.
--               Shows pass rate for every measure per county.
--               Pivots data so each measure is its own column.
--               Ranks counties overall by average pass rate.
-- ============================================================

WITH CountyMeasure AS
(
    SELECT
        County,
        Measure,
        ROUND(
            CAST(SUM(Numerator) AS FLOAT)
            / NULLIF(SUM(Denominator), 0) * 100
        , 2)                            AS PassRate_Pct
    FROM silver.school_performance
    WHERE
        StudentGroup = 'All Students'
        AND County   != 'n/a'
        AND Numerator   IS NOT NULL
        AND Denominator IS NOT NULL
    GROUP BY
        County,
        Measure
)
SELECT
    County,

    -- One column per measure
    MAX(CASE WHEN Measure = 'Graduation Rate'          THEN PassRate_Pct END) AS GraduationRate,
    MAX(CASE WHEN Measure = 'Attendance Rate'          THEN PassRate_Pct END) AS AttendanceRate,
    MAX(CASE WHEN Measure = 'ELA Proficiency'          THEN PassRate_Pct END) AS ELA_Proficiency,
    MAX(CASE WHEN Measure = 'Math Proficiency'         THEN PassRate_Pct END) AS Math_Proficiency,
    MAX(CASE WHEN Measure = 'Science Proficiency'      THEN PassRate_Pct END) AS Science_Proficiency,
    MAX(CASE WHEN Measure = 'Chronic Absenteeism'      THEN PassRate_Pct END) AS Chronic_Absenteeism,
    MAX(CASE WHEN Measure = '9th Grade On-Track'       THEN PassRate_Pct END) AS OnTrack_9thGrade,
    MAX(CASE WHEN Measure = 'College & Career Readiness' THEN PassRate_Pct END) AS CollegeCareerReadiness,
    MAX(CASE WHEN Measure = 'Discipline Rate'          THEN PassRate_Pct END) AS DisciplineRate,

    -- Overall average across all measures
    ROUND(AVG(PassRate_Pct), 2)                                               AS OverallAvg_Pct,

    -- County rank based on overall average
    RANK() OVER (
        ORDER BY AVG(PassRate_Pct) DESC
    )                                                                         AS CountyRank

FROM CountyMeasure
GROUP BY
    County
ORDER BY
    OverallAvg_Pct DESC;