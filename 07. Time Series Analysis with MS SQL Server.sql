/* Time Series Analysis with MS SQL Server */
/* In this file, I demonstrate how to perform time series analysis by employing Golden Layer databaase
   that already created before.
 */

-- Use Golden Layer Database
USE gold_world_gov_bonds;

-- 1. Calculate the difference between Bonds' Yield Price and short and long-term Moving Average for Indonesia
-- Note: I perform this analysis using basis points (bps) as the unit of measurement.
WITH IndonesiaGovBonds AS (
    SELECT
        fgb.CountryID AS CountryID,
        dc.CountryName AS CountryName,
        fgb.BondID AS BondID,
        fgb.DatePeriod AS DateTime,
        fgb.YieldPrice AS Price,
        fgb.MA50_YieldPrice AS ShortMA,
        fgb.MA200_YieldPrice AS LongMA
    FROM
        fact_globalbonds_bps AS fgb
    INNER JOIN
        dim_country AS dc ON dc.CountryID = fgb.CountryID
    WHERE
        dc.CountryName = 'Indonesia'
)
SELECT
    CountryID,
    CountryName,
    BondID,
    DateTime,
    Price,
    (Price - ShortMA) AS ShortDiff,
    (Price - LongMA) AS LongDiff
FROM
    IndonesiaGovBonds
ORDER BY
    BondID ASC, DateTime;

-- 2. Perform data extraction for short and long-term moving standard deviation of Sample
-- for China 1-, 5-, and 10-year government bonds yield.
-- Note: I demonstrate this code by employing fact_globalbonds_rate
WITH ChinaGovBonds1510 AS (
    SELECT
        fbr.CountryID AS CountryID,
        dc.CountryName AS CountryName,
        fbr.BondID AS BondID,
        fbr.DatePeriod AS DateTime,
        fbr.YieldPrice AS Price
    FROM
        fact_globalbonds_rate AS fbr
    INNER JOIN
        dim_country AS dc ON dc.CountryID = fbr.CountryID
    WHERE
        dc.CountryName = 'China' AND
        fbr.BondID IN ('GBY1Y', 'GBY5Y', 'GBY10Y')
)
SELECT
    CountryID,
    CountryName,
    BondID,
    DateTime,
    Price,
    CAST(
        STDEV(Price) OVER (
            PARTITION BY BondID
            ORDER BY DateTime
            ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
            ) AS NUMERIC(10, 4)
    ) AS ShortStDev,
    CAST(
        STDEV(Price) OVER (
            PARTITION BY BondID
            ORDER BY DateTime
            ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
            ) AS NUMERIC(10, 4)
    ) AS LongStDev
FROM
    ChinaGovBonds1510
ORDER BY
    BondID ASC, DateTime;

-- 3. What are the 10-year Government Bonds Spread Between Asia and Europe of YieldPriceBased on basis points (bps)?
WITH AsianBonds10Y AS (
    SELECT
        dr.RegionID AS RegionID,
        fgb.DateID AS DateID,
        fgb.DatePeriod AS TimePeriod,
        CAST(
            AVG(fgb.YieldPrice) AS NUMERIC(10, 3)
        ) AS YieldPrice
    FROM
        fact_globalbonds_bps AS fgb
    INNER JOIN
        dim_country AS dc ON dc.CountryID = fgb.CountryID
    INNER JOIN
        dim_region AS dr ON dr.RegionID = dc.RegionID
    INNER JOIN
        dim_daydate AS ddy ON fgb.DateID = ddy.DateID
    WHERE
        dr.RegionID = 'AS' AND fgb.BondID = 'GBY10Y'
    GROUP BY
        dr.RegionID, fgb.DateID, fgb.DatePeriod
),
    EuropeBonds10Y AS (
        SELECT
        dr.RegionID AS RegionID,
        fgb.DateID AS DateID,
        fgb.DatePeriod AS TimePeriod,
       CAST(
            AVG(fgb.YieldPrice) AS NUMERIC(10, 3)
        ) AS YieldPrice
    FROM
        fact_globalbonds_bps AS fgb
    INNER JOIN
        dim_country AS dc ON dc.CountryID = fgb.CountryID
    INNER JOIN
        dim_region AS dr ON dr.RegionID = dc.RegionID
    INNER JOIN
        dim_daydate AS ddy ON fgb.DateID = ddy.DateID
    WHERE
        dr.RegionID = 'EU' AND fgb.BondID = 'GBY10Y'
    GROUP BY
        dr.RegionID, fgb.DateID, fgb.DatePeriod
    )
SELECT
    ab10y.DateID AS DateID,
    ab10y.TimePeriod AS DateSeries,
    CAST(
        (ab10y.YieldPrice - eb10y.YieldPrice) AS NUMERIC(10, 3)
    ) AS BondSpread
FROM AsianBonds10Y AS ab10y
INNER JOIN
    EuropeBonds10Y AS eb10y ON eb10y.DateID = ab10y.DateID
ORDER BY
    DateSeries ASC;