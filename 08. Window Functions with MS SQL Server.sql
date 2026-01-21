/* Implementing window functions to answering business-related questions for particular bonds rate*/

-- Use gold_world_gov_bonds database
USE gold_world_gov_bonds;

-- 1. Calculate Government Bonds Yield return for the US 10-Year Government Bonds
SELECT
    dc.CountryID AS CountryCode,
    dc.CountryName AS Country,
    fbr.BondID AS BondTerm,
    fbr.DatePeriod AS TimeDate,
    fbr.YieldPrice AS BondPrice,
    LAG(fbr.YieldPrice, 1) OVER (
        PARTITION BY dc.CountryID,
        fbr.BondID ORDER BY fbr.DatePeriod) AS YieldPricePrev,
    CAST(
    (fbr.YieldPrice - LAG(fbr.YieldPrice, 1) OVER (
        PARTITION BY dc.CountryID,
        fbr.BondID ORDER BY fbr.DatePeriod)) AS DECIMAL(10, 4)
    ) AS YieldReturn
FROM
    fact_globalbonds_rate AS fbr
INNER JOIN
    dim_country AS dc ON dc.CountryID = fbr.CountryID
WHERE
    dc.CountryName = 'United States' AND fbr.CountryID = 'USA840'
    AND fbr.BondID = 'GBY10Y'
ORDER BY dc.CountryName, fbr.DatePeriod;

-- 2. Create a Cumulative Distribution Function (CDF) for French 30-Year High Government Bonds Yield Price
SELECT
    dc.CountryID AS CountryCode,
    dc.CountryName AS Country,
    fbr.BondID AS BondTerm,
    fbr.DatePeriod AS TimeDate,
    fbr.YieldHigh AS HighYieldPrice,
    CAST(
        CUME_DIST() OVER (PARTITION BY dc.CountryID,
        fbr.BondID ORDER BY fbr.DatePeriod) AS DECIMAL(10, 5)
    ) AS CDF,
    CAST(
        CUME_DIST() OVER (PARTITION BY dc.CountryID,
        fbr.BondID ORDER BY fbr.DatePeriod) * 100 AS DECIMAL(10, 4)
    ) AS CDFpct
FROM
    fact_globalbonds_rate AS fbr
INNER JOIN
    dim_country AS dc ON dc.CountryID = fbr.CountryID
WHERE
    dc.CountryName = 'France' AND fbr.CountryID = 'FRA250'
    AND fbr.BondID = 'GBY30Y'
ORDER BY dc.CountryName, fbr.DatePeriod;

-- 3. Create a column for examining data distribution of Spain 5-Year Government Bonds Yield Price
-- Based on quantiles. Note: use the Basis Points (bps) fact table.
SELECT
    dc.CountryID AS CountryCode,
    dc.CountryName AS Country,
    fgb.BondID AS BondTerm,
    fgb.DatePeriod AS TimeDate,
    fgb.YieldPrice AS BondYiel,
    CAST(
        PERCENT_RANK() OVER (PARTITION BY dc.CountryID,
        fgb.BondID ORDER BY fgb.DatePeriod) AS DECIMAL(10, 4)
    ) AS DataDistribution,
    CAST(
        PERCENT_RANK() OVER (PARTITION BY dc.CountryID,
        fgb.BondID ORDER BY fgb.DatePeriod) * 100 AS DECIMAL(10, 4)
    ) AS DataDistributionPct,
    CASE
        WHEN PERCENT_RANK() OVER (PARTITION BY dc.CountryID,
            fgb.BondID ORDER BY fgb.DatePeriod) <= 0.25 THEN 'Quantile 1'
        WHEN PERCENT_RANK() OVER (PARTITION BY dc.CountryID,
            fgb.BondID ORDER BY fgb.DatePeriod) <= 0.50 THEN 'Quantile 2'
        WHEN PERCENT_RANK() OVER (PARTITION BY dc.CountryID,
            fgb.BondID ORDER BY fgb.DatePeriod) <= 0.75 THEN 'Quantile 3'
        ELSE 'Quantile 4'
    END AS DataQuantile
FROM
    fact_globalbonds_bps AS fgb
INNER JOIN
    dim_country AS dc ON dc.CountryID = fgb.CountryID
WHERE
    dc.CountryName = 'Spain' AND fgb.CountryID = 'ESP724'
    AND fgb.BondID = 'GBY5Y'
ORDER BY dc.CountryName, fgb.DatePeriod;

-- 4. Devise a Table for South African Government Bonds Yield Data Distribution Based on Decile
-- Note: Use BPS fact table
SELECT
    dc.CountryID AS CountryCode,
    dc.CountryName AS Country,
    fgb.BondID AS BondTerm,
    fgb.DatePeriod AS TimeDate,
    fgb.YieldPrice AS BondPrice,
    NTILE(10) OVER (
        PARTITION BY dc.CountryID, fgb.BondID
        ORDER BY fgb.DatePeriod) AS Decile
FROM
    fact_globalbonds_bps AS fgb
INNER JOIN
    dim_country AS dc ON dc.CountryID = fgb.CountryID
WHERE
    dc.CountryName = 'South Africa' AND fgb.CountryID = 'ZAF710'
ORDER BY Country, BondTerm, TimeDate;

-- 5. Rank the Highest 5-Year Government Bonds Yield value for all listed countries
WITH MaxGBY5Y AS (
    SELECT
        dc.CountryID AS CountryCode,
        dc.CountryName AS Country,
        MAX(fbr.YieldPrice) AS MaxYieldPrice
    FROM
        fact_globalbonds_rate AS fbr
    INNER JOIN
        dim_country AS dc ON dc.CountryID = fbr.CountryID
    WHERE fbr.BondID = 'GBY5Y'
    GROUP BY
        dc.CountryID, dc.CountryName
)
SELECT
    CountryCode,
    Country,
    MaxYieldPrice,
    RANK() OVER (ORDER BY MaxYieldPrice DESC) AS BondRank,
    DENSE_RANK() OVER (ORDER BY MaxYieldPrice DESC) AS BondRankDense

FROM MaxGBY5Y;
