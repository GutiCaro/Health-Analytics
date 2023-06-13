--Exploring Global data on COVID deaths and vaccinations.
--Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types--

Select *
FROM coviddeaths
WHERE continent is not NULL
order by 3,4 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
 ORDER BY 1,2 

 --Total cases vs total deaths 
 --Shows likelihood of dying from COVID in The United States
 
SELECT
location, date, total_cases, total_deaths, (CAST(total_deaths AS float) /total_cases)*100 AS DeathPercentage
FROM Coviddeaths
WHERE location like '%states%' 
ORDER by 1,2 

--Total cases vs population (what percentage of the US population got COVID?)

SELECT
location, date, population, total_cases, (CAST (total_cases AS float)/ CAST(population AS float))*100 AS CasePercentage
FROM Coviddeaths
WHERE location like '%states%' 
ORDER by 1,2 

--Find the countries with the highest infection rates compared to population

SELECT
location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases / CAST(population AS float))*100 AS PercentPopulationInfected
FROM Coviddeaths 
GROUP BY location, population 
ORDER by PercentPopulationInfected DESC

--Find countries with highest death count per popluation

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths
WHERE Continent is NOT NULL
Group BY Location, Population
ORDER BY TotalDeathCount DESC

--Find continents with highest death count 

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths
WHERE Continent is null
GROUP BY location 
ORDER BY TotalDeathCount DESC

--Global Numbers (deathpercentage across the world)

SELECT date, SUM(new_cases) AS totalcases, SUM(new_deaths) as totaldeaths, SUM(new_deaths)/SUM(CONVERT(float,new_cases))*100 AS DeathPercentage
FROM coviddeaths 
WHERE continent is not null
GROUP BY date
order by 1,2 

--Total of entire chart(dates not included)

SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) as Total_Deaths, SUM(new_deaths)/SUM(cast(new_cases as float))*100 AS DeathPercentage
FROM coviddeaths 
WHERE continent is not null
order by 1,2 


--Join tables

SELECT *
FROM coviddeaths Dea
JOIN vaccinations Vac
    ON dea.location =vac.location AND
     dea.date = vac.date

--Population vs Vaccinations
--Exploring percent of population that has received at least one dose of the COVID vaccine

SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinatedCount
FROM coviddeaths dea
JOIN vaccinations Vac
    ON dea.location =vac.location AND
     dea.date = vac.date
     WHERE dea.continent is not null 
     ORDER By 2,3 

--Use CTE to perform calculations using pervious query

WITH PopVsVac (Continent, Location, Date, population, new_vaccinations, RollingVaccinatedCount)
AS
(
SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinatedCount
FROM coviddeaths dea
JOIN vaccinations Vac
    ON dea.location =vac.location AND
     dea.date = vac.date
     WHERE dea.continent is not null 
     )

     SELECT *, (CAST(RollingVaccinatedCount AS float)/population)*100 AS PercentOfPopVaccinated
     From PopVsVac 
    ORDER By 2,3 
GO 

--Create view to use in Tableau later

CREATE VIEW PopVsVac
 AS
    SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinatedCount
FROM coviddeaths dea
JOIN vaccinations Vac
    ON dea.location =vac.location AND
     dea.date = vac.date
     WHERE dea.continent is not null 

