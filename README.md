# 📈 World Government Bonds Market Yield Project

![SQL Server](https://img.shields.io/badge/Database-MSSQL-CC2927?style=for-the-badge&logo=microsoft-sql-server)
![Python](https://img.shields.io/badge/Code-Python_3.12-3776AB?style=for-the-badge&logo=python)

> **Designing a Database Model for World Government Bonds Yield Daily Data of Selected 25 Countries Through January 2020 until August 2025 by Implementing Medallion Architecture.**

---

## 📖 Chapter I: Project Overview
In this repository, I devise a Database for World Government Bonds Market Yield, encompassing 25 countries in which include Indonesia. The objective of this repository is to explore the government bonds yields and observe their daily trend over the period January 2020 until August 2025, encapsulating both Pandemic and Post-Pandemic Era. Furthermore, this database can be utilized within Economics & Finance environment for analyzing various aspects of bonds yield, such as Bonds Spread between Indonesia and US 10-Year Government Bond Yields to measure risk premium.  

There are several tools that I implement in executing the project for this repository, including:
- Python Pandas: cleaning and merging bonds yield data for different maturity time into single file (note: the creation of this Python Code is supported by ChatGPT),
- Power Query: Merging all cleansed bonds yield data for 25 countries
- MS SQL Server: Main Relational Database Management Systems (RDBMS) for devising the database.  

Further, in devising Database Model for World Government Bonds Yield Data Warehouse, author employed Galaxy Schema (also known as Fact Constellation Schema) , where two different fact tables share common dimension tables. The Diagram of Database Model can be observed through this picture below.  

**Figure 1. Database Model Diagram for World Government Bonds Yield**
<img width="2710" height="2056" alt="World Government Bonds_Database Model" src="https://github.com/user-attachments/assets/db676194-7c8b-4a60-bdc6-69c471f367ee" />  

## 🏗️ Chapter II: Medallion Database Architecture
To create this Galaxy Schema, this repository implements Medallion Data Modelling, where three steps are utilized to model a database, namely Bronze Layer, Silver Layer, and Golder Layer. Specifically, each layer can be examined as follows:  
- Bronze Layer: This layer encapsulates all raw data from data sources utilized for devising this database, such as investing.com .csv files for fact tables
- Silver Layer: In this layer, all raw data are cleansed and become interpretable-ready data for both fact and dimension tables
- Golder Layer: Within this layer, all cleansed data within prior layer are adjusted for business-specific purpose by creating additional column (such as moving averages in this case)
The conceptual framework of Medallion Architecture can be presented as follows:
**Figure 2. Medallion Architecture Conceptual Framework**
<img width="1920" height="1080" alt="Screenshot (604)" src="https://github.com/user-attachments/assets/721cb5a0-9eaf-401c-a3b1-f76248b6347a" />  

## 🖥️ Chapter III: Harnessing The Database
Users can utilize this database to answer diverse questions regarding Global Government Bonds Market, such as the spread between Indonesia's 10-year government bonds yield and US 10-year one. Furthermore, this database can also be employed to perform various data-related activities, including:  
- Visualizing Time Series for particular bonds yield of a country in order to observe its trajectory;
- Performing Machine Learning (ML) Model to predict future bonds movement;
- Executing Statistical analysis, such as hypothesis testing.

### 📓 Note
Henceforth, I will create an Exploratory Data Analysis (EDA) by Employing R Programming and Quarto, Alongside Presentation file for further details regarding this database.
