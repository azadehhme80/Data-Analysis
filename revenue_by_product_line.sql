-- Analyzing Motorcycle Part Sales
/* Working on behalf of a company that sells motorcycle parts, we'll dig into their data to help them understand their revenue streams. We'll build up a query to find out how much net revenue they are generating across their product lines, segregating by date and warehouse.

The query should contain the following:
product_line,
month: displayed as 'June', 'July', and 'August',
warehouse, and
net_revenue: the sum of total minus the sum of payment_fee.
The results should be sorted by product_line and month, followed by net_revenue in descending order.
*/



-- one approach to write a correct month is to use to_char() function: 

select	product_line,
		to_char(date,'FMMONTH') as month,
		warehouse,
		-- net revenue by calculating the sum of total minus the sum of payment_fee
		sum(total- payment_fee) as net_revenue
from public.sales
where client_type = 'Wholesale'
group by month, warehouse, public.sales.product_line
-- sorting by column numbers
order by 1,2,3 desc
;

-- Notice that the query above gives the full month name, without ''.
-- If you insist on have the months as 'june', 'july',... you can use CASE and EXTRACT functions as follows:

SELECT product_line,
    CASE WHEN EXTRACT('month' from date) = 6 THEN 'June'
        WHEN EXTRACT('month' from date) = 7 THEN 'July'
        WHEN EXTRACT('month' from date) = 8 THEN 'August'
    END as month,
    warehouse,
	SUM(total) - SUM(payment_fee) AS net_revenue
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY product_line, warehouse, month
ORDER BY product_line, month, net_revenue DESC