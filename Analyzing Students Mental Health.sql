/*
In the Analyzing Students' Mental Health in SQL project, we use  PostgreSQL skills to analyze the student data from a Japanese international university and spot one of the most influencing factors impacting the mental health of international students.

In this Project we focus on a specific contributing factor—the length of stay and how it impacts the average diagnostic scores of international students.

*/

select	stay,
-- Performing the calculations
		count(inter_dom) count_int,
		 Round(avg(todep),2) average_phq,
		 round(avg(tosc),2)  average_scs,
		 round(avg(toas),2) average_as
		 
from students
-- Creating the filter
where inter_dom ='Inter'
-- Grouping data
group by stay
--Ordering the resulting table in descending order of stay
order by stay desc
;
