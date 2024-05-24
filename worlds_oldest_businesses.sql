/*An important part of business is planning for the future and ensuring that the company survives changing market conditions. Some businesses do this really well and last for hundreds of years.

BusinessFinancing.co.uk researched the oldest company that is still in business in (almost) every country and compiled the results into a dataset. In this project, you'll explore that dataset to see what they found.

The database contains three tables.

categories
businesses
countries 
*/

--Let's -- Select the oldest and newest founding years from the businesses table
​
select min(year_founded) as min,
       max(year_founded)  as max
from businesses
​

​
-- How many businesses were founded before 1000?
​
select count(*)
from businesses
where year_founded < 1000

​
-- Select all columns from businesses where the founding year was before 1000
-- Arrange the results from oldest to newest
select *
from businesses
where year_founded < 1000
order by year_founded asc
 
​
-- Select business name, founding year, and country code from businesses; and category from categories
-- where the founding year was before 1000, arranged from oldest to newest
SELECT b.business,
       b.year_founded,
       b.country_code,
       c.category 
from businesses b
    join categories c on b.category_code = c.category_code
WHERE  b.year_founded < 1000
ORDER BY 2 ASC ;
 ​
-- Select the category and count of category (as "n")
-- arranged by descending count, limited to 10 most common categories
SELECT  c.category,
        COUNT(c.category) n
FROM categories c
join businesses b on b.category_code = c.category_code
 
group by c.category
order by n desc
limit 10;
 * postgresql:///oldestbusinesses
10 rows affected.
category	n
Banking & Finance	37
Distillers, Vintners, & Breweries	22
Aviation & Transport	19
Postal Service	16
Manufacturing & Production	15
Media	7
Agriculture	6
Cafés, Restaurants & Bars	6
Food & Beverages	6
Tourism & Hotels	4
6. Oldest business by continent
It looks like "Banking & Finance" is the most popular category. Maybe that's where you should aim if you want to start a thousand-year business.

One thing we haven't looked at yet is where in the world these really old businesses are. To answer these questions, we'll need to join the businesses table to the countries table. Let's start by asking how old the oldest business is on each continent.

%%sql
​
-- Select the oldest founding year (as "oldest")from businesses, 
-- and continent from countries
-- for each continent, ordered from oldest to newest 
​
select min(year_founded) as oldest,
       continent
from businesses b join countries c
on b.country_code=c.country_code
group by continent
order by oldest asc
​
        

​
-- Select .business, founding year, category, country, and continent
select
    business,
    year_founded ,
    category,
    country,
    continent
from businesses b
join categories c on  b.category_code = c.category_code 
join countries t on b.country_code = t.country_code
​
 
 ​
-- Count the number of businesses in each continent and category
​
select
   continent, category, count(business) as n
    
    from businesses b
join categories c on  b.category_code = c.category_code 
join countries t on b.country_code = t.country_code
​
group by t.continent, c.category
​
 ​
-- Repeat that previous query, filtering for results having a count greater than 5
​
​
select
   continent, category, count(business) as n
    
from businesses b
join categories c on  b.category_code = c.category_code 
join countries t on b.country_code = t.country_code
​
group by t.continent, c.category
having count(business) >5
order by 3 desc
 