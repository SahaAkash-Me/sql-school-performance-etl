CREATE OR ALTER PROCEDURE bronze.load_bronze_school_performance AS
BEGIN
	/* ===============================================================================
	1. CLEANUP: Remove the table if it already exists to allow for a fresh schema
	===============================================================================
	*/
	DROP TABLE IF EXISTS bronze.school_performance;

	/* ===============================================================================
	2. DDL: Create the Landing Table (Bronze Layer)
	===============================================================================
	*/
	CREATE TABLE bronze.school_performance (
		-- Administrative & Geographic Details
		SchoolYear                          NVARCHAR(200),  -- e.g., "2021-22"
		OrganizationLevel                   NVARCHAR(200),  -- e.g., "School", "District"
		County                              NVARCHAR(200),
		ESDName                             NVARCHAR(1200), -- Educational Service District
		ESDOrganizationID                   NVARCHAR(200),
    
		-- District Identification
		DistrictCode                        NVARCHAR(200),
		DistrictName                        NVARCHAR(1200),
		DistrictOrganizationId              NVARCHAR(200),
    
		-- School Identification (Allowing NULLs for District-level rows)
		SchoolCode                          NVARCHAR(200) NULL,
		SchoolName                          NVARCHAR(2000) NULL,
		SchoolOrganizationId                NVARCHAR(200) NULL,
		CurrentSchoolType                   NVARCHAR(200) NULL,
    
		-- Student Demographics & Academic Measures
		StudentGroupType                    NVARCHAR(100),  -- e.g., "Race", "Gender"
		StudentGroup                        NVARCHAR(1200), -- e.g., "Hispanic/Latino"
		GradeLevel                          NVARCHAR(200),
		Measure                             NVARCHAR(2000), -- The specific KPI being measured
		SuppressionReason                   NVARCHAR(2000), -- Explanation if data is hidden for privacy
    
		-- Statistics (Kept as NVARCHAR to handle suppression symbols or formatting)
		Numerator                           NVARCHAR(200) NULL,
		Denominator                         NVARCHAR(200) NULL,
    
		-- Advanced Placement (AP) Metrics
		NumberTakingAP                      NVARCHAR(200) NULL,
		PercentTakingAP                     NVARCHAR(200) NULL,
    
		-- International Baccalaureate (IB) Metrics
		NumberTakingIB                      NVARCHAR(200) NULL,
		PercentTakingIB                     NVARCHAR(200) NULL,
    
		-- College in the High School Metrics
		NumberTakingCollegeInTheHighSchool  NVARCHAR(200) NULL,
		PercentTakingCollegeInTheHighSchool NVARCHAR(200) NULL,
    
		-- Cambridge Program Metrics
		NumberTakingCambridge               NVARCHAR(200) NULL,
		PercentTakingCambridge              NVARCHAR(200) NULL,
    
		-- Running Start Metrics
		NumberTakingRunningStart            NVARCHAR(200) NULL,
		PercentTakingRunningStart           NVARCHAR(200) NULL,
    
		-- CTE Tech Prep Metrics
		NumberTakingCTETechPrep             NVARCHAR(200) NULL,
		PercentTakingCTETechPrep            NVARCHAR(200) NULL,
    
		-- Metadata
		DataAsOf                            NVARCHAR(200)   -- Load date from source file
	)
END;