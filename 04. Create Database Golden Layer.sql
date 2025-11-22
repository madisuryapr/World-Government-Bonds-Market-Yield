/* Creating Golden Layer Database */

-- 1. Create a database designated for Golden Layer
CREATE DATABASE gold_world_gov_bonds;

-- 2. Use the newly created golden layer database
USE gold_world_gov_bonds;

-- 3. Import both fact_globalbonds_rate and fact_globalbonds_bps tables from world_bonds_market_yield (Silver Layer)
-- Import fact table for fact_globalbonds_bps
SELECT
    *,
    CAST(
           (AVG(YieldPrice) OVER (
                PARTITION BY CountryID, BondID
                ORDER BY DatePeriod
                ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
                )) AS NUMERIC(10, 2)
    ) AS MA50_YieldPrice,
    CAST(
           (AVG(YieldPrice) OVER (
                PARTITION BY CountryID, BondID
                ORDER BY DatePeriod
                ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
                )) AS NUMERIC(10, 2)
    ) AS MA200_YieldPrice
INTO gold_world_gov_bonds.dbo.fact_globalbonds_bps
FROM
    world_bonds_market_yield.dbo.fact_globalbonds_bps
ORDER BY
    CountryID ASC, BondID ASC, DateID ASC;

-- Import fact table for fact_globalbonds_rate
SELECT
    *,
    CAST(
           (AVG(YieldPrice) OVER (
                PARTITION BY CountryID, BondID
                ORDER BY DatePeriod
                ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
                )) AS NUMERIC(10, 4)
    ) AS MA50_YieldPrice,
    CAST(
           (AVG(YieldPrice) OVER (
                PARTITION BY CountryID, BondID
                ORDER BY DatePeriod
                ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
                )) AS NUMERIC(10, 4)
    ) AS MA200_YieldPrice
INTO gold_world_gov_bonds.dbo.fact_globalbonds_rate
FROM
    world_bonds_market_yield.dbo.fact_globalbonds_rate
ORDER BY
    CountryID ASC, BondID ASC, DateID ASC;

-- 4. Import dim_bondsname table from Silver Layer
SELECT
    *
INTO dim_bondsname
FROM world_bonds_market_yield.dbo.dim_bondsname;

-- 5. Import dim_country table from Silver Layer
SELECT
    *
INTO dim_country
FROM world_bonds_market_yield.dbo.dim_country;

-- 6. Import dim_daydate table from Silver Layer
SELECT *
INTO dim_daydate
FROM world_bonds_market_yield.dbo.dim_daydate;

-- 7. Import dim_month table from Silver Layer
SELECT *
INTO dim_month
FROM world_bonds_market_yield.dbo.dim_month;

-- 8. Import dim_quarter table from Silver Layer
SELECT *
INTO dim_quarter
FROM world_bonds_market_yield.dbo.dim_quarter;

-- 9. Import dim_year table from Silver Layer
SELECT *
INTO dim_year
FROM world_bonds_market_yield.dbo.dim_year;

-- 10. Import dim_region from Silver Layer
SELECT *
INTO dim_region
FROM world_bonds_market_yield.dbo.dim_region;