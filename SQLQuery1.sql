select * from [Portfolio project]..['owid-covid-data update 1$']
where continent is not null
order by 3,4

--select * from [Portfolio project]..['owid-covid-data update 2$']
--order by 3,4
select location,date,total_cases, new_cases,total_deaths,population
from [Portfolio project]..['owid-covid-data update 1$']
where continent is not null
order by 1,2

--Looking at total cases vs total deaths
--shows likelihood of dying of covid in india
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio project]..['owid-covid-data update 1$']
where location like '%india%'
order by 1,2

--Looking at toatl cases vs poopulation
--shows what percentaged of population got covid
select location,date,population,total_cases,(total_deaths/population)*100 as DeathPercentage
from [Portfolio project]..['owid-covid-data update 1$']
where location like '%india%'
order by 1,2

--Looking at countries with highest percentage rate compared to population
select location,population,max(total_cases) as Highestinfectioncount,max((total_cases/population))*100 as percentagepopulationinfected
from [Portfolio project]..['owid-covid-data update 1$']
--where location like '%india%'
group by location , population
order by percentagepopulationinfected desc

--showing the countreis with highest death per population
select location,max(cast(total_deaths as int)) as totaldeathcount
from [Portfolio project]..['owid-covid-data update 1$']
--where location like '%india%'
where continent is null
group by location
order by totaldeathcount desc

--now in terms of continent
select continent,max(cast(total_deaths as int)) as totaldeathcount
from [Portfolio project]..['owid-covid-data update 1$']
--where location like '%india%'
where continent is not null
group by continent
order by totaldeathcount desc

--showning continents with hightest death count per population
select continent,max(cast(total_deaths as int)) as totaldeathcount
from [Portfolio project]..['owid-covid-data update 1$']
--where location like '%india%'
where continent is not null
group by continent
order by totaldeathcount desc

--global numbers
select sum(new_cases) as totalnewcases,sum(cast (new_deaths as int)) as totalnewdeaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio project]..['owid-covid-data update 1$']
where continent is not null
--group by date
order by 1,2

--looking at poopulation vs vaccinations
--adding new_vaccinations with old one(see albania for exmple

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from [Portfolio project]..['covid vaccination$'] vac
join [Portfolio project]..['owid-covid-data update 1$'] dea
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--creating new table to find percentage of total people vaccinated, we  cannot find 
--total people vacccinated in old table because we created rolling people vaccinated in that table

with PopvsVac (contitnent , location,date,population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from [Portfolio project]..['covid vaccination$'] vac
join [Portfolio project]..['owid-covid-data update 1$'] dea
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null 
--order by 2,3 (remove it because it will cause an error)
)
select * ,(rollingpeoplevaccinated/population)*100
from PopvsVac


-- temp table

DROP Table if exists #percentagepopulationvaccinated
Create table #percentagepopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
rollingpeoplevaccinated numeric
)
Insert into #percentagepopulationvaccinated
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from [Portfolio project]..['covid vaccination$'] vac
join [Portfolio project]..['owid-covid-data update 1$'] dea
on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3 (remove it because it will cause an error)

select *,(rollingpeoplevaccinated/population)*100
from #percentagepopulationvaccinated

--creating view to store data for visualization

create view percentagepopulationvaccinated as 
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from [Portfolio project]..['covid vaccination$'] vac
join [Portfolio project]..['owid-covid-data update 1$'] dea
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * from percentagepopulationvaccinated