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