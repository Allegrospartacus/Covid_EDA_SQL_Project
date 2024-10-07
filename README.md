# Covid_EDA_SQL_Project
Exploratory Data Analysis of Covid-19 Cases, Deaths, and Vaccinations using SQL.

This project performs an exploratory data analysis (EDA) on Covid-19 data using SQL. 
It covers infection rates, death rates, and vaccination trends across different continents and countries.

## Datasets Used
- CovidDeaths: Contains data on total cases, total deaths, population, and other Covid-19 statistics.

- CovidVaccinations: Contains data on total vaccinations, new vaccinations, and other vaccination statistics.

## SQL Queries
The following analysis is performed:
- Total Cases vs Population
- Total Deaths vs Total Cases
- Countries with the highest infection and death rates
- Continents with the highest infection and death rates
- Global numbers:Total Deaths vs Total Cases accros the whole world over time
- Population vs Vaccination progress
- Rolling vaccinations using `PARTITION BY` and `CTE`  and another way to do it using (subquery and temb table)
- Creating views for future visualization
