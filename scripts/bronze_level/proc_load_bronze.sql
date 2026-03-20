BULK INSERT bronze.school_performance
FROM 'D:\Projects\SQL Projects\SQL-report card sqss 2021-2022 Project\dataset\school_performance_raw.csv'
WITH
(
    FORMAT          = 'CSV',
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    FIELDQUOTE      = '"',
    TABLOCK
);

SELECT * FROM bronze.school_performance;