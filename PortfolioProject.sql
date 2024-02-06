Select * 
From PortfolioProject.Coviddeaths
Where Continent is not null
Order by Total_Deaths Desc;


-- Likelihood of dying of contracting Covid-19 --
Select Location, date, Total_Cases, Total_Deaths, (Total_Deaths/Total_Cases)*100 as DeathPercentage
From PortfolioProject.CovidDeaths
Where Location Like '%States%'
Order by 1,3;

-- Looking at the total cases vs the Population --
Select Location, date, Total_Cases, Population, (Total_Cases/Population)*100 as PercentofPopulationInfected
From PortfolioProject.CovidDeaths
Where Location Like '%States%'
Order by 1,3;
-- What Country has the highest infected rate Vs Population --
Select Location, Population, Max(Total_Cases) as HighestInfectedCount, (Max(Total_Cases)/Population)*100 as PercentofPopulationInfected
From PortfolioProject.CovidDeaths
-- Where Location Like '%States%'
Group By Location, Population
Order by 4 Desc;

-- Showing the countries with highest Death Count --
Select Location, Max(Cast(Total_Deaths as signed)) as TotalDeathCount
From PortfolioProject.CovidDeaths
-- Where Location Like '%States%'
Where continent is not null
Group By Location
Order by TotalDeathCount Desc;

-- Break it down by Continent -- 
Select Continent, Max(Cast(Total_Deaths as signed)) as TotalDeathCount
From PortfolioProject.CovidDeaths
-- Where Location Like '%States%'
Where continent is not null
Group By Continent
Order by TotalDeathCount Desc;

-- Global Numbers
Select Sum(New_Cases) as total_cases, Sum(Cast(New_Deaths as signed)) as Total_Deaths, Sum(Cast(New_Deaths as signed))/Sum(New_cases)*100 as DeathPercentage
From PortfolioProject.CovidDeaths
-- Where Location Like '%States%'
Where continent is not null
-- Group by Date
Order by 3,1;

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, Sum(Vac.New_Vaccinations) Over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
From PortfolioProject.CovidDeaths as Dea
Join PortfolioProject.CovidVaccinations as Vac
On Dea.Location = Vac.Location
And Dea.Date = Vac.Date
Where Dea.Continent is not null
Order by 2,3;

-- USE CTE
With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as (
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, Sum(Vac.New_Vaccinations) Over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
From PortfolioProject.CovidDeaths as Dea
Join PortfolioProject.CovidVaccinations as Vac
On Dea.Location = Vac.Location
And Dea.Date = Vac.Date
Where Dea.Ct is not null
-- Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac;

-- Temp Table
Drop Table if exists PortfolioProject.PercentPopulationVaccinated;
Create Temporary Table PortfolioProject.PercentPopulationVaccinated
(Continent Text, Location Text, Date Text, Population Text, New_Vaccinations Text, RollingPeopleVaccinated Text);
Insert Into PortfolioProject.PercentPopulationVaccinated
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, Sum(Vac.New_Vaccinations) Over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
From PortfolioProject.CovidDeaths as Dea
Join PortfolioProject.CovidVaccinations as Vac
On Dea.Location = Vac.Location
And Dea.Date = Vac.Date
Where Dea.Continent is not null;
-- Order by 2,3
Select * , (RollingPeopleVaccinated/Population)*100
From PortfolioProject.PercentPopulationVaccinated;

-- Creating View to store data for later

Create View PortfolioProject.PercentPopulationVaccinated as 
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, Sum(Vac.New_Vaccinations) Over (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
From PortfolioProject.CovidDeaths as Dea
Join PortfolioProject.CovidVaccinations as Vac
On Dea.Location = Vac.Location
And Dea.Date = Vac.Date
Where Dea.Continent is not null
-- Order by 2,3

