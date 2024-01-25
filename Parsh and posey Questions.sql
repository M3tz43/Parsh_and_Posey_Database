
/*Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name"*/

SELECT 
	a.name,
	s.name,
	r.name
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE r.name = 'Midwest';

/*Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.*/

SELECT 
	a.name,
	s.name,
	r.name
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE r.name = 'Midwest'AND s.name LIKE 'S%'
ORDER BY a.name;

/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity exceeds 100.
Your final table should have 3 columns: region name, account name, and unit price.
In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).*/

SELECT 
	r.name,
	a.name,
	o.total_amt_usd/(o.total+0.01) AS unit_price,
	o.standard_qty
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE o.standard_qty >100;

/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50.
Your final table should have 3 columns: region name, account name, and unit price.
Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).*/

SELECT 
	r.name,
	a.name,
	o.total_amt_usd/(o.total+0.01) AS unit_price,
	o.standard_qty
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE o.standard_qty >100 AND o.poster_qty>50
ORDER BY unit_price DESC;

/*Find all the orders that occurred in 2015.
Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.*/

SELECT 
	o.occurred_at,
	a.name,
	o.total,
	o.total_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2015-12-31';

/*What was the smallest order placed by each account in terms of total usd.
Provide only two columns - the account name and the total usd.
Order from smallest dollar amounts to largest.*/

SELECT 
	a.name,
	MIN(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY MIN(o.total_amt_usd);

/*Determine the number of times a particular channel was used in the web_events table for each region.
Your final table should have three columns - the region name, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.*/

SELECT 
	r.name,
	COUNT(w.channel)
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
ORDER BY COUNT(w.channel) DESC;

--Which accounts used facebook as a channel to contact customers more than 6 times?--

SELECT
	a.name,
	COUNT(w.channel)
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY a.name ,w.channel
HAVING w.channel = 'facebook' AND COUNT(w.channel) > 6;

--How many accounts have more than 20 orders?--

SELECT
	a.name,
	COUNT(o.id)
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
HAVING COUNT(o.id)>20;

--Which account used facebook most as a channel?--

SELECT
	a.name,
	COUNT(w.channel)
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY a.name ,w.channel
HAVING w.channel = 'facebook'
ORDER BY COUNT(w.channel) DESC
LIMIT 1;

--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?--

SELECT 
	DATE_TRUNC('month',o.occurred_at),
	SUM(gloss_amt_usd)
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 1;

--Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?--

SELECT 
	DATE_TRUNC('year',occurred_at),
	SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*We would like to understand 3 different levels of customers based on the amount associated with their purchases.
The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd only in 2016 and 2017.
Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level.
Order with the top spending customers listed first.*/

SELECT 
	a.name,
	SUM(o.total_amt_usd),
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'greater than 200,000'
		WHEN SUM(o.total_amt_usd) >= 100000 AND SUM(o.total_amt_usd) <= 200000 THEN 'between 200,000 and 100,000'
		ELSE 'under 100,000'
	END  AS Level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2017-12-31'
GROUP BY 1
ORDER BY 2 DESC;

/*We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales.
The middle group has any rep with more than 150 orders or 500000 in sales.
Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria.
Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!*/

SELECT 
	S.name,
	COUNT(*),
	SUM(o.total_amt_usd),
	CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 then 'Top'
		WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 then 'middle'
		ELSE 'Low'
	END
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 3 DESC;

/*What is the lifetime average amount spent in terms of total_amt_usd,
including only the companies that spent more per order, on average, than the average of all orders.*/

SELECT
	AVG(total_spent)
FROM 
		(SELECT 
			a.id,
			a.name acc_name,
			SUM(o.total_amt_usd) total_spent
		FROM accounts a
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY 1,2
		ORDER BY 3 DESC
		LIMIT 10);
		
--For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?--
		
SELECT
	a.name,
	w.channel,
	COUNT(*)
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY 1,2
HAVING A.name =
		(SELECT name
		 FROM 
		 	(SELECT
				a.id,
				a.name,
				SUM(o.total_amt_usd)
			FROM orders o
			JOIN accounts a
			ON o.account_id = a.id
			GROUP BY 1,2
			ORDER BY 3 DESC
			LIMIT 1))
ORDER BY 3 DESC;

--For the region with the largest (sum) of sales total_amt_usd, how many total orders were placed?--

SELECT 
	r.name,
	COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
         SELECT MAX(total_amt)
         FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                 FROM sales_reps s
                 JOIN accounts a
                 ON a.sales_rep_id = s.id
                 JOIN orders o
                 ON o.account_id = a.id
                 JOIN region r
                 ON r.id = s.region_id
                 GROUP BY r.name) sub);
				 
--How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?--

SELECT COUNT(*)
FROM (SELECT a.name
          FROM orders o
          JOIN accounts a
          ON a.id = o.account_id
          GROUP BY 1
          HAVING SUM(o.total) > (SELECT total 
                      FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                            FROM accounts a
                            JOIN orders o
                            ON o.account_id = a.id
                            GROUP BY 1
                            ORDER BY 2 DESC
                            LIMIT 1) inner_tab)
                );

--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.--

WITH t1 AS (
     SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY 1,2
      ORDER BY 3 DESC), 
t2 AS (
      SELECT region_name, MAX(total_amt) total_amt
      FROM t1
      GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

--For the region with the largest sales total_amt_usd, how many total orders were placed?--

WITH t1 AS (
      SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY r.name), 
t2 AS (
      SELECT MAX(total_amt)
      FROM t1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);

/*Use the accounts table to create two groups:
one group of company names that start with a number and a second group of those company names that start with a letter.
What proportion of company names start with a letter?*/

SELECT 
	SUM(num) nums,
	SUM(letter) letters
FROM (
	SELECT name ,
			CASE WHEN LEFT(UPPER(name),1) IN ('1','2','3','4','5','6','7','8','9','0')
			THEN 1 ELSE 0 END AS num,
			CASE WHEN LEFT(UPPER(name),1) NOT IN ('1','2','3','4','5','6','7','8','9','0')
			THEN 1 ELSE 0 END AS letter
	FROM accounts	
	)t1;

--What proportion of company names start with a vowel, and what percent start with anything else?--

SELECT
	SUM(vowel) vowels,
	SUM(other) others
FROM (
	SELECT name ,
	CASE WHEN LEFT(UPPER(name),1) IN ('A','O','I','E','U')
		THEN 1 ELSE 0 END AS vowel,
	CASE WHEN LEFT(UPPER(name),1) NOT IN ('A','O','I','E','U')
		THEN 1 ELSE 0 END AS other
	FROM accounts
	) t1;
	
--Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.--

SELECT 
	LEFT(primary_poc,POSITION( ' ' IN primary_poc) - 1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LENGTH(LEFT(primary_poc,POSITION( ' ' IN primary_poc) - 1))) last_name
FROM accounts;
--Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.--

SELECT 
	LEFT(name,POSITION( ' ' IN name) - 1) first_name,
	RIGHT(name, LENGTH(name) - LENGTH(LEFT(name,POSITION( ' ' IN name) - 1))) last_name
FROM sales_reps;

/*Each company in the accounts table wants to create an email address for each primary_poc.
The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.*/

WITH t1 AS (
		SELECT 
	name company_name,
	LEFT(primary_poc,POSITION( ' ' IN primary_poc) - 1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LENGTH(LEFT(primary_poc,POSITION( ' ' IN primary_poc) - 1))-1) last_name
FROM accounts
)
SELECT
	CONCAT(first_name,'.',last_name,'@',company_name,'.com') email_address  
	FROM t1;
/*You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address.
See if you can create an email address that will work by removing all of the spaces in the account name*/

WITH t1 AS (
		SELECT 
	name company_name,
	LEFT(primary_poc,POSITION( ' ' IN primary_poc) - 1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LENGTH(LEFT(primary_poc,POSITION( ' ' IN primary_poc) - 1))-1) last_name
FROM accounts
)
SELECT
	CONCAT(first_name,'.',last_name,'@',REPLACE(t1.company_name,' ',''),'.com') email_address  
	FROM t1;
	
/*We would also like to create an initial password, which they will change after their first log in.
The first password will be the first letter of the primary_poc's first name (lowercase),
then the last letter of their first name (lowercase), the first letter of their last name (lowercase),
the last letter of their last name (lowercase),
the number of letters in their first name,
the number of letters in their last name,
and then the name of the company they are working with, all capitalized with no spaces.*/

WITH t1 AS (
		SELECT 
	name company_name,
	LEFT(primary_poc,POSITION( ' ' IN primary_poc) - 1) first_name,
	RIGHT(primary_poc, LENGTH(primary_poc) - LENGTH(LEFT(primary_poc,POSITION( ' ' IN primary_poc) - 1))-1) last_name
		FROM accounts
		),
t2 AS (
		SELECT 
			LEFT(LOWER(first_name),1) first_letter,
			RIGHT(LOWER(first_name),1) second_letter,
			LEFT(LOWER(last_name),1) third_letter,
			RIGHT(LOWER(last_name),1) forth_letter,
			LENGTH(first_name) length_first,
			LENGTH(last_name) length_last, 
			REPLACE(UPPER(company_name), ' ','') company
		FROM t1
)
SELECT CONCAT(first_letter,second_letter,third_letter,forth_letter,length_first,length_last,company) Password FROM t2;
