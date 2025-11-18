/** Use created database to fill the data **/
USE world_bonds_market_yield;

/** Insert all Data by Importing .csv files with BULK INSERT function **/

/* 1. Import data for fact_globalbonds_bps */
BULK INSERT fact_globalbonds_bps
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\fact_globalbonds_bps.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );

/* 2. Import data for fact_globalbonds_rate */
BULK INSERT fact_globalbonds_rate
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\fact_globalbonds_rate.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );

/* 3. Import data for dim_bondsname */
BULK INSERT dim_bondsname
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\dim_bondsname.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );

/* 4. Import data for dim_country */
BULK INSERT dim_country
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\dim_country.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );

/* 5. Import data for dim_daydate */
BULK INSERT dim_daydate
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\dim_daydate.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );

/* 6. Import data for dim_month */
BULK INSERT dim_month
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\dim_month.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );

/* 7. Import data for dim_quarter */
BULK INSERT dim_quarter
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\dim_quarter.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );

/* 8. Import data for dim_region */
BULK INSERT dim_region
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\dim_region.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );

/* 9. Import data for dim_year */
BULK INSERT dim_year
    FROM
    'D:\Data Analytics, Science, and Engineering\Project\World Government Bonds Market Yield\Data\dim_year.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    FIRSTROW = 2
    );
