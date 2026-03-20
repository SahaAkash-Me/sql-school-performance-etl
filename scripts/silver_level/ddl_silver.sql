IF OBJECT_ID('silver.school_performance', 'U') IS NOT NULL
    DROP TABLE silver.school_performance;
GO

CREATE TABLE silver.school_performance (

    -- ------------------------------------------------------------
    -- SECTION 1 : Identifiers
    -- ------------------------------------------------------------
    SchoolYear                          NVARCHAR(20),       -- e.g. '2021-22'
    County                              NVARCHAR(100),      -- e.g. 'King', 'Pierce'
    DistrictName                        NVARCHAR(200),      -- e.g. 'Seattle School District'
    SchoolName                          NVARCHAR(200),      -- NULL for non-school rows
    CurrentSchoolType                   NVARCHAR(50),       -- e.g. 'Traditional', 'Charter'

    -- ------------------------------------------------------------
    -- SECTION 2 : Student Demographics
    -- ------------------------------------------------------------
    StudentGroup                        NVARCHAR(200),      -- e.g. 'Hispanic/Latino', 'White'
    GradeLevel                          NVARCHAR(50),       -- e.g. 'Grade 9', 'All Grades'

    -- ------------------------------------------------------------
    -- SECTION 3 : Performance Measure
    -- ------------------------------------------------------------
    Measure                             NVARCHAR(200),      -- e.g. 'Graduation Rate'
    Numerator                           INT,                -- Count meeting criteria
    Denominator                         INT,                -- Total eligible students

    -- ------------------------------------------------------------
    -- SECTION 4 : Advanced Course Participation (Count only)
    -- Percent can be calculated : Number / Denominator * 100
    -- ------------------------------------------------------------
    NumberTakingAP                      INT,
    NumberTakingIB                      INT,
    NumberTakingCollegeInTheHighSchool  INT,
    NumberTakingCambridge               INT,
    NumberTakingRunningStart            INT,
    NumberTakingCTETechPrep             INT,

    -- ------------------------------------------------------------
    -- SECTION 5 : Audit
    -- ------------------------------------------------------------
    DataAsOf                            DATE
);
GO

-- ============================================================
-- DML Script  : Bronze : Silver Data Load
-- Project     : Report Card SQSS 2021-2022
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Cleans and loads data from Bronze to Silver
-- ============================================================

