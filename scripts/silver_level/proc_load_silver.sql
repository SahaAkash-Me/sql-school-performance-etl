-- ============================================================
-- DML Script  : Bronze to Silver Data Load
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Silver (Cleaned and Typed Data)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : silver
-- Table       : school_performance
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Cleans and loads data from Bronze to Silver.
--               All NVARCHAR columns are standardized,
--               typos fixed, nulls handled, numeric columns
--               converted to INT and DATE columns formatted.
-- ============================================================

-- ============================================================
-- NULL HANDLING RULES
-- Text columns  (NVARCHAR) : missing values = 'n/a'  (string)
-- Number columns (INT)     : missing values = NULL   (real null)
-- Date columns  (DATE)     : missing values = NULL   (real null)
-- Reason : INT and DATE columns cannot store 'n/a' string
-- ============================================================

-- ============================================================
-- STEP 1 : Truncate Silver Table Before Load
-- ============================================================

TRUNCATE TABLE silver.school_performance;
GO

-- ============================================================
-- STEP 2 : Insert Cleaned Data From Bronze to Silver
-- ============================================================

INSERT INTO silver.school_performance
(
    SchoolYear,
    County,
    DistrictName,
    SchoolName,
    CurrentSchoolType,
    StudentGroup,
    GradeLevel,
    Measure,
    Numerator,
    Denominator,
    NumberTakingAP,
    NumberTakingIB,
    NumberTakingCollegeInTheHighSchool,
    NumberTakingCambridge,
    NumberTakingRunningStart,
    NumberTakingCTETechPrep,
    DataAsOf
)
SELECT

    -- ------------------------------------------------------------
    -- SchoolYear                 (NVARCHAR) : missing = 'n/a'
    -- Fixes : wrong formats, string NULL, empty string
    -- ------------------------------------------------------------
    CASE
        WHEN TRIM(SchoolYear) = '2021-22'   THEN '2021-22'
        WHEN TRIM(SchoolYear) = '2021-2022' THEN '2021-22'
        WHEN TRIM(SchoolYear) = '2021/22'   THEN '2021-22'
        WHEN TRIM(SchoolYear) = '2022'      THEN '2021-22'
        WHEN TRIM(SchoolYear) = '21-22'     THEN '2021-22'
        WHEN TRIM(SchoolYear) = 'NULL'      THEN 'n/a'
        WHEN TRIM(SchoolYear) = ''          THEN 'n/a'
        WHEN SchoolYear IS NULL             THEN 'n/a'
        ELSE TRIM(SchoolYear)
    END,

    -- ------------------------------------------------------------
    -- County                     (NVARCHAR) : missing = 'n/a'
    -- Fixes : mixed case, trailing spaces, string NULL
    -- ------------------------------------------------------------
    CASE
        WHEN TRIM(UPPER(County)) = 'KING'       THEN 'King'
        WHEN TRIM(UPPER(County)) = 'PIERCE'     THEN 'Pierce'
        WHEN TRIM(UPPER(County)) = 'SNOHOMISH'  THEN 'Snohomish'
        WHEN TRIM(UPPER(County)) = 'SPOKANE'    THEN 'Spokane'
        WHEN TRIM(UPPER(County)) = 'CLARK'      THEN 'Clark'
        WHEN TRIM(UPPER(County)) = 'THURSTON'   THEN 'Thurston'
        WHEN TRIM(UPPER(County)) = 'YAKIMA'     THEN 'Yakima'
        WHEN TRIM(UPPER(County)) = 'WHATCOM'    THEN 'Whatcom'
        WHEN TRIM(UPPER(County)) = 'KITSAP'     THEN 'Kitsap'
        WHEN TRIM(UPPER(County)) = 'BENTON'     THEN 'Benton'
        WHEN TRIM(County) = 'NULL'              THEN 'n/a'
        WHEN TRIM(County) = ''                  THEN 'n/a'
        WHEN County IS NULL                     THEN 'n/a'
        ELSE TRIM(County)
    END,

    -- ------------------------------------------------------------
    -- DistrictName               (NVARCHAR) : missing = 'n/a'
    -- Fixes : mixed case, string NULL
    -- ------------------------------------------------------------
    CASE
        WHEN DistrictName IS NULL                                           THEN 'n/a'
        WHEN TRIM(DistrictName) = 'NULL'                                    THEN 'n/a'
        WHEN TRIM(DistrictName) = ''                                        THEN 'n/a'
        WHEN TRIM(UPPER(DistrictName)) = 'SEATTLE SCHOOL DISTRICT'         THEN 'Seattle School District'
        WHEN TRIM(UPPER(DistrictName)) = 'TACOMA SCHOOL DISTRICT'          THEN 'Tacoma School District'
        WHEN TRIM(UPPER(DistrictName)) = 'SPOKANE SCHOOL DISTRICT'         THEN 'Spokane School District'
        WHEN TRIM(UPPER(DistrictName)) = 'BELLEVUE SCHOOL DISTRICT'        THEN 'Bellevue School District'
        WHEN TRIM(UPPER(DistrictName)) = 'EVERETT SCHOOL DISTRICT'         THEN 'Everett School District'
        WHEN TRIM(UPPER(DistrictName)) = 'FEDERAL WAY SCHOOL DISTRICT'     THEN 'Federal Way School District'
        WHEN TRIM(UPPER(DistrictName)) = 'KENT SCHOOL DISTRICT'            THEN 'Kent School District'
        WHEN TRIM(UPPER(DistrictName)) = 'BETHEL SCHOOL DISTRICT'          THEN 'Bethel School District'
        WHEN TRIM(UPPER(DistrictName)) = 'NORTHSHORE SCHOOL DISTRICT'      THEN 'Northshore School District'
        WHEN TRIM(UPPER(DistrictName)) = 'LAKE WASHINGTON SCHOOL DISTRICT' THEN 'Lake Washington School District'
        WHEN TRIM(UPPER(DistrictName)) = 'PUYALLUP SCHOOL DISTRICT'        THEN 'Puyallup School District'
        WHEN TRIM(UPPER(DistrictName)) = 'EDMONDS SCHOOL DISTRICT'         THEN 'Edmonds School District'
        WHEN TRIM(UPPER(DistrictName)) = 'RENTON SCHOOL DISTRICT'          THEN 'Renton School District'
        WHEN TRIM(UPPER(DistrictName)) = 'HIGHLINE SCHOOL DISTRICT'        THEN 'Highline School District'
        WHEN TRIM(UPPER(DistrictName)) = 'CLOVER PARK SCHOOL DISTRICT'     THEN 'Clover Park School District'
        ELSE TRIM(DistrictName)
    END,

    -- ------------------------------------------------------------
    -- SchoolName                 (NVARCHAR) : missing = 'n/a'
    -- Fixes : mixed case, string NULL
    -- ------------------------------------------------------------
    CASE
        WHEN SchoolName IS NULL                                             THEN 'n/a'
        WHEN TRIM(SchoolName) = 'NULL'                                      THEN 'n/a'
        WHEN TRIM(SchoolName) = ''                                          THEN 'n/a'
        WHEN TRIM(UPPER(SchoolName)) = 'LINCOLN ELEMENTARY'                THEN 'Lincoln Elementary'
        WHEN TRIM(UPPER(SchoolName)) = 'FRANKLIN STEM SCHOOL'              THEN 'Franklin STEM School'
        WHEN TRIM(UPPER(SchoolName)) = 'ROOSEVELT HIGH SCHOOL'             THEN 'Roosevelt High School'
        WHEN TRIM(UPPER(SchoolName)) = 'WASHINGTON MIDDLE SCHOOL'          THEN 'Washington Middle School'
        WHEN TRIM(UPPER(SchoolName)) = 'JEFFERSON ACADEMY'                 THEN 'Jefferson Academy'
        WHEN TRIM(UPPER(SchoolName)) = 'ADAMS ELEMENTARY'                  THEN 'Adams Elementary'
        WHEN TRIM(UPPER(SchoolName)) = 'MONROE HIGH SCHOOL'                THEN 'Monroe High School'
        WHEN TRIM(UPPER(SchoolName)) = 'MADISON MIDDLE SCHOOL'             THEN 'Madison Middle School'
        WHEN TRIM(UPPER(SchoolName)) = 'JACKSON ALTERNATIVE'               THEN 'Jackson Alternative'
        WHEN TRIM(UPPER(SchoolName)) = 'GARFIELD HIGH SCHOOL'              THEN 'Garfield High School'
        ELSE TRIM(SchoolName)
    END,

    -- ------------------------------------------------------------
    -- CurrentSchoolType          (NVARCHAR) : missing = 'n/a'
    -- Fixes : mixed case, string NULL, N/A
    -- ------------------------------------------------------------
    CASE
        WHEN CurrentSchoolType IS NULL                        THEN 'n/a'
        WHEN TRIM(CurrentSchoolType) = 'NULL'                 THEN 'n/a'
        WHEN TRIM(CurrentSchoolType) = ''                     THEN 'n/a'
        WHEN TRIM(UPPER(CurrentSchoolType)) = 'TRADITIONAL'   THEN 'Traditional'
        WHEN TRIM(UPPER(CurrentSchoolType)) = 'CHARTER'       THEN 'Charter'
        WHEN TRIM(UPPER(CurrentSchoolType)) = 'ALTERNATIVE'   THEN 'Alternative'
        WHEN TRIM(UPPER(CurrentSchoolType)) = 'MAGNET'        THEN 'Magnet'
        WHEN TRIM(UPPER(CurrentSchoolType)) = 'N/A'           THEN 'n/a'
        ELSE TRIM(CurrentSchoolType)
    END,

    -- ------------------------------------------------------------
    -- StudentGroup               (NVARCHAR) : missing = 'n/a'
    -- Fixes : mixed case, alternate names, string NULL
    -- ------------------------------------------------------------
    CASE
        WHEN TRIM(UPPER(StudentGroup)) = 'ALL STUDENTS'                   THEN 'All Students'
        WHEN TRIM(UPPER(StudentGroup)) = 'AMERICAN INDIAN/ALASKA NATIVE'  THEN 'Native American'
        WHEN TRIM(UPPER(StudentGroup)) = 'NATIVE AMERICAN'                THEN 'Native American'
        WHEN TRIM(UPPER(StudentGroup)) = 'AIAN'                           THEN 'Native American'
        WHEN TRIM(UPPER(StudentGroup)) = 'ASIAN'                          THEN 'Asian'
        WHEN TRIM(UPPER(StudentGroup)) = 'ASIAN AMERICAN'                 THEN 'Asian'
        WHEN TRIM(UPPER(StudentGroup)) = 'BLACK/AFRICAN AMERICAN'         THEN 'African American'
        WHEN TRIM(UPPER(StudentGroup)) = 'AFRICAN AMERICAN'               THEN 'African American'
        WHEN TRIM(UPPER(StudentGroup)) = 'BLACK'                          THEN 'African American'
        WHEN TRIM(UPPER(StudentGroup)) = 'BLACK OR AFRICAN AMERICAN'      THEN 'African American'
        WHEN TRIM(UPPER(StudentGroup)) = 'ECONOMICALLY DISADVANTAGED'     THEN 'Economically Disadvantaged'
        WHEN TRIM(UPPER(StudentGroup)) = 'LOW INCOME'                     THEN 'Economically Disadvantaged'
        WHEN TRIM(UPPER(StudentGroup)) = 'FRPL'                           THEN 'Economically Disadvantaged'
        WHEN TRIM(UPPER(StudentGroup)) = 'ENGLISH LEARNER'                THEN 'English Learner'
        WHEN TRIM(UPPER(StudentGroup)) = 'ELL'                            THEN 'English Learner'
        WHEN TRIM(UPPER(StudentGroup)) = 'EL'                             THEN 'English Learner'
        WHEN TRIM(UPPER(StudentGroup)) = 'FEMALE'                         THEN 'Female'
        WHEN TRIM(UPPER(StudentGroup)) = 'GIRLS'                          THEN 'Female'
        WHEN TRIM(UPPER(StudentGroup)) = 'FORMER ENGLISH LEARNER'         THEN 'Former English Learner'
        WHEN TRIM(UPPER(StudentGroup)) = 'FORMER ELL'                     THEN 'Former English Learner'
        WHEN TRIM(UPPER(StudentGroup)) = 'HISPANIC/LATINO'                THEN 'Hispanic/Latino'
        WHEN TRIM(UPPER(StudentGroup)) = 'HISPANIC'                       THEN 'Hispanic/Latino'
        WHEN TRIM(UPPER(StudentGroup)) = 'LATINO'                         THEN 'Hispanic/Latino'
        WHEN TRIM(UPPER(StudentGroup)) = 'LATINX'                         THEN 'Hispanic/Latino'
        WHEN TRIM(UPPER(StudentGroup)) = 'HOMELESS'                       THEN 'Homeless'
        WHEN TRIM(UPPER(StudentGroup)) = 'MCKINNEY-VENTO'                 THEN 'Homeless'
        WHEN TRIM(UPPER(StudentGroup)) = 'MALE'                           THEN 'Male'
        WHEN TRIM(UPPER(StudentGroup)) = 'BOYS'                           THEN 'Male'
        WHEN TRIM(UPPER(StudentGroup)) = 'MIGRANT'                        THEN 'Migrant'
        WHEN TRIM(UPPER(StudentGroup)) = 'NON-BINARY'                     THEN 'Non-Binary'
        WHEN TRIM(UPPER(StudentGroup)) = 'NONBINARY'                      THEN 'Non-Binary'
        WHEN TRIM(UPPER(StudentGroup)) = 'NOT ECONOMICALLY DISADVANTAGED' THEN 'Not Economically Disadvantaged'
        WHEN TRIM(UPPER(StudentGroup)) = 'PACIFIC ISLANDER'               THEN 'Pacific Islander'
        WHEN TRIM(UPPER(StudentGroup)) = 'NATIVE HAWAIIAN'                THEN 'Pacific Islander'
        WHEN TRIM(UPPER(StudentGroup)) = 'NHPI'                           THEN 'Pacific Islander'
        WHEN TRIM(UPPER(StudentGroup)) = 'STUDENTS WITH IEP'              THEN 'Students with IEP'
        WHEN TRIM(UPPER(StudentGroup)) = 'SPECIAL EDUCATION'              THEN 'Students with IEP'
        WHEN TRIM(UPPER(StudentGroup)) = 'SWD'                            THEN 'Students with IEP'
        WHEN TRIM(UPPER(StudentGroup)) = 'TWO OR MORE RACES'              THEN 'Two or More Races'
        WHEN TRIM(UPPER(StudentGroup)) = 'MULTIRACIAL'                    THEN 'Two or More Races'
        WHEN TRIM(UPPER(StudentGroup)) = 'BIRACIAL'                       THEN 'Two or More Races'
        WHEN TRIM(UPPER(StudentGroup)) = 'WHITE'                          THEN 'White'
        WHEN TRIM(UPPER(StudentGroup)) = 'CAUCASIAN'                      THEN 'White'
        WHEN TRIM(StudentGroup) = 'NULL'                                  THEN 'n/a'
        WHEN TRIM(StudentGroup) = ''                                      THEN 'n/a'
        WHEN StudentGroup IS NULL                                         THEN 'n/a'
        ELSE TRIM(StudentGroup)
    END,

    -- ------------------------------------------------------------
    -- GradeLevel                 (NVARCHAR) : missing = 'n/a'
    -- Fixes : abbreviated, number only, lowercase, NULL
    -- ------------------------------------------------------------
    CASE
        WHEN GradeLevel IS NULL                                           THEN 'n/a'
        WHEN TRIM(GradeLevel) = 'NULL'                                    THEN 'n/a'
        WHEN TRIM(GradeLevel) = ''                                        THEN 'n/a'
        WHEN TRIM(UPPER(GradeLevel)) = 'ALL GRADES'                       THEN 'All Grades'
        WHEN TRIM(UPPER(GradeLevel)) = 'K-12'                             THEN 'K-12'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 3',  'GR. 3',  '3')      THEN 'Grade 3'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 4',  'GR. 4',  '4')      THEN 'Grade 4'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 5',  'GR. 5',  '5')      THEN 'Grade 5'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 6',  'GR. 6',  '6')      THEN 'Grade 6'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 7',  'GR. 7',  '7')      THEN 'Grade 7'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 8',  'GR. 8',  '8')      THEN 'Grade 8'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 9',  'GR. 9',  '9')      THEN 'Grade 9'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 10', 'GR. 10', '10')     THEN 'Grade 10'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 11', 'GR. 11', '11')     THEN 'Grade 11'
        WHEN TRIM(UPPER(GradeLevel)) IN ('GRADE 12', 'GR. 12', '12')     THEN 'Grade 12'
        ELSE TRIM(GradeLevel)
    END,

    -- ------------------------------------------------------------
    -- Measure                    (NVARCHAR) : missing = 'n/a'
    -- Fixes : mixed case, alternate names, string NULL
    -- ------------------------------------------------------------
    CASE
        WHEN Measure IS NULL                                              THEN 'n/a'
        WHEN TRIM(Measure) = 'NULL'                                       THEN 'n/a'
        WHEN TRIM(Measure) = ''                                           THEN 'n/a'
        WHEN TRIM(UPPER(Measure)) = 'GRADUATION RATE'                     THEN 'Graduation Rate'
        WHEN TRIM(UPPER(Measure)) = 'ATTENDANCE RATE'                     THEN 'Attendance Rate'
        WHEN TRIM(UPPER(Measure)) = 'ELA PROFICIENCY'                     THEN 'ELA Proficiency'
        WHEN TRIM(UPPER(Measure)) = 'MATH PROFICIENCY'                    THEN 'Math Proficiency'
        WHEN TRIM(UPPER(Measure)) = 'SCIENCE PROFICIENCY'                 THEN 'Science Proficiency'
        WHEN TRIM(UPPER(Measure)) = 'CHRONIC ABSENTEEISM'                 THEN 'Chronic Absenteeism'
        WHEN TRIM(UPPER(Measure)) = '9TH GRADE ON-TRACK'                  THEN '9th Grade On-Track'
        WHEN TRIM(UPPER(Measure)) = 'COLLEGE & CAREER READINESS'          THEN 'College & Career Readiness'
        WHEN TRIM(UPPER(Measure)) = 'AP/IB/CHS PARTICIPATION'             THEN 'AP/IB/CHS Participation'
        WHEN TRIM(UPPER(Measure)) = 'ADVANCED COURSE PARTICIPATION'       THEN 'AP/IB/CHS Participation'
        WHEN TRIM(UPPER(Measure)) = 'DUAL ENROLLMENT PARTICIPATION'       THEN 'AP/IB/CHS Participation'
        WHEN TRIM(UPPER(Measure)) = 'DISCIPLINE RATE'                     THEN 'Discipline Rate'
        ELSE TRIM(Measure)
    END,

    -- ------------------------------------------------------------
    -- Numerator                  (INT)      : missing = NULL
    -- Cannot use 'n/a' - INT column does not accept strings
    -- Fixes : string NULL, N/A, --, empty, float leak e.g. '2709.0'
    -- ------------------------------------------------------------
    CASE
        WHEN Numerator IS NULL                               THEN NULL
        WHEN TRIM(Numerator) IN ('NULL','N/A','n/a','--','') THEN NULL
        WHEN TRY_CAST(TRIM(Numerator) AS FLOAT) IS NOT NULL
            THEN CAST(TRY_CAST(TRIM(Numerator) AS FLOAT) AS INT)
        ELSE NULL
    END,

    -- ------------------------------------------------------------
    -- Denominator                (INT)      : missing = NULL
    -- Cannot use 'n/a' - INT column does not accept strings
    -- Fixes : string NULL, N/A, --, empty, zero, float leak
    -- ------------------------------------------------------------
    CASE
        WHEN Denominator IS NULL                                          THEN NULL
        WHEN TRIM(Denominator) IN ('NULL','N/A','n/a','--','','0','0.0') THEN NULL
        WHEN TRY_CAST(TRIM(Denominator) AS FLOAT) IS NOT NULL
            THEN CAST(TRY_CAST(TRIM(Denominator) AS FLOAT) AS INT)
        ELSE NULL
    END,

    -- ------------------------------------------------------------
    -- NumberTakingAP             (INT)      : missing = NULL
    -- Cannot use 'n/a' - INT column does not accept strings
    -- ------------------------------------------------------------
    CASE
        WHEN NumberTakingAP IS NULL                                       THEN NULL
        WHEN TRIM(NumberTakingAP) IN ('NULL','N/A','n/a','--','')        THEN NULL
        WHEN TRY_CAST(TRIM(NumberTakingAP) AS FLOAT) IS NOT NULL
            THEN CAST(TRY_CAST(TRIM(NumberTakingAP) AS FLOAT) AS INT)
        ELSE NULL
    END,

    -- ------------------------------------------------------------
    -- NumberTakingIB             (INT)      : missing = NULL
    -- Cannot use 'n/a' - INT column does not accept strings
    -- ------------------------------------------------------------
    CASE
        WHEN NumberTakingIB IS NULL                                       THEN NULL
        WHEN TRIM(NumberTakingIB) IN ('NULL','N/A','n/a','--','')        THEN NULL
        WHEN TRY_CAST(TRIM(NumberTakingIB) AS FLOAT) IS NOT NULL
            THEN CAST(TRY_CAST(TRIM(NumberTakingIB) AS FLOAT) AS INT)
        ELSE NULL
    END,

    -- ------------------------------------------------------------
    -- NumberTakingCollegeInTheHighSchool (INT) : missing = NULL
    -- Cannot use 'n/a' - INT column does not accept strings
    -- ------------------------------------------------------------
    CASE
        WHEN NumberTakingCollegeInTheHighSchool IS NULL                   THEN NULL
        WHEN TRIM(NumberTakingCollegeInTheHighSchool)
             IN ('NULL','N/A','n/a','--','')                              THEN NULL
        WHEN TRY_CAST(TRIM(NumberTakingCollegeInTheHighSchool) AS FLOAT) IS NOT NULL
            THEN CAST(TRY_CAST(TRIM(NumberTakingCollegeInTheHighSchool) AS FLOAT) AS INT)
        ELSE NULL
    END,

    -- ------------------------------------------------------------
    -- NumberTakingCambridge      (INT)      : missing = NULL
    -- Cannot use 'n/a' - INT column does not accept strings
    -- ------------------------------------------------------------
    CASE
        WHEN NumberTakingCambridge IS NULL                                THEN NULL
        WHEN TRIM(NumberTakingCambridge) IN ('NULL','N/A','n/a','--','') THEN NULL
        WHEN TRY_CAST(TRIM(NumberTakingCambridge) AS FLOAT) IS NOT NULL
            THEN CAST(TRY_CAST(TRIM(NumberTakingCambridge) AS FLOAT) AS INT)
        ELSE NULL
    END,

    -- ------------------------------------------------------------
    -- NumberTakingRunningStart   (INT)      : missing = NULL
    -- Cannot use 'n/a' - INT column does not accept strings
    -- ------------------------------------------------------------
    CASE
        WHEN NumberTakingRunningStart IS NULL                                THEN NULL
        WHEN TRIM(NumberTakingRunningStart) IN ('NULL','N/A','n/a','--','') THEN NULL
        WHEN TRY_CAST(TRIM(NumberTakingRunningStart) AS FLOAT) IS NOT NULL
            THEN CAST(TRY_CAST(TRIM(NumberTakingRunningStart) AS FLOAT) AS INT)
        ELSE NULL
    END,

    -- ------------------------------------------------------------
    -- NumberTakingCTETechPrep    (INT)      : missing = NULL
    -- Cannot use 'n/a' - INT column does not accept strings
    -- ------------------------------------------------------------
    CASE
        WHEN NumberTakingCTETechPrep IS NULL                                THEN NULL
        WHEN TRIM(NumberTakingCTETechPrep) IN ('NULL','N/A','n/a','--','') THEN NULL
        WHEN TRY_CAST(TRIM(NumberTakingCTETechPrep) AS FLOAT) IS NOT NULL
            THEN CAST(TRY_CAST(TRIM(NumberTakingCTETechPrep) AS FLOAT) AS INT)
        ELSE NULL
    END,

    -- ------------------------------------------------------------
    -- DataAsOf                   (DATE)     : missing = NULL
    -- Cannot use 'n/a' - DATE column does not accept strings
    -- Fixes : multiple date formats standardized to YYYY-MM-DD
    -- ------------------------------------------------------------
    CASE
        WHEN DataAsOf IS NULL                THEN NULL
        WHEN TRIM(DataAsOf) = 'NULL'         THEN NULL
        WHEN TRIM(DataAsOf) = ''             THEN NULL
        WHEN TRIM(DataAsOf) = 'Oct 2022'     THEN CAST('2022-10-01' AS DATE)
        WHEN TRIM(DataAsOf) = '10/01/2022'   THEN CAST('2022-10-01' AS DATE)
        WHEN TRIM(DataAsOf) = '10-01-2022'   THEN CAST('2022-10-01' AS DATE)
        WHEN TRIM(DataAsOf) = '2022/10/01'   THEN CAST('2022-10-01' AS DATE)
        WHEN TRIM(DataAsOf) = '2022-10-1'    THEN CAST('2022-10-01' AS DATE)
        WHEN TRIM(DataAsOf) = '2022-09-30'   THEN CAST('2022-09-30' AS DATE)
        WHEN TRIM(DataAsOf) = '2022-10-01'   THEN CAST('2022-10-01' AS DATE)
        ELSE NULL
    END

FROM reportcard_sqss_2021_2022.bronze.school_performance;
GO

-- ============================================================
-- STEP 3 : Verify Row Count Matches Bronze and Silver
-- ============================================================
SELECT 'Bronze' AS Layer, COUNT(*) AS TotalRows FROM bronze.school_performance
UNION ALL
SELECT 'Silver' AS Layer, COUNT(*) AS TotalRows FROM silver.school_performance;