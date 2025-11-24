/* Exploring Golden Layer Database with MS SQL Server */
/* This file is written by author to explore Golden Layer Database */

-- Use gold_world_gov_bonds database
USE gold_world_gov_bonds;

-- 1. Calculate number of trading days for each year of every country.
SELECT
    fbr.CountryID AS CountryCode,
    dc.CountryName AS CountryName,
    YEAR(fbr.DatePeriod) AS year,
    COUNT(DISTINCT fbr.DatePeriod) AS NumOfTradingDays
FROM
    fact_globalbonds_rate AS fbr
INNER JOIN
    dim_country AS dc ON dc.CountryID = fbr.CountryID
GROUP BY
    fbr.CountryId, dc.CountryName, YEAR(fbr.DatePeriod)
ORDER BY
    dc.CountryName ASC, year ASC;

-- 2. What are the annual average for 10-Year government bonds yields (in basis points) for each Asian Country?
SELECT
    dc.CountryName AS CountryName,
    YEAR(DatePeriod) AS Year,
    CAST(
        AVG(fbb.YieldPrice)
            AS NUMERIC(10, 2)
    ) AS Average10YearYieldPrice
FROM
    fact_globalbonds_bps AS fbb
INNER JOIN
    dim_country AS dc ON dc.CountryID = fbb.CountryID
INNER JOIN
    dim_region AS dr ON dr.RegionID = dc.RegionID
WHERE
    dr.RegionID = 'AS' AND fbb.BondID = 'GBY10Y'
GROUP BY
    dc.CountryName, YEAR(DatePeriod)
ORDER BY
    dc.CountryName ASC, Year ASC;

-- 3. How many days that Indonesian Government Bonds rate for each Maturity Time Greater than
-- their corresponding annual average in a year?
WITH IndonesianGovBonds AS (
    SELECT
        fbr.CountryID AS CountryID,
        fbr.BondID AS BondID,
        fbr.DatePeriod AS DatePeriod,
        fbr.YieldPrice AS YieldPrice
    FROM
        fact_globalbonds_rate AS fbr
    WHERE
        fbr.CountryID = 'IDN360'
),
    IndonesiaAverageYieldPrice AS (
        SELECT
            fbr.CountryID,
            fbr.BondID,
            YEAR(fbr.DatePeriod) AS YearPeriod,
            AVG(YieldPrice) AS AverageYieldPrice
        FROM
            fact_globalbonds_rate AS fbr
        WHERE
            CountryID = 'IDN360'
        GROUP BY
            CountryID, BondID, YEAR(fbr.DatePeriod)
    )
SELECT
    igb.CountryID,
    igb.BondID,
    YEAR(igb.DatePeriod) AS YearPeriod,
    COUNT(igb.YieldPrice) AS NumberOfOccurrence
FROM
    IndonesianGovBonds AS igb
INNER JOIN
    IndonesiaAverageYieldPrice AS iap ON iap.CountryID = igb.CountryID
    AND iap.BondID = igb.BondID
    AND iap.YearPeriod = YEAR(igb.DatePeriod)
WHERE
    igb.YieldPrice > iap.AverageYieldPrice
GROUP BY
    igb.CountryID, igb.BondID, YEAR(igb.DatePeriod)
ORDER BY
    BondID ASC, YearPeriod ASC;

-- 4. Create a daily time series dataset of 10-Year government bonds yield for each region by using
-- basis points (bps) table.
SELECT
    dr.RegionID AS RegionID,
    dr.RegionName AS RegionName,
    fbb.BondID AS BondID,
    fbb.DatePeriod AS TimeDate,
    CAST(
        AVG(fbb.YieldPrice)
        AS NUMERIC (10, 3)
    ) AS YieldPrice
FROM
    fact_globalbonds_bps AS fbb
INNER JOIN
    dim_country AS dc ON dc.CountryID = fbb.CountryID
INNER JOIN
    dim_region AS dr ON dr.RegionID = dc.RegionID
WHERE
    fbb.BondID = 'GBY10Y'
GROUP BY
    dr.RegionID, dr.RegionName, fbb.BondID, fbb.DatePeriod
ORDER BY
    dr.RegionID ASC, TimeDate ASC;