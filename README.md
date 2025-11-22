## World Government Bonds Market Yield Project
In this repository, I devise a Database for World Government Bonds Market Yield, encompassing 25 countries in which include Indonesia. The objective of this repository is to explore the government bonds yields and observe their daily trend over the period January 2020 until August 2025, encapsulating both Pandemic and Post-Pandemic Era. Furthermore, this database can be utilized within Economics & Finance environment for analyzing various aspects of bonds yield, such as Bonds Spread between Indonesia and US 10-Year Government Bond Yields to measure risk premium.  

There are several tools that I implement in executing the project for this repository, including:
- Pandas: cleaning and merging bonds yield data for different maturity time into single file (note: the creation of this Python Code is supported by ChatGPT),
- Power Query: Merging all cleansed bonds yield data for 25 countries
- MS SQL Server: Main Relational Database Management Systems (RDBMS) for devising the database.  

Further, in devising Database Model for World Government Bonds Yield Data Warehouse, author employed Galaxy Schema (also known as Fact Constellation Schema) , where two different fact tables share common dimension tables. The Diagram of Database Model can be observed through this picture below.  

**Figure 1. Database Model Diagram for World Government Bonds Yield**
<img width="2710" height="2056" alt="World Government Bonds_Database Model" src="https://github.com/user-attachments/assets/db676194-7c8b-4a60-bdc6-69c471f367ee" />  

To create this Galaxy Schema, this repository implements Medallion Data Modelling, where three steps are utilized to model a database, namely Bronze Layer, Silver Layer, and Golder Layer. Specifically, each layer can be examined as follows:  
- Bronze Layer: This layer encapsulates all raw data from data sources utilized for devising this database, such as investing.com .csv files for fact tables
- Silver Layer: In this layer, all raw data are cleansed and become interpretable-ready data for both fact and dimension tables
- Golder Layer: Within this layer, all cleansed data within prior layer are adjusted for business-specific purpose by creating additional column (such as moving averages in this case)

