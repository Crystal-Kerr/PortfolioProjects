Select *
From PortfolioProject..CovidDeaths
where continent is not null



Select location, date, total_cases, new_cases, total_deaths, population_density
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2



-- Shows Likelihood of dying if you contract covid in The United States

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Showing What Percentage of Population Contracted Covid

Select location, date, population_density, total_cases, (total_cases/population_density)*100 as CovidContractedPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--Looking a Countries with Highest Infection Rate Compared to Population

Select location, population_density, Max(total_cases) as HighestInfectionCount, Max((total_cases/population_density))*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
where continent is not null
Group by location, population_density
order by PercentagePopulationInfected desc


-- Showing Countries With Highest Death Count

Select location, Max(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Group by location
order by TotalDeathCount desc



-- Showing Continents With the Highest Death Counts

Select continent, Max(Total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc


-- Global Numbers

Select Max(new_cases) as Total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2



-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, Sum(Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
(
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, Sum(Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
 



 -- TEMP TABLE

 Drop Table if exists #PercentagePopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccination numeric,
 RollingPeopleVaccinated numeric
 )

 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, Sum(Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to Store Data for Later Visalization

Create View PercentPopulationVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, Sum(Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null