/* Project Description

How have American baby name tastes changed since 1920? Which names have remained popular for over 100 years, and how do those names compare to more recent top baby names? 

We'll be working with data provided by the United States Social Security Administration, which lists first names along with the number and sex of babies they were given to in each year. For processing speed purposes, we've limited the dataset to first names which were given to over 5,000 American babies in a given year. Our data spans 101 years, from 1920 through 2020.

The ranking, grouping, joining, ordering, and pattern matching skills we'll use in this project are broadly applicable: understanding changing tastes is a key competency for businesses as well as parents searching for a baby name!

PREREQUISITES
Data Manipulation in SQL
Joining Data in SQL

*/

-- Let's get oriented to American baby name tastes by looking at the names that have stood the test of time!

-- Select first names and the total babies with that first_name
-- Group by first_name and filter for those names that appear in all 101 years
-- Order by the total number of babies with that first_name, descending


SELECT first_name, sum(num)
FROM baby_names
group by first_name
having count(year) =101
order by sum(num) desc


/* Was the name classic and popular across many years or trendy, only popular for a few years? Let's find out: 
Classify each name's popularity according to the number of years that the name appears in the dataset.

Select first_name, the sum of babies who've ever been given that name, and popularity_type.
Classify all names in the dataset as 'Classic,' 'Semi-classic,' 'Semi-trendy,' or 'Trendy' based on whether the name appears in the dataset more than 80, 50, 20, or 0 times, respectively.
Alias the new classification column as popularity_type.
Order the results alphabetically by first_name
*/

select first_name,
       sum(num) as sum ,
       case when count(year)>80 then 'Classic' 
            when count(year)>50 then 'Semi-classic' 
            when count(year)>20 then 'Semi-trendy' else 
            'Trendy' end as popularity_type
FROM baby_names 
Group by first_name
order by first_name asc


/* let's limit our search to names which were given to female babies. We can use window function Rank() Over() by assigning a rank to female names based on the number of babies with that name*/

-- RANK names by the sum of babies who have ever had that name (descending), aliasing as name_rank
-- Select name_rank, first_name, and the sum of babies who have ever had that name
-- Filter the data for results where sex equals 'F'
-- Limit to ten results


Select first_name,
     rank() over(order by sum(num) desc) name_rank,
       sum(num)          
from baby_names
where sex ='F'
group by first_name
limit 10;

/* Now we want traditionally female name ending in the letter 'a'  also a name that has been popular in the years since 2015.

-- Select only the first_name column
-- Filter for results where sex is 'F', year is greater than 2015, and first_name ends in 'a'
-- Group by first_name and order by the total number of babies given that first_name

*/

select first_name
from baby_names
where sex = 'F' and 
                    year > 2015 and
                                first_name like '%a' 
group by first_name
order by sum(num) desc
;

/*
Based on the results in the previous task, we can see that Olivia is the most popular female name ending in 'A' since 2015. When did the name Olivia become so popular?

Let's explore the rise of the name Olivia with the help of a window function.
-- Select year, first_name, num of Olivias in that year, and cumulative_olivias
-- Sum the cumulative babies who have been named Olivia up to that year; alias as cumulative_olivias
-- Filter so that only data for the name Olivia is returned.
-- Order by year from the earliest year to most recent
*/

select   first_name, year,
         num,
         sum(num) over( order by year asc) cumulative_olivias 
from baby_names
where  first_name= 'Olivia'

/*
what is the most popular male name for each year?
This is a tricky question, the best approach is to use self join and sub query:
-- first we find the maximum number of babies for each year, regardless of the first name
-- then retrieve the corresponding first name associated with that maximum number of babies for each year.
*/

SELECT b.year, b.first_name, b.num
FROM baby_names AS b
-- The subquery retrieves the maximum number of babies for each year for male names.
INNER JOIN (
    SELECT year, MAX(num) as max_num
    FROM baby_names
    WHERE sex = 'M'
    GROUP BY year
) AS subquery 
ON subquery.year = b.year --filtering out only the most popular name for each year.
    AND subquery.max_num = b.num 
WHERE b.sex = 'M'  -- Filter only male names
ORDER BY b.year DESC;  -- Order by year descending


/*
Now let's explore Which name has been number one for the largest number of years?
-- Select first_name and a count of years it was the top name in the last task; 
-- Use the code from the previous task as a common table expressin
-- Group by first_name and order by count_top_name descending

*/

WITH cte1 as
(SELECT b.year, b.first_name, b.num
FROM baby_names AS b
INNER JOIN (
    SELECT year, MAX(num) as max_num
    FROM baby_names
    WHERE sex = 'M'
    GROUP BY year
) AS subquery 
ON subquery.year = b.year 
    AND subquery.max_num = b.num
WHERE b.sex = 'M'  
ORDER BY b.year DESC  )

select first_name,
       count(year) as count_top_name
from cte1
group by first_name
order by count_top_name desc
;

