
--Select*
--From ProtfolioProject..CovidVaccinations
--order by 3,4

Select*
From ProtfolioProject..CovidDeaths
order by 3,4
-- select what I m going to do by data 
Select Location, Date, Total_cases, new_cases,total_deaths,population
From ProtfolioProject..CovidDeaths
order by 1,2

-- looking for total cases vs total deaths

Select Location, Date, Total_cases, total_deaths,(total_deaths/total_cases)*100 as deathPercentage
From ProtfolioProject..CovidDeaths
where location like 'mor%'
order by 1,2

-- Looking for total cases vs Population
-- Show the percentage of population got covid in morroco
Select Location, Date, Total_cases, population,(total_cases/Population)*100 as Percentageofpepole
From ProtfolioProject..CovidDeaths
--where location like 'mor%'
order by 1,2

--looking at countries whith Highest Infaction rate 
Select Location,  population ,max(total_cases) as Hightinfacion,max((total_cases/Population))*100 as Percentagehightinfaction
From ProtfolioProject..CovidDeaths
--where location like 'mor%'
Group by Location, population
order by Percentagehightinfaction desc

--Showing the countries whit highest death per population
Select Location,  population ,max(total_deaths) as HightDeaths,max((total_deaths/Population))*100 as PercentagehightDeaths
From ProtfolioProject..CovidDeaths
--where location like 'mor%'
Group by Location, population
order by PercentagehightDeaths desc
--Showing the countries with Highest Deaths Count per population
Select Location, Max(cast(Total_Deaths as int)) as TotalDeaths
From ProtfolioProject..CovidDeaths
where continent is not null
Group by Location
Order by TotalDeaths DESC

--Let's Break things down by continent

SELECT continent,Max(cast(Total_Deaths as int)) as TotalDeaths
From ProtfolioProject..CovidDeaths
where continent is not null
Group by continent
Order by TotalDeaths DESC


--GLOBAL NUMBER

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_Cases) *100 as DeathPercentage
from ProtfolioProject..CovidDeaths
where continent is not null
--Group by continent
Order by  1,2


-- Looking for Total population vs Total vactination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.Location, dea.date)
from ProtfolioProject..CovidDeaths dea
join ProtfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date=vac.date
where dea.continent is not null
  order by 2,3

  --USE CTE
  
  With PopvsVac (Contient, Location, date, population,new_vaccinations, RollingPepoleVaccinations)
  as
  (
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.Location, dea.date)
  as RollingPepoleVaccinations
from ProtfolioProject..CovidDeaths dea
join ProtfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date=vac.date
where dea.continent is not null
  )
  SELECT * ,(RollingPepoleVaccinations/population)*100 as PercontageofPepoleVaccinations
  From PopvsVac

  -- TEMP TABLE 
  DROP table If exists #PercentPopulationvactinated
  Create table #PercentPopulationvactinated
  (
  Continent nvarchar(255),
  Location nvarchar(255),
  date datetime,
  Population numeric,
  New_vaccination numeric,
  RollingPepoleVaccinations numeric
  )
  insert into #PercentPopulationvactinated
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.Location, dea.date)
  as RollingPepoleVaccinations
from ProtfolioProject..CovidDeaths dea
join ProtfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date=vac.date
--where dea.continent is not null

  SELECT * ,(RollingPepoleVaccinations/population)*100 
  From #PercentPopulationvactinated as PercentPopulationvactinated

  -- Create view 
  Create view PercentPopulationvactinated as 
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.Location, dea.date)
  as RollingPepoleVaccinations
from ProtfolioProject..CovidDeaths dea
join ProtfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date=vac.date
where dea.continent is not null

SELECT *
from PercentPopulationvactinated