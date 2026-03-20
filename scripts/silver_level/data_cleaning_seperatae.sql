-- ============================================================
-- Script      : Bronze Layer Data Cleaning Query
-- Project     : Report Card SQSS 2021-2022
-- Layer       : Bronze (Raw Data Exploration and Cleaning)
-- Database    : reportcard_sqss_2021_2022
-- Schema      : bronze
-- Table       : school_performance
-- Author      : [Your Name]
-- Created     : 2026-03-20
-- Description : Cleans all columns from the Bronze table.
--               This SELECT is used to verify cleaning logic
--               before inserting into the Silver table.
--               No data is modified in Bronze - read only.
-- ============================================================

-- ============================================================
-- CLEANING RULES APPLIED
-- 1. TRIM()           - removes leading and trailing spaces
-- 2. UPPER()          - handles mixed case values
-- 3. String NULL      - 'NULL' string converted to 'n/a'
-- 4. Empty string     - '' converted to 'n/a'
-- 5. Real NULL        - IS NULL check converted to 'n/a'
-- 6. Float leak       - '3542.0' converted to '3542'
-- 7. Percent sign     - '26.5%' stripped to '26.5'
-- 8. Date formats     - multiple formats to 'YYYY-MM-DD'
-- 9. Typos            - 'Schoool' corrected to 'School'
-- ============================================================

SELECT

	-- ------------------------------------------------------------
	-- SchoolYear
	-- Fixes : wrong year formats, string NULL, empty string
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
	END AS SchoolYear,

	-- ------------------------------------------------------------
	-- OrganizationLevel
	-- Fixes : mixed case, typo 'Schoool', string NULL
	-- ------------------------------------------------------------
	CASE
		WHEN UPPER(TRIM(OrganizationLevel)) = 'STATE'    THEN 'State'
		WHEN UPPER(TRIM(OrganizationLevel)) = 'SCHOOL'   THEN 'School'
		WHEN UPPER(TRIM(OrganizationLevel)) = 'SCHOOOL'  THEN 'School'
		WHEN UPPER(TRIM(OrganizationLevel)) = 'ESD'      THEN 'ESD'
		WHEN UPPER(TRIM(OrganizationLevel)) = 'DISTRICT' THEN 'District'
		WHEN TRIM(OrganizationLevel) = 'NULL'            THEN 'n/a'
		WHEN TRIM(OrganizationLevel) = ''                THEN 'n/a'
		WHEN OrganizationLevel IS NULL                   THEN 'n/a'
		ELSE TRIM(OrganizationLevel)
	END AS OrganizationLevel_Cleaned,

	-- ------------------------------------------------------------
	-- County
	-- Fixes : mixed case e.g. 'king', 'PIERCE', string NULL
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
	END AS County_Cleaned,

	-- ------------------------------------------------------------
	-- ESDName
	-- Fixes : mixed case e.g. 'puget sound esd', string NULL
	-- ------------------------------------------------------------
	CASE
		WHEN TRIM(UPPER(ESDName)) = 'PUGET SOUND ESD'                 THEN 'Puget Sound ESD'
		WHEN TRIM(UPPER(ESDName)) = 'EDUCATIONAL SERVICE DISTRICT 101' THEN 'Educational Service District 101'
		WHEN TRIM(UPPER(ESDName)) = 'NORTHWEST ESD'                   THEN 'Northwest ESD'
		WHEN TRIM(UPPER(ESDName)) = 'OLYMPIC ESD'                     THEN 'Olympic ESD'
		WHEN TRIM(UPPER(ESDName)) = 'CAPITAL REGION ESD'              THEN 'Capital Region ESD'
		WHEN TRIM(UPPER(ESDName)) = 'YAKIMA VALLEY ESD'               THEN 'Yakima Valley ESD'
		WHEN TRIM(UPPER(ESDName)) = 'COLUMBIA BASIN ESD'              THEN 'Columbia Basin ESD'
		WHEN TRIM(ESDName) = 'NULL'                                    THEN 'n/a'
		WHEN TRIM(ESDName) = ''                                        THEN 'n/a'
		WHEN ESDName IS NULL                                           THEN 'n/a'
		ELSE TRIM(ESDName)
	END AS ESDName,

	-- ------------------------------------------------------------
	-- ESDOrganizationID
	-- Fixes : string NULL, N/A, empty string
	-- ------------------------------------------------------------
	CASE 
		WHEN ESDOrganizationID IS NULL              THEN 'n/a'
		WHEN TRIM(UPPER(ESDOrganizationID)) = 'N/A' THEN 'n/a'
		WHEN TRIM(ESDOrganizationID) = 'NULL'       THEN 'n/a'
		WHEN TRIM(ESDOrganizationID) = ''           THEN 'n/a'
		ELSE TRIM(ESDOrganizationID)
	END AS ESDOrganizationID,

	-- ------------------------------------------------------------
	-- DistrictCode
	-- Fixes : string NULL, empty string
	-- ------------------------------------------------------------
	CASE
		WHEN DistrictCode IS NULL        THEN 'n/a'
		WHEN TRIM(DistrictCode) = 'NULL' THEN 'n/a'
		WHEN TRIM(DistrictCode) = ''     THEN 'n/a'
		ELSE TRIM(DistrictCode)
	END AS DistrictCode,

	-- ------------------------------------------------------------
	-- DistrictName
	-- Fixes : mixed case e.g. 'seattle school district', string NULL
	-- ------------------------------------------------------------
	CASE
		WHEN TRIM(UPPER(DistrictName)) IS NULL                             THEN 'n/a'
		WHEN TRIM(UPPER(DistrictName)) = 'SEATTLE SCHOOL DISTRICT'        THEN 'Seattle School District'
		ELSE TRIM(DistrictName)
	END AS DistrictName,

	-- ------------------------------------------------------------
	-- DistrictOrganizationId
	-- Fixes : string NULL, empty string
	-- ------------------------------------------------------------
	CASE
		WHEN TRIM(DistrictOrganizationId) IS NULL THEN 'n/a'
		ELSE TRIM(DistrictOrganizationId)
	END AS DistrictOrganizationId,

	-- ------------------------------------------------------------
	-- SchoolCode
	-- Fixes : string NULL, empty string
	-- ------------------------------------------------------------
	CASE
		WHEN SchoolCode IS NULL        THEN 'n/a'
		WHEN TRIM(SchoolCode) = 'NULL' THEN 'n/a'
		WHEN TRIM(SchoolCode) = ''     THEN 'n/a'
		ELSE TRIM(SchoolCode)
	END AS SchoolCode_Cleaned,

	-- ------------------------------------------------------------
	-- SchoolName
	-- Fixes : mixed case, string NULL
	-- ------------------------------------------------------------
	CASE
		WHEN SchoolName IS NULL                                        THEN 'n/a'
		WHEN TRIM(UPPER(SchoolName)) = 'LINCOLN ELEMENTARY'           THEN 'Lincoln Elementary'
		WHEN TRIM(UPPER(SchoolName)) = 'FRANKLIN STEM SCHOOL'         THEN 'Franklin Stem School'
		WHEN TRIM(UPPER(SchoolName)) IS NULL                          THEN 'n/a'
		WHEN TRIM(UPPER(SchoolName)) = 'ROOSEVELT HIGH SCHOOL'        THEN 'Roosevelt High School'
		ELSE TRIM(SchoolName)
	END AS SchoolName,

	-- ------------------------------------------------------------
	-- SchoolOrganizationId
	-- Fixes : string NULL, empty string
	-- ------------------------------------------------------------
	CASE
		WHEN TRIM(SchoolOrganizationId) IS NULL THEN 'n/a'
		WHEN SchoolOrganizationId = ''          THEN 'n/a'
		ELSE SchoolOrganizationId
	END AS SchoolOrganizationId,

	-- ------------------------------------------------------------
	-- CurrentSchoolType
	-- Fixes : mixed case, N/A string, real NULL
	-- ------------------------------------------------------------
	CASE
		WHEN CurrentSchoolType IS NULL                        THEN 'n/a'
		WHEN TRIM(UPPER(CurrentSchoolType)) = 'MAGNET'        THEN 'Magnet'
		WHEN TRIM(UPPER(CurrentSchoolType)) = 'N/A'           THEN 'n/a'
		WHEN TRIM(UPPER(CurrentSchoolType)) = 'TRADITIONAL'   THEN 'Traditional'
		WHEN TRIM(UPPER(CurrentSchoolType)) = 'ALTERNATIVE'   THEN 'Alternative'
		WHEN TRIM(UPPER(CurrentSchoolType)) = 'CHARTER'       THEN 'Charter'
		ELSE TRIM(CurrentSchoolType)
	END AS CurrentSchoolType2,

	-- ------------------------------------------------------------
	-- StudentGroupType
	-- Fixes : alternate names, string NULL
	-- ------------------------------------------------------------
	CASE 
		WHEN TRIM(UPPER(StudentGroupType)) = 'RACE / ETHNICITY'
		  OR TRIM(UPPER(StudentGroupType)) = 'RACE/ETHNICITY'          THEN 'Ethnicity'
		WHEN TRIM(UPPER(StudentGroupType)) IS NULL                     THEN 'n/a'
		WHEN TRIM(UPPER(StudentGroupType)) = 'STUDENTS WITH DISABILITIES' THEN 'Specially_Eabled'
		ELSE TRIM(StudentGroupType)
	END AS StudentGroupType,

	-- ------------------------------------------------------------
	-- StudentGroup
	-- Fixes : mixed case e.g. 'hispanic/latino', 'WHITE'
	--         string NULL, empty string
	-- ------------------------------------------------------------
	CASE
		WHEN TRIM(UPPER(StudentGroup)) = 'ALL STUDENTS'                   THEN 'All Students'
		WHEN TRIM(UPPER(StudentGroup)) = 'AMERICAN INDIAN/ALASKA NATIVE'  THEN 'Native American'
		WHEN TRIM(UPPER(StudentGroup)) = 'ASIAN'                          THEN 'Asian'
		WHEN TRIM(UPPER(StudentGroup)) = 'BLACK/AFRICAN AMERICAN'         THEN 'African American'
		WHEN TRIM(UPPER(StudentGroup)) = 'ECONOMICALLY DISADVANTAGED'     THEN 'Economically Disadvantaged'
		WHEN TRIM(UPPER(StudentGroup)) = 'ENGLISH LEARNER'                THEN 'English Learner'
		WHEN TRIM(UPPER(StudentGroup)) = 'FEMALE'                         THEN 'Female'
		WHEN TRIM(UPPER(StudentGroup)) = 'FORMER ENGLISH LEARNER'         THEN 'Former English Learner'
		WHEN TRIM(UPPER(StudentGroup)) = 'HISPANIC/LATINO'                THEN 'Hispanic/Latino'
		WHEN TRIM(UPPER(StudentGroup)) = 'HOMELESS'                       THEN 'Homeless'
		WHEN TRIM(UPPER(StudentGroup)) = 'MALE'                           THEN 'Male'
		WHEN TRIM(UPPER(StudentGroup)) = 'MIGRANT'                        THEN 'Migrant'
		WHEN TRIM(UPPER(StudentGroup)) = 'NON-BINARY'                     THEN 'Non-Binary'
		WHEN TRIM(UPPER(StudentGroup)) = 'NOT ECONOMICALLY DISADVANTAGED' THEN 'Not Economically Disadvantaged'
		WHEN TRIM(UPPER(StudentGroup)) = 'PACIFIC ISLANDER'               THEN 'Pacific Islander'
		WHEN TRIM(UPPER(StudentGroup)) = 'STUDENTS WITH IEP'              THEN 'Students with IEP'
		WHEN TRIM(UPPER(StudentGroup)) = 'TWO OR MORE RACES'              THEN 'Two or More Races'
		WHEN TRIM(UPPER(StudentGroup)) = 'WHITE'                          THEN 'White'
		WHEN TRIM(StudentGroup) = 'NULL'                                  THEN 'n/a'
		WHEN TRIM(StudentGroup) = ''                                      THEN 'n/a'
		WHEN StudentGroup IS NULL                                         THEN 'n/a'
		ELSE TRIM(StudentGroup)
	END AS StudentGroup_Cleaned,

	-- ------------------------------------------------------------
	-- GradeLevel
	-- Fixes : number only '3', abbreviated 'Gr. 9', real NULL
	-- ------------------------------------------------------------
	CASE
		WHEN GradeLevel IS NULL                                                        THEN 'n/a'
		WHEN TRIM(UPPER(GradeLevel)) = '3'      OR TRIM(UPPER(GradeLevel)) = 'GRADE 3' THEN 'Grade 3'
		WHEN TRIM(UPPER(GradeLevel)) = 'GR. 9'  OR TRIM(UPPER(GradeLevel)) = 'GRADE 9' THEN 'Grade 9'
		ELSE TRIM(GradeLevel)
	END AS GradeLevel,

	-- ------------------------------------------------------------
	-- Measure
	-- Fixes : mixed case comparisons, string NULL
	-- Note  : UPPER() comparison must use ALL CAPS target strings
	-- ------------------------------------------------------------
	CASE
		WHEN TRIM(UPPER(Measure)) = 'COLLEGE & CAREER READINESS' THEN 'College & Career Readiness'
		WHEN TRIM(UPPER(Measure)) = 'GRADUATION RATE'            THEN 'Graduation Rate'
		WHEN TRIM(UPPER(Measure)) = 'DISCIPLINE RATE'            THEN 'Discipline Rate'
		WHEN TRIM(UPPER(Measure)) IS NULL                        THEN 'n/a'
		WHEN TRIM(UPPER(Measure)) = 'CHRONIC ABSENTEEISM'        THEN 'Chronic Absenteeism'
		WHEN TRIM(UPPER(Measure)) = 'AP/IB/CHS PARTICIPATION'    THEN 'AP/IB/CHS Participation'
		WHEN TRIM(UPPER(Measure)) = 'SCIENCE PROFICIENCY'        THEN 'Science Proficiency'
		WHEN TRIM(UPPER(Measure)) = '9TH GRADE ON-TRACK'         THEN '9th Grade On-Track'
		WHEN TRIM(UPPER(Measure)) = 'ATTENDANCE RATE'            THEN 'Attendance Rate'
		WHEN TRIM(UPPER(Measure)) = 'ELA PROFICIENCY'            THEN 'ELA Proficiency'
		WHEN TRIM(UPPER(Measure)) = 'MATH PROFICIENCY'           THEN 'Math Proficiency'
		ELSE TRIM(Measure)
	END AS Measure,

	-- ------------------------------------------------------------
	-- SuppressionReason
	-- Fixes : mixed case, alternate names, real NULL
	-- ------------------------------------------------------------
	CASE
		WHEN TRIM(UPPER(SuppressionReason)) = 'PRIVACY SUPPRESSED'    THEN 'Privacy Suppressed'
		WHEN TRIM(UPPER(SuppressionReason)) = 'SMALL SAMPLE SIZE'     THEN 'Small Sample Size'
		WHEN TRIM(UPPER(SuppressionReason)) = 'N/A'
		  OR TRIM(UPPER(SuppressionReason)) = 'DATA NOT AVAILABLE'
		  OR TRIM(UPPER(SuppressionReason)) IS NULL
		  OR TRIM(UPPER(SuppressionReason)) = 'NOT APPLICABLE'        THEN 'n/a'
		WHEN TRIM(UPPER(SuppressionReason)) = 'SUPPRESSED FOR PRIVACY' THEN 'Suppressed For Privacy'
		ELSE TRIM(SuppressionReason)
	END AS SuppressionReason,

	-- ------------------------------------------------------------
	-- Numerator
	-- Fixes : string NULL, N/A, --, empty, float leak e.g. '2709.0'
	-- Note  : kept as NVARCHAR - Silver table handles INT conversion
	-- ------------------------------------------------------------
	CASE
		WHEN Numerator IS NULL              THEN 'n/a'
		WHEN TRIM(Numerator) = 'NULL'       THEN 'n/a'
		WHEN TRIM(Numerator) = 'N/A'        THEN 'n/a'
		WHEN TRIM(Numerator) = 'n/a'        THEN 'n/a'
		WHEN TRIM(Numerator) = '--'         THEN 'n/a'
		WHEN TRIM(Numerator) = ''           THEN 'n/a'
		WHEN ISNUMERIC(TRIM(Numerator)) = 1 THEN CAST(CAST(TRIM(Numerator) AS FLOAT) AS NVARCHAR(200))
		ELSE NULL
	END AS Numerator,

	-- ------------------------------------------------------------
	-- Denominator
	-- Fixes : string NULL, N/A, --, empty, zero values, float leak
	-- Note  : zero set to 'n/a' to prevent division by zero later
	-- ------------------------------------------------------------
	CASE
		WHEN Denominator IS NULL              THEN 'n/a'
		WHEN TRIM(Denominator) = 'NULL'       THEN 'n/a'
		WHEN TRIM(Denominator) = 'N/A'        THEN 'n/a'
		WHEN TRIM(Denominator) = 'n/a'        THEN 'n/a'
		WHEN TRIM(Denominator) = '--'         THEN 'n/a'
		WHEN TRIM(Denominator) = ''           THEN 'n/a'
		WHEN TRIM(Denominator) = '0'          THEN 'n/a'
		WHEN TRIM(Denominator) = '0.0'        THEN 'n/a'
		WHEN ISNUMERIC(TRIM(Denominator)) = 1 THEN CAST(CAST(TRIM(Denominator) AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS Denominator,

	-- ------------------------------------------------------------
	-- NumberTakingAP
	-- Fixes : string NULL, N/A, --, empty, float leak
	-- ------------------------------------------------------------
	CASE
		WHEN NumberTakingAP IS NULL                  THEN 'n/a'
		WHEN TRIM(NumberTakingAP) = 'NULL'           THEN 'n/a'
		WHEN TRIM(NumberTakingAP) = 'N/A'            THEN 'n/a'
		WHEN TRIM(NumberTakingAP) = 'n/a'            THEN 'n/a'
		WHEN TRIM(NumberTakingAP) = '--'             THEN 'n/a'
		WHEN TRIM(NumberTakingAP) = ''               THEN 'n/a'
		WHEN ISNUMERIC(TRIM(NumberTakingAP)) = 1
			THEN CAST(CAST(TRIM(NumberTakingAP) AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS NumberTakingAP_Cleaned,

	-- ------------------------------------------------------------
	-- PercentTakingAP
	-- Fixes : string NULL, N/A, --, empty, percent sign stripped
	-- ------------------------------------------------------------
	CASE
		WHEN PercentTakingAP IS NULL                 THEN 'n/a'
		WHEN TRIM(PercentTakingAP) = 'NULL'          THEN 'n/a'
		WHEN TRIM(PercentTakingAP) = 'N/A'           THEN 'n/a'
		WHEN TRIM(PercentTakingAP) = 'n/a'           THEN 'n/a'
		WHEN TRIM(PercentTakingAP) = '--'            THEN 'n/a'
		WHEN TRIM(PercentTakingAP) = ''              THEN 'n/a'
		WHEN ISNUMERIC(REPLACE(TRIM(PercentTakingAP), '%', '')) = 1
			THEN CAST(CAST(REPLACE(TRIM(PercentTakingAP), '%', '') AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS PercentTakingAP,

	-- ------------------------------------------------------------
	-- NumberTakingIB
	-- Fixes : string NULL, N/A, --, empty, float leak
	-- ------------------------------------------------------------
	CASE
		WHEN NumberTakingIB IS NULL                  THEN 'n/a'
		WHEN TRIM(NumberTakingIB) = 'NULL'           THEN 'n/a'
		WHEN TRIM(NumberTakingIB) = 'N/A'            THEN 'n/a'
		WHEN TRIM(NumberTakingIB) = 'n/a'            THEN 'n/a'
		WHEN TRIM(NumberTakingIB) = '--'             THEN 'n/a'
		WHEN TRIM(NumberTakingIB) = ''               THEN 'n/a'
		WHEN ISNUMERIC(TRIM(NumberTakingIB)) = 1
			THEN CAST(CAST(TRIM(NumberTakingIB) AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS NumberTakingIB,

	-- ------------------------------------------------------------
	-- PercentTakingIB
	-- Fixes : string NULL, N/A, --, empty, percent sign stripped
	-- ------------------------------------------------------------
	CASE
		WHEN PercentTakingIB IS NULL                 THEN 'n/a'
		WHEN TRIM(PercentTakingIB) = 'NULL'          THEN 'n/a'
		WHEN TRIM(PercentTakingIB) = 'N/A'           THEN 'n/a'
		WHEN TRIM(PercentTakingIB) = 'n/a'           THEN 'n/a'
		WHEN TRIM(PercentTakingIB) = '--'            THEN 'n/a'
		WHEN TRIM(PercentTakingIB) = ''              THEN 'n/a'
		WHEN ISNUMERIC(REPLACE(TRIM(PercentTakingIB), '%', '')) = 1
			THEN CAST(CAST(REPLACE(TRIM(PercentTakingIB), '%', '') AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS PercentTakingIB,

	-- ------------------------------------------------------------
	-- NumberTakingCollegeInTheHighSchool
	-- Fixes : string NULL, N/A, --, empty, float leak
	-- ------------------------------------------------------------
	CASE
		WHEN NumberTakingCollegeInTheHighSchool IS NULL               THEN 'n/a'
		WHEN TRIM(NumberTakingCollegeInTheHighSchool) = 'NULL'        THEN 'n/a'
		WHEN TRIM(NumberTakingCollegeInTheHighSchool) = 'N/A'         THEN 'n/a'
		WHEN TRIM(NumberTakingCollegeInTheHighSchool) = 'n/a'         THEN 'n/a'
		WHEN TRIM(NumberTakingCollegeInTheHighSchool) = '--'          THEN 'n/a'
		WHEN TRIM(NumberTakingCollegeInTheHighSchool) = ''            THEN 'n/a'
		WHEN ISNUMERIC(TRIM(NumberTakingCollegeInTheHighSchool)) = 1
			THEN CAST(CAST(TRIM(NumberTakingCollegeInTheHighSchool) AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS NumberTakingCollegeInTheHighSchool,

	-- ------------------------------------------------------------
	-- PercentTakingCollegeInTheHighSchool
	-- Fixes : string NULL, N/A, --, empty, percent sign stripped
	-- ------------------------------------------------------------
	CASE
		WHEN PercentTakingCollegeInTheHighSchool IS NULL              THEN 'n/a'
		WHEN TRIM(PercentTakingCollegeInTheHighSchool) = 'NULL'       THEN 'n/a'
		WHEN TRIM(PercentTakingCollegeInTheHighSchool) = 'N/A'        THEN 'n/a'
		WHEN TRIM(PercentTakingCollegeInTheHighSchool) = 'n/a'        THEN 'n/a'
		WHEN TRIM(PercentTakingCollegeInTheHighSchool) = '--'         THEN 'n/a'
		WHEN TRIM(PercentTakingCollegeInTheHighSchool) = ''           THEN 'n/a'
		WHEN ISNUMERIC(REPLACE(TRIM(PercentTakingCollegeInTheHighSchool), '%', '')) = 1
			THEN CAST(CAST(REPLACE(TRIM(PercentTakingCollegeInTheHighSchool), '%', '') AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS PercentTakingCollegeInTheHighSchool,

	-- ------------------------------------------------------------
	-- NumberTakingCambridge
	-- Fixes : string NULL, N/A, --, empty, float leak
	-- ------------------------------------------------------------
	CASE
		WHEN NumberTakingCambridge IS NULL               THEN 'n/a'
		WHEN TRIM(NumberTakingCambridge) = 'NULL'        THEN 'n/a'
		WHEN TRIM(NumberTakingCambridge) = 'N/A'         THEN 'n/a'
		WHEN TRIM(NumberTakingCambridge) = 'n/a'         THEN 'n/a'
		WHEN TRIM(NumberTakingCambridge) = '--'          THEN 'n/a'
		WHEN TRIM(NumberTakingCambridge) = ''            THEN 'n/a'
		WHEN ISNUMERIC(TRIM(NumberTakingCambridge)) = 1
			THEN CAST(CAST(TRIM(NumberTakingCambridge) AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS NumberTakingCambridge,

	-- ------------------------------------------------------------
	-- PercentTakingCambridge
	-- Fixes : string NULL, N/A, --, empty, percent sign stripped
	-- ------------------------------------------------------------
	CASE
		WHEN PercentTakingCambridge IS NULL              THEN 'n/a'
		WHEN TRIM(PercentTakingCambridge) = 'NULL'       THEN 'n/a'
		WHEN TRIM(PercentTakingCambridge) = 'N/A'        THEN 'n/a'
		WHEN TRIM(PercentTakingCambridge) = 'n/a'        THEN 'n/a'
		WHEN TRIM(PercentTakingCambridge) = '--'         THEN 'n/a'
		WHEN TRIM(PercentTakingCambridge) = ''           THEN 'n/a'
		WHEN ISNUMERIC(REPLACE(TRIM(PercentTakingCambridge), '%', '')) = 1
			THEN CAST(CAST(REPLACE(TRIM(PercentTakingCambridge), '%', '') AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS PercentTakingCambridge,

	-- ------------------------------------------------------------
	-- NumberTakingRunningStart
	-- Fixes : string NULL, N/A, --, empty, float leak
	-- ------------------------------------------------------------
	CASE
		WHEN NumberTakingRunningStart IS NULL            THEN 'n/a'
		WHEN TRIM(NumberTakingRunningStart) = 'NULL'     THEN 'n/a'
		WHEN TRIM(NumberTakingRunningStart) = 'N/A'      THEN 'n/a'
		WHEN TRIM(NumberTakingRunningStart) = 'n/a'      THEN 'n/a'
		WHEN TRIM(NumberTakingRunningStart) = '--'       THEN 'n/a'
		WHEN TRIM(NumberTakingRunningStart) = ''         THEN 'n/a'
		WHEN ISNUMERIC(TRIM(NumberTakingRunningStart)) = 1
			THEN CAST(CAST(TRIM(NumberTakingRunningStart) AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS NumberTakingRunningStart,

	-- ------------------------------------------------------------
	-- PercentTakingRunningStart
	-- Fixes : string NULL, N/A, --, empty, percent sign stripped
	-- ------------------------------------------------------------
	CASE
		WHEN PercentTakingRunningStart IS NULL           THEN 'n/a'
		WHEN TRIM(PercentTakingRunningStart) = 'NULL'    THEN 'n/a'
		WHEN TRIM(PercentTakingRunningStart) = 'N/A'     THEN 'n/a'
		WHEN TRIM(PercentTakingRunningStart) = 'n/a'     THEN 'n/a'
		WHEN TRIM(PercentTakingRunningStart) = '--'      THEN 'n/a'
		WHEN TRIM(PercentTakingRunningStart) = ''        THEN 'n/a'
		WHEN ISNUMERIC(REPLACE(TRIM(PercentTakingRunningStart), '%', '')) = 1
			THEN CAST(CAST(REPLACE(TRIM(PercentTakingRunningStart), '%', '') AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS PercentTakingRunningStart,

	-- ------------------------------------------------------------
	-- NumberTakingCTETechPrep
	-- Fixes : string NULL, N/A, --, empty, float leak
	-- ------------------------------------------------------------
	CASE
		WHEN NumberTakingCTETechPrep IS NULL             THEN 'n/a'
		WHEN TRIM(NumberTakingCTETechPrep) = 'NULL'      THEN 'n/a'
		WHEN TRIM(NumberTakingCTETechPrep) = 'N/A'       THEN 'n/a'
		WHEN TRIM(NumberTakingCTETechPrep) = 'n/a'       THEN 'n/a'
		WHEN TRIM(NumberTakingCTETechPrep) = '--'        THEN 'n/a'
		WHEN TRIM(NumberTakingCTETechPrep) = ''          THEN 'n/a'
		WHEN ISNUMERIC(TRIM(NumberTakingCTETechPrep)) = 1
			THEN CAST(CAST(TRIM(NumberTakingCTETechPrep) AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS NumberTakingCTETechPrep,

	-- ------------------------------------------------------------
	-- PercentTakingCTETechPrep
	-- Fixes : string NULL, N/A, --, empty, percent sign stripped
	-- Note  : duplicate removed from original script
	-- ------------------------------------------------------------
	CASE
		WHEN PercentTakingCTETechPrep IS NULL            THEN 'n/a'
		WHEN TRIM(PercentTakingCTETechPrep) = 'NULL'     THEN 'n/a'
		WHEN TRIM(PercentTakingCTETechPrep) = 'N/A'      THEN 'n/a'
		WHEN TRIM(PercentTakingCTETechPrep) = 'n/a'      THEN 'n/a'
		WHEN TRIM(PercentTakingCTETechPrep) = '--'       THEN 'n/a'
		WHEN TRIM(PercentTakingCTETechPrep) = ''         THEN 'n/a'
		WHEN ISNUMERIC(REPLACE(TRIM(PercentTakingCTETechPrep), '%', '')) = 1
			THEN CAST(CAST(REPLACE(TRIM(PercentTakingCTETechPrep), '%', '') AS FLOAT) AS NVARCHAR(200))
		ELSE 'n/a'
	END AS PercentTakingCTETechPrep,

	-- ------------------------------------------------------------
	-- DataAsOf
	-- Fixes : multiple date formats standardized to YYYY-MM-DD
	--         string NULL, empty string
	-- ------------------------------------------------------------
	CASE
		WHEN DataAsOf IS NULL                THEN 'n/a'
		WHEN TRIM(DataAsOf) = 'NULL'         THEN 'n/a'
		WHEN TRIM(DataAsOf) = ''             THEN 'n/a'
		WHEN TRIM(DataAsOf) = 'Oct 2022'     THEN '2022-10-01'
		WHEN TRIM(DataAsOf) = '10/01/2022'   THEN '2022-10-01'
		WHEN TRIM(DataAsOf) = '10-01-2022'   THEN '2022-10-01'
		WHEN TRIM(DataAsOf) = '2022/10/01'   THEN '2022-10-01'
		WHEN TRIM(DataAsOf) = '2022-10-1'    THEN '2022-10-01'
		WHEN TRIM(DataAsOf) = '2022-09-30'   THEN '2022-09-30'
		WHEN TRIM(DataAsOf) = '2022-10-01'   THEN '2022-10-01'
		ELSE TRIM(DataAsOf)
	END AS DataAsOf

-- ------------------------------------------------------------
-- Source Table
-- ------------------------------------------------------------
FROM reportcard_sqss_2021_2022.bronze.school_performance;