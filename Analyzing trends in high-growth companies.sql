/*
Did you know that the average return from investing in stocks is 10% per year (not accounting for inflation)? But who wants to be average?!

You have been asked to support an investment firm by analyzing trends in high-growth companies. They are interested in understanding which industries are producing the highest valuations and the rate at which new high-value companies are emerging. Providing them with this information gives them a competitive insight as to industry trends and how they should structure their portfolio looking forward.

You have been given access to their `unicorns` database, which contains the following tables:

## dates
| Column       | Description                                  |
|------------- |--------------------------------------------- |
| `company_id`   | A unique ID for the company.                 |
| `date_joined` | The date that the company became a unicorn.  |
| `year_founded` | The year that the company was founded.       |

## funding
| Column           | Description                                  |
|----------------- |--------------------------------------------- |
| `company_id`       | A unique ID for the company.                 |
| `valuation`        | Company value in US dollars.                 |
| `funding`          | The amount of funding raised in US dollars.  |
| `select_investors` | A list of key investors in the company.      |

## industries
| Column       | Description                                  |
|------------- |--------------------------------------------- |
| `company_id`   | A unique ID for the company.                 |
| `industry`     | The industry that the company operates in.   |

## companies
| Column       | Description                                       |
|------------- |-------------------------------------------------- |
| `company_id`   | A unique ID for the company.                      |
| `company`      | The name of the company.                          |
| `city`         | The city where the company is headquartered.      |
| `country`      | The country where the company is headquartered.   |
| `continent`    | The continent where the company is headquartered. |
*/

-- create the best performing industries 2019, 2020, and 2021
/* Your SQL query is aimed at identifying the top industries with the most unicorns (companies) and their average valuations over the years 2019, 2020, and 2021. Here’s a step-by-step breakdown and a few improvements to ensure accuracy and performance:

Setep 1: Top Industries CTE: This part determines the top 3 industries based on the count of companies that joined in 2019, 2020, or 2021. */

WITH top_ind AS (
    SELECT i.industry, 
           COUNT(*) AS num_new
    FROM industries i 
    INNER JOIN dates d
    ON i.company_id = d.company_id
    WHERE EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
    GROUP BY i.industry
    ORDER BY num_new DESC
    LIMIT 3
),
--Setep2: Yearly Rankings CTE: This part calculates the number of unicorns, the average valuation, and the year for each industry.
yearly_ranking AS (
    SELECT 
        COUNT(*) AS num_unicorns,
        i.industry,
        EXTRACT(YEAR FROM d.date_joined) AS year,
        AVG(f.valuation) AS avg_num
    FROM industries AS i
    INNER JOIN dates AS d
        ON i.company_id = d.company_id
    INNER JOIN funding AS f
        ON d.company_id = f.company_id
    GROUP BY i.industry, year
)
-- Setep 3: Final Select: This part filters the yearly rankings to include only the top industries and the relevant years, formatting the average valuation in billions.
SELECT 
    yr.industry,
    yr.year,
    yr.num_unicorns,
    ROUND(yr.avg_num / 1000000000, 2) AS average_valuation_billions
FROM yearly_ranking yr
WHERE yr.industry IN (
    SELECT ti.industry FROM top_ind ti
)
AND yr.year IN (2019, 2020, 2021)
ORDER BY yr.year desc, yr.num_unicorns DESC;