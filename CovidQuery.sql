-- data includes continent in the location if continent column is null

SELECT *
FROM CovidAnalysisProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4; -- It means sort them in order of location and date

--SELECT *
--FROM CovidAnalysisProject..CovidVaccinations
--ORDER BY 3, 4;

-- Select Data that we are going to be using

SELECT location, date, new_cases, total_cases, total_deaths, population
FROM CovidAnalysisProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;


-- Total Cases Vs Total Deaths

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS DeathRate
FROM CovidAnalysisProject..CovidDeaths
WHERE location = 'India' AND continent IS NOT NULL
ORDER BY 1, 2;


-- Total Cases Vs Population

SELECT location, date, total_cases, population, ROUND((total_cases/population)*100, 2) AS CasesRate
FROM CovidAnalysisProject..CovidDeaths
WHERE continent IS NOT NULL
--WHERE location = 'India'
ORDER BY 1, 2;


-- Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, ROUND(MAX((total_cases/population)*100), 2) AS HighestInfectionRate
FROM CovidAnalysisProject..CovidDeaths
WHERE continent IS NOT NULL
--WHERE location = 'India'
GROUP BY location, population
ORDER BY HighestInfectionRate DESC;


-- Countries with Highest death count per population
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidAnalysisProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Continents
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidAnalysisProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;