select *
from CovidProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from CovidProject..CovidVaccination
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from CovidProject..CovidDeaths
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths
WHERE location LIKE '%india%'
order by 1,2


select location,date,population,total_cases,(total_cases/population)*100 as DeathPercentage
from CovidProject..CovidDeaths
WHERE location LIKE '%india%'
order by 1,2


select location,max(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths
where continent is not null
--group by date
order by 1,2



select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from CovidDeaths cd
join CovidProject..CovidVaccination cv
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null
order by 2,3

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from CovidProject..CovidDeaths cd
join CovidProject..CovidVaccination cv
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac


create view percentpopulationvaccinated as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
, sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from CovidProject..CovidDeaths cd
join CovidProject..CovidVaccination cv
	on cd.location=cv.location
	and cd.date=cv.date
where cd.continent is not null



