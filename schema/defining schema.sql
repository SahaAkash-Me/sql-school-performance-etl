/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'Reportcard_sqss_2021_2022' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'Reportcard_sqss_2021_2022' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'reportcard_sqss_2021_2022' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'reportcard_sqss_2021_2022')
BEGIN
    ALTER DATABASE reportcard_sqss_2021_2022 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE reportcard_sqss_2021_2022;
END;
GO

-- Create the 'reportcard_sqss_2021_2022' database
CREATE DATABASE reportcard_sqss_2021_2022;
GO

USE reportcard_sqss_2021_2022;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO