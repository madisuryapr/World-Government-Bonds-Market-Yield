/* Use world_bonds_market_yield database */
USE world_bonds_market_yield;

-- 1. Create connection for BondID within both fact_globalbonds_bps and fact_globalbonds_rate with dim_bondsname
-- Make corresponding column non-null and unique
-- Implement Non-null and unique to BondID on dim_bondsname table
ALTER TABLE dim_bondsname
ALTER COLUMN BondID VARCHAR(25) NOT NULL;

ALTER TABLE dim_bondsname
ADD CONSTRAINT UC_world_bonds_market_yield_BondID
UNIQUE(BondID);

-- Implement non-null to BondID on both fact_globalbonds_bps and fact_globalbonds_rate
ALTER TABLE fact_globalbonds_bps
ALTER COLUMN BondID VARCHAR(25) NOT NULL;

ALTER TABLE fact_globalbonds_rate
ALTER COLUMN BondID VARCHAR(25) NOT NULL;

-- Create connection between three tables
ALTER TABLE dim_bondsname
ADD PRIMARY KEY (BondID);

ALTER TABLE fact_globalbonds_rate
ADD FOREIGN KEY (BondID) REFERENCES dim_bondsname(BondID);

ALTER TABLE fact_globalbonds_bps
ADD FOREIGN KEY (BondID) REFERENCES dim_bondsname(BondID);

-- 2. Create connection for DateID within both fact_globalbonds_rate and fact_globalbonds_bps with dim_daydate
-- Make corresponding columns non-null and unique
ALTER TABLE dim_daydate
ALTER COLUMN DateID BIGINT NOT NULL;

ALTER TABLE dim_daydate
ADD CONSTRAINT UC_world_bonds_market_yield_DateID
UNIQUE(DateID);

-- Implement non-null to DateID on both fact_globalbonds_bps and fact_globalbonds_rate
ALTER TABLE fact_globalbonds_bps
ALTER COLUMN DateID BIGINT NOT NULL;

ALTER TABLE fact_globalbonds_rate
ALTER COLUMN DateID BIGINT NOT NULL;

-- Create connection between three tables
ALTER TABLE dim_daydate
ADD PRIMARY KEY (DateID);

ALTER TABLE fact_globalbonds_rate
ADD FOREIGN KEY (DateID) REFERENCES dim_daydate(DateID);

ALTER TABLE fact_globalbonds_bps
ADD FOREIGN KEY (DateID) REFERENCES dim_daydate(DateID);

-- 3. Create connection between dim_daydate and dim_month table through MonthID column
-- Make MonthID column becomes non-null and unique
ALTER TABLE dim_month
ALTER COLUMN MonthID VARCHAR(25) NOT NULL;

ALTER TABLE dim_month
ADD CONSTRAINT UC_world_bonds_market_yield_dim_month
UNIQUE(MonthID);

-- Do the same step of non-null for MonthID column within dim_daydate table
ALTER TABLE dim_daydate
ALTER COLUMN MonthID VARCHAR(25) NOT NULL;

-- Perform connection
ALTER TABLE dim_month
ADD PRIMARY KEY (MonthID);

ALTER TABLE dim_daydate
ADD FOREIGN KEY (MonthID) REFERENCES dim_month(MonthID);

-- 4. Create connection between dim_month and dim_quarter table through QuarterID Column
-- Make QuarterID column becomes non-null and unique
ALTER TABLE dim_quarter
ALTER COLUMN QuarterID VARCHAR(25) NOT NULL;

ALTER TABLE dim_quarter
ADD CONSTRAINT UC_world_bonds_market_yield_dim_quarter
UNIQUE(QuarterID);

-- Do the same step of non-null for QuarterID column within dim_month table
ALTER TABLE dim_month
ALTER COLUMN QuarterID VARCHAR(25) NOT NULL;

-- Perform Connection
ALTER TABLE dim_quarter
ADD PRIMARY KEY (QuarterID);

ALTER TABLE dim_month
ADD FOREIGN KEY (QuarterID) REFERENCES dim_quarter(QuarterID);

-- 5. Create connection between dim_quarter and dim_year table through YearID Column
-- Make YearID column becomes non-null and unique
ALTER TABLE dim_year
ALTER COLUMN YearID VARCHAR(25) NOT NULL;

ALTER TABLE dim_year
ADD CONSTRAINT UC_world_bonds_market_yield_dim_year
UNIQUE(YearID);

-- Do the same step of non-null for QuarterID column within dim_month table
ALTER TABLE dim_quarter
ALTER COLUMN YearID VARCHAR(25) NOT NULL;

-- Perform Connection
ALTER TABLE dim_year
ADD PRIMARY KEY (YearID);

ALTER TABLE dim_quarter
ADD FOREIGN KEY (YearID) REFERENCES dim_year(YearID);

-- 6. Create connection for CountryID within both fact_globalbonds_bps and fact_globalbonds_rate with dim_country
-- Make corresponding column non-null and unique
-- Implement Non-null and unique to BondID on dim_bondsname table
ALTER TABLE dim_country
ALTER COLUMN CountryID VARCHAR(35) NOT NULL;

ALTER TABLE dim_country
ADD CONSTRAINT UC_world_bonds_market_yield_dim_country
UNIQUE(CountryID);

-- Implement non-null to BondID on both fact_globalbonds_bps and fact_globalbonds_rate
ALTER TABLE fact_globalbonds_bps
ALTER COLUMN CountryID VARCHAR(35) NOT NULL;

ALTER TABLE fact_globalbonds_rate
ALTER COLUMN CountryID VARCHAR(35) NOT NULL;

-- Create connection between three tables
ALTER TABLE dim_country
ADD PRIMARY KEY (CountryID);

ALTER TABLE fact_globalbonds_rate
ADD FOREIGN KEY (CountryID) REFERENCES dim_country(CountryID);

ALTER TABLE fact_globalbonds_bps
ADD FOREIGN KEY (CountryID) REFERENCES dim_country(CountryID);

-- 7. Create connection between dim_region and dim_country table through RegionID Column
-- Make YearID column becomes non-null and unique
ALTER TABLE dim_region
ALTER COLUMN RegionID VARCHAR(25) NOT NULL;

ALTER TABLE dim_region
ADD CONSTRAINT UC_world_bonds_market_yield_dim_region
UNIQUE(RegionID);

-- Do the same step of non-null for QuarterID column within dim_month table
ALTER TABLE dim_country
ALTER COLUMN RegionID VARCHAR(25) NOT NULL;

-- Perform Connection
ALTER TABLE dim_region
ADD PRIMARY KEY (RegionID);

ALTER TABLE dim_country
ADD FOREIGN KEY (RegionID) REFERENCES dim_region(RegionID);