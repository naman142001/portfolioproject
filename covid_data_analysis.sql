select * 
from portfolio_project.covid_death
where continent is not null
order by 3,4;

ALTER TABLE covid_death
MODIFY date date;  

/*select * 
from portfolio_project.covid_vaccinations
order by 3,4;*/

select location, date, total_cases, new_cases, total_deaths, population
from portfolio_project.covid_death;


-- looking at the total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from portfolio_project.covid_death;

-- total cases vs death percentage in India 

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from portfolio_project.covid_death
where location = "India";

-- total cases vs population 
-- what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as totalcase_percentage 
from portfolio_project.covid_death
where location = "India";

-- contries with the highest infection rate comapred to population 

select location, population, max(total_cases) as highest_infection_count , max((total_cases/population))*100 as max_population_infected  
from portfolio_project.covid_death
group by location, population
order by max_population_infected desc;

-- contries with highest death count per population

select location, population, max(cast(total_deaths as SIGNED)) as total_death_count   
from portfolio_project.covid_death
where continent is not null
group by location, population
order by total_death_count desc;

-- covid cases by continent 

select continent, max(cast(total_deaths as SIGNED)) as total_death_count   
from portfolio_project.covid_death
group by continent
order by total_death_count desc;

-- showing the continents with the highest death count
 
select continent, max(cast(total_deaths as SIGNED)) as maximum_death_count   
from portfolio_project.covid_death
group by continent
order by total_death_count desc;

-- global Numbers

select sum(new_cases) as total_cases , sum(cast(new_deaths as SIGNED)) as total_deaths, SUM(cast(new_deaths as Signed ))/sum(new_cases)*100 as death_percentage
from portfolio_project.covid_death 
where continent is not null
-- group by date
order by 1,2;

-- TOtal population VS vaccination
select DA.continent, DA.location, DA.date, DA.population, VAC.new_vaccinations,
sum(VAC.new_vaccinations) over (partition by DA.location order by DA.location, DA.date) as sum_of_people_vaccinated 
from portfolio_project.covid_death DA
join portfolio_project.covid_vaccinations VAC
on DA.location = VAC.location
and DA.date = VAC.date
where DA.continent is not null
order by 2,3;
 
-- use CTE

with popsvac (continent, location, date, population, sum_of_people_vaccinated, new_vaccinations)
as 
( select DA.continent, DA.location, DA.date, DA.population, VAC.new_vaccinations,
sum(VAC.new_vaccinations) over (partition by DA.location order by DA.location, DA.date) as sum_of_people_vaccinated 
from portfolio_project.covid_death DA
join portfolio_project.covid_vaccinations VAC
on DA.location = VAC.location
and DA.date = VAC.date
where DA.continent is not null
-- order by 2,3
)
select *, (new_vaccinations/population)*100
from popsvac;

-- creating view to store data later for vizulaization

create view popsvac as 
select DA.continent, DA.location, DA.date, DA.population, VAC.new_vaccinations,
sum(VAC.new_vaccinations) over (partition by DA.location order by DA.location, DA.date) as sum_of_people_vaccinated 
from portfolio_project.covid_death DA
join portfolio_project.covid_vaccinations VAC
on DA.location = VAC.location
and DA.date = VAC.date
where DA.continent is not null












