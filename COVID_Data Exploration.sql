select * 
from [Portfolio]..CovidDeaths
where continent is not null
order by continent,location,date

select * 
from Portfolio..covidvaccinations
where continent is not null
and location like '%egypt%'
order by 2,3,4


-- Total Cases vs Population
select continent,location,date,total_cases,population,
round((total_cases/population)*100,3) as InfectedPopulation_persentage
	
from [Portfolio]..CovidDeaths
where continent is not null
order by 1,2,3


-- Total Deaths vs Total Cases
select continent,location,date,total_cases,total_deaths,
round((total_deaths /total_cases)*100,2) as dethOverCases
	
from [Portfolio]..CovidDeaths
where continent is not null
order by 1,2,3


--Countries with Highest Infection Rate -- Total Cases vs Population
select continent,location,population ,max(total_cases)as total_cases ,
round(max((total_cases/population)*100),3) as InfectedPopulation_persentage

from [Portfolio]..CovidDeaths
where continent is not null
group by continent,location,population
order by InfectedPopulation_persentage desc


--Countries with Highest Deaths Rate --  Total Deaths vs Total Cases 
select continent,location,MAX(total_cases)as total_cases,MAX(cast(total_deaths as int)) as total_deaths,
round((MAX(cast(total_deaths as int))/MAX(total_cases))*100,2) as dethOverCases

from [Portfolio]..CovidDeaths
where continent is not null
group by continent,location
order by dethOverCases desc



--continents with Highest Infection Rate -- Total Cases vs Population
select continent,MAX(population)as population ,max(total_cases)as total_cases ,
round(max((total_cases/population)*100),3) as InfectedPopulation_persentage

from [Portfolio]..CovidDeaths
where continent is not null
group by continent
order by InfectedPopulation_persentage desc

--continents with Highest Deaths Rate --  Total Deaths vs Total Cases 
Select continent,MAX(total_cases)as total_cases, MAX(cast(Total_deaths as int)) as TotalDeath,
round((MAX(cast(total_deaths as int))/MAX(total_cases))*100,2) as dethOverCases

From [Portfolio]..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeath desc



-- Total Deaths vs Total Cases accros the whole world over time
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
round(SUM(cast(new_deaths as int))/SUM(New_Cases)*100,3) as DeathPercentage
 
From [Portfolio]..CovidDeaths
where continent is not null 
Group By date
order by 1

--Total Deaths vs Total Cases accros the whole world
Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
round(SUM(cast(new_deaths as int))/SUM(New_Cases)*100,3) as DeathPercentage
 
From [Portfolio]..CovidDeaths
where continent is not null 


--join

Select *

From [Portfolio]..CovidDeaths dea
Join [Portfolio]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3,4


--	Population vs Total Vaccinations with Partition by and CTE

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio]..CovidDeaths dea
Join [Portfolio]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3 

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio]..CovidDeaths dea
Join [Portfolio]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac





--		another way to do it 
--	Population vs Total Vaccinations with subquery and temb table (don't recommend it)

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       (SELECT SUM(CONVERT(int, vac2.new_vaccinations))
        FROM [Portfolio]..CovidVaccinations vac2
        WHERE vac2.location = vac.location
          AND vac2.date <= dea.date
       ) AS RollingPeopleVaccinated
INTO #TempResults
FROM [Portfolio]..CovidDeaths dea
JOIN [Portfolio]..CovidVaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *, (RollingPeopleVaccinated/Population)*100 AS PercentageVaccinated
FROM #TempResults
ORDER BY location, date;

DROP TABLE #TempResults;

-- Creating Views for visualizations

Create View  PopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations,
round((vac.total_vaccinations/dea.population)*100,3) as vaccinatedPopulation_persentage

From [Portfolio]..CovidDeaths dea
Join [Portfolio]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


create view deathsOverCases as
select continent,location,date,total_cases,total_deaths,
round((total_deaths /total_cases)*100,2) as dethOverCases
	
from [Portfolio]..CovidDeaths
where continent is not null