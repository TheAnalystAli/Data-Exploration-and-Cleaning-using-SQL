SELECT * FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4;

--SELECT * FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4;

--selecting data that i am going to use:

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;

--looking at total deaths vs total cases:
--shows likelihood of dying if you contract covid in your country:

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Pakistan'
ORDER BY 1, 2;

--looking at total cases vs population:
--showing what percentage of population got covid:

SELECT location, date, total_cases, population, (total_cases/population)*100 AS ppl_getting_covid
FROM PortfolioProject..CovidDeaths
WHERE location = 'Pakistan'
ORDER BY 1, 2;

--looking at country with highest infection rate compared to population:

SELECT location,  MAX(total_cases) AS highest_infectionrate, population,MAX((total_cases/population))*100 AS ppl_getting_covid
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Pakistan'
GROUP BY location, population
ORDER BY ppl_getting_covid desc;

--showing country with highest death count per population:

SELECT location, MAX(CAST(total_deaths as int)) AS Total_deathcount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Pakistan'
WHERE continent is not null
GROUP BY location
ORDER BY Total_deathcount desc;

--let's break thingsdown by continent:
--showing continent with the highest death count ratio:

SELECT continent, MAX(CAST(total_deaths as int)) AS Total_deathcount
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Pakistan'
WHERE continent is not null
GROUP BY continent
ORDER BY Total_deathcount desc;

--global numbers:

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS deathpercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--moving on to the next table covidvaccination:
--looking at total population vs vaccination:

SELECT * FROM PortfolioProject..CovidVaccinations;

SELECT * FROM PortfolioProject..CovidVaccinations vac
JOIN PortfolioProject..CovidDeaths dea
ON dea.location=vac.location
AND dea.date=vac.date;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS AddingPeopleVaccinated
FROM PortfolioProject..CovidVaccinations vac
JOIN PortfolioProject..CovidDeaths dea
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 2,3