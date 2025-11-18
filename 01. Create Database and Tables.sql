/** Create Database for World Government Bonds Market Yield **/
CREATE DATABASE world_bonds_market_yield;

/** Use created database for creating table **/
USE world_bonds_market_yield;

/** Create all tables and specify the data format **/
/* 1. Fact Table of Government Bonds Yields in Percentages Rate format */
CREATE TABLE fact_globalbonds_rate (
    CountryID VARCHAR(20),
    BondID VARCHAR(20),
    DateID BIGINT,
    DatePeriod DATE,
    YieldPrice NUMERIC(10, 3),
    YieldOpen NUMERIC(10, 3),
    YieldHigh NUMERIC(10, 3),
    YieldLow NUMERIC(10, 3)
);

/* 2. Fact Table of Government Bonds Yields in Basis Points (bps) format */
CREATE TABLE fact_globalbonds_bps (
    CountryID VARCHAR(20),
    BondID VARCHAR(20),
    DateID BIGINT,
    DatePeriod DATE,
    YieldPrice NUMERIC(10, 3),
    YieldOpen NUMERIC(10, 3),
    YieldHigh NUMERIC(10, 3),
    YieldLow NUMERIC(10, 3)
);

/* 3. Dimension Table for bonds yields information */
CREATE TABLE dim_bondsname (
    BondID VARCHAR(25),
    BondName VARCHAR(MAX)
);

/* 4. Dimension Table for country information */
CREATE TABLE dim_country (
    CountryID VARCHAR(30),
    CountryName VARCHAR(100),
    RegionID VARCHAR(20)
);

/* 5. Dimension Table for region information */
CREATE TABLE dim_region (
    RegionID VARCHAR(20),
    RegionName VARCHAR(40)
);

/* 6. Dimension Table for daily date information */
CREATE TABLE dim_daydate (
    DateID BIGINT,
    DatePeriod DATE,
    MonthID VARCHAR(20)
);

/* 7. Dimension Table for month information */
CREATE TABLE dim_month (
    MonthID VARCHAR(30),
    MonthName VARCHAR(MAX),
    QuarterID VARCHAR(25)
);

/* 8. Dimension Table for quarter information */
CREATE TABLE dim_quarter (
    QuarterID VARCHAR(20),
    QuarterName VARCHAR(MAX),
    YearID VARCHAR(20)
);

/* 9. Dimension Table for year information */
CREATE TABLE dim_year (
    YearID VARCHAR(10),
    YearPeriod INTEGER
);