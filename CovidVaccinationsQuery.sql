SELECT *
FROM CovidAnalysisProject..CovidDeaths
ORDER BY 3, 4;

-- Continent with highest death count per population

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM CovidAnalysisProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- Global Numbers
SELECT date, 
	SUM(new_cases) AS GlobalCases, 
	SUM(CAST(new_deaths AS INT)) AS GlobalDeaths, 
	ROUND(SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100, 2) AS DeathRate
FROM CovidAnalysisProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1;


/************************
	Covid Vaccinations
************************/


SELECT *
FROM CovidAnalysisProject..CovidVaccinations
ORDER BY 3, 4;


-- USE CTE
WITH PopuVsVacc (Continent, Location, Date, Population, New_Vaccinations, RolllingPeopleVaccinated)
AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	SUM(CONVERT(BIGINT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) 
	AS RollingPeopleVaccinated
FROM CovidAnalysisProject..CovidDeaths AS cd
JOIN CovidAnalysisProject..CovidVaccinations AS cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
--ORDER BY 2, 3
)
SELECT *, ROUND((RolllingPeopleVaccinated/Population)*100, 2) AS VaccinationRate
FROM PopuVsVacc
WHERE Location = 'India';


-- Let's USE TEMP TABLE
DROP TABLE IF EXISTS #VaccinationRate
CREATE TABLE #VaccinationRate
(Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_Vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC,
)

INSERT INTO #VaccinationRate
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	SUM(CONVERT(BIGINT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) 
	AS RollingPeopleVaccinated
FROM CovidAnalysisProject..CovidDeaths AS cd
JOIN CovidAnalysisProject..CovidVaccinations AS cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL


SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationRate
FROM #VaccinationRate
WHERE Location = 'India';


-- Creating View to store data for later visualization
CREATE VIEW VaccinationRate AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	SUM(CONVERT(BIGINT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) 
	AS RollingPeopleVaccinated
FROM CovidAnalysisProject..CovidDeaths AS cd
JOIN CovidAnalysisProject..CovidVaccinations AS cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
--ORDER BY 2, 3