---- ########################### SUM QUIZ ############################### ----

---- Aggregation Questions ----
---- Use the SQL environment below to find the solution for each of the following questions. If
---- you get stuck or want to check your answers, you can find the answers at the top of the 
---- next concept.

---- 1- Find the total amount of poster_qty paper ordered in the orders table. ----

SELECT SUM(poster_qty) AS total_poster_ordered
FROM orders;

---- 2- Find the total amount of standard_qty paper ordered in the orders table. ----

SELECT SUM(standard_qty) AS total_standard_ordered
FROM orders;

---- 3- Find the total dollar amount of sales using the total_amt_usd in the orders table. ----

SELECT SUM(total_amt_usd) AS total_usd
FROM orders;

---- 4- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in
----    the orders table. This should give a dollar amount for each order in the table.

SELECT (standard_amt_usd + gloss_amt_usd) sum_standard_plus_gloss_usd
FROM orders;


---- 5- Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both
----    an aggregation and a mathematical operator. 

SELECT SUM(standard_amt_usd)/SUM(standard_qty) total_unit_price
FROM orders;



---- #################### QUIZ MIN, MAX, AVG ###################### ----

----Use the SQL environment below to assist with answering the following questions.
----Whether you get stuck or you just want to double check your solutions,
----my answers can be found at the top of the next concept.


----1- When was the earliest order ever placed? You only 
----   need to return the date. 


SELECT MIN(occurred_at) earliest_web_event
FROM orders

----2- Try performing the same query as in question 1 without using an 
----   aggregation function. 

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

----3- When did the most recent (latest) web_event occur? 

SELECT MAX(occurred_at) latest_web_event
FROM web_events;

----4- Try to perform the result of the previous query without
----   using an aggregation function.

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;


----5- Find the mean (AVERAGE) amount spent per order on each paper 
----   type, as well as the mean amount of each paper type purchased per 
----   order. Your final answer should have 6 values - one for each paper
----   type for the average number of sales, as well as the average amount.

SELECT AVG(standard_amt_usd) standard_mean_usd,
       AVG(gloss_amt_usd) gloss_mean_usd,
       AVG(poster_amt_usd) poster_mean_usd, 
       AVG(Standard_qty) standard_mean_qty, 
       AVG(gloss_qty) gloss_mean_qty, 
       AVG(poster_qty) poster_mean_qty
FROM orders;



----6- Via the video, you might be interested in how to calculate the MEDIAN.
----   Though this is more advanced than what we have covered so far try finding- 
----   what is the MEDIAN total_usd spent on all orders?






---- ############################ QUIZ GROUP BY I ############################## ----


---- One part that can be difficult to recognize is when it might be easiest to use
---- an aggregate or one of the other SQL functionalities. Try some of the below to
---- see if you can differentiate to find the easiest solution.

----1- Which account (by name) placed the earliest order? Your solution should have
----   the account name and the date of the order.

SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

----2- Find the total sales in usd for each account. You should include two columns -
----   the total sales for each company's orders in usd and the company name.

SELECT a.name, SUM(o.total_amt_usd) account_total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name;

----3- Via what channel did the most recent (latest) web_event occur, which account was
----   associated with this web_event? Your query should return only three values - the
----   date, channel, and account name.

SELECT w.channel web_event_channel, w.occurred_at web_event_occurred, a.name account_name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

----4- Find the total number of times each type of channel from the web_events was used.
----   Your final table should have two columns - the channel and the number of times the
----   channel was used.

SELECT w.channel, COUNT(w.channel) channel_count
FROM web_events w
GROUP BY w.channel;

----5- Who was the primary contact associated with the earliest web_event?

SELECT w.occurred_at, a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;

----6- What was the smallest order placed by each account in terms of total usd.
----   Provide only two columns - the account name and the total usd. Order from 
----   smallest dollar amounts to largest.

SELECT a.name, MIN(o.total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY smallest_order;

----7- Find the number of sales reps in each region. Your final table should have
----   two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

SELECT r.name, COUNT(s.name) no_of_sales_reps
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
GROUP BY r.name
ORDER BY no_of_sales_reps


---- ############################ QUIZ GROUP BY II ############################## ----

----1- For each account, determine the average amount of each type of paper they purchased
----   across their orders. Your result should have four columns - one for the account name
----   and one for the average quantity purchased for each of the paper types for each account.

SELECT a.name account_name, 
       AVG(o.standard_qty) average_standard_qty,
       AVG(o.gloss_qty) average_gloss_qty,
       AVG(o.poster_qty) average_poster_qty 
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY account_name;  

----2- For each account, determine the average amount spent per order on each paper type. 
----   Your result should have four columns - one for the account name and one for the average
----   amount spent on each paper type.

SELECT a.name account_name, 
       AVG(o.standard_amt_usd) average_standard_amt,
       AVG(o.gloss_amt_usd) average_gloss_amt,
       AVG(o.poster_amt_usd) average_poster_amt 
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY account_name;

----3- Determine the number of times a particular channel was used in the web_events table for
----   each sales rep. Your final table should have three columns - the name of the sales rep, 
----   the channel, and the number of occurrences. Order your table with the highest number of
----   occurrences first.

SELECT s.name sales_rep_name, w.channel, COUNT(w.channel) channel_count 
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id 
GROUP BY s.name, w.channel
ORDER BY channel_count DESC;

----4- Determine the number of times a particular channel was used in the web_events table for 
----   each region. Your final table should have three columns - the region name, the channel,
----   and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT r.name region_name,w.channel, COUNT(w.channel) channel_count
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY region_name, w.channel
ORDER BY channel_count DESC;



---- ############################ QUIZ HAVING ############################## ----

----1- How many of the sales reps have more than 5 accounts that they manage?

SELECT s.name "sales rep names", COUNT(a.name) "no of account"
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name
HAVING COUNT(a.name) > 5;

----2- How many accounts have more than 20 orders?

SELECT a.name, COUNT(o.id)
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
HAVING COUNT(o.id) > 20;

----3- Which account has the most orders?

SELECT a.id, a.name,COUNT(o.id) "no of orders"
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name, a.id
ORDER BY "no of orders" DESC
LIMIT 1;

----4- Which accounts spent more than 30,000 usd total across all orders?

SELECT a.name "account name", SUM(o.total_amt_usd) "total amt usd"
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000;

----5- Which accounts spent less than 1,000 usd total across all orders?

SELECT a.name "account name", SUM(o.total_amt_usd) "total amt usd"
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000;

----6- Which account has spent the most with us?

SELECT a.name "account name", SUM(o.total_amt_usd) "total amt usd"
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY "total amt usd" DESC
LIMIT 1;

----7- Which account has spent the least with us?

SELECT a.name "account name", SUM(o.total_amt_usd) "total amt usd"
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY "total amt usd"
LIMIT 1;

----8- Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.name "account name", COUNT(w.channel) "channel count"
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY "account name"
HAVING COUNT(w.channel) > 6;

----9- Which account used facebook most as a channel?

SELECT a.name "account name", COUNT(w.channel) "channel count"
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY "account name"
ORDER BY "channel count" DESC
LIMIT 1;

----10- Which channel was most frequently used by most accounts?

SELECT w.channel "web event channel", COUNT(a.name) "account count"
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY w.channel
ORDER BY "account count" DESC
LIMIT 1;

---- ############################ QUIZ DATE ############################## ----

----1- Find the sales in terms of total dollars for all orders in each year, ordered
----   from greatest to least. Do you notice any trends in the yearly sales totals?

SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;

----2- Which month did Parch & Posey have the greatest sales in terms of total dollars?
----   Are all months evenly represented by the dataset?

SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

----3- Which year did Parch & Posey have the greatest sales in terms of total number of 
----   orders? Are all years evenly represented by the dataset?

SELECT DATE_PART('year',o.occurred_at) "Year", SUM(o.total) "total"
FROM orders o 
GROUP BY 1
ORDER BY 2 DESC;

----4- Which month did Parch & Posey have the greatest sales in terms of total number of
----   orders? Are all months evenly represented by the dataset?

SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

----5- In which month of which year did Walmart spend the most on gloss paper in 
----   terms of dollars?

SELECT DATE_TRUNC('month',o.occurred_at), SUM(o.gloss_amt_usd) "gloss sum"
FROM accounts a
JOIN orders o
ON o.account_id = a.id 
WHERE a.name ='Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

---- ############################ QUIZ CASE ############################## ---- 

----1- Write a query to display for each order, the account ID, total amount of the order,
----   and the level of the order - ‘Large’ or ’Small’ - depending on if the order is 
----   $3000 or more, or smaller than $3000.

SELECT a.id, o.total_amt_usd, 
CASE WHEN o.total_amt_usd >= 3000 THEN 'Large' ELSE 'Small' END "level"
FROM accounts a
JOIN orders o
ON o.account_id = a.id;

----2- Write a query to display the number of orders in each of three categories,
----   based on the total number of items in each order. The three categories
----   are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT 
  CASE WHEN total >= 2000 THEN 'At Least 2000'
       WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
       ELSE 'Less than 1000' END "order type", 
       COUNT(1)
FROM orders
GROUP BY 1;

----3- We would like to understand 3 different levels of customers based on the amount
----   associated with their purchases. The top level includes anyone with a Lifetime 
----   Value (total sales of all orders) greater than 200,000 usd. The second level is
----   between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. 
----   Provide a table that includes the level associated with each account. You should 
----   provide the account name, the total sales of all orders for the customer, and the
----   level. Order with the top spending customers listed first.


SELECT a.name "account name", SUM(o.total_amt_usd) "total amount spent",
       CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top Level' 
            WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) <= 200000 THEN ' Second Level'
            ELSE 'Lowest Level' END "LEVELS" 
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY "account name"
ORDER BY "total amount spent" DESC;


----4- We would now like to perform a similar calculation to the first, but we want to obtain
----   the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the
----   previous question. Order with the top spending customers listed first.


SELECT a.name "account name", SUM(o.total_amt_usd) "total amount spent",
       CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top Level' 
            WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) <= 200000 THEN 'Second Level'
            ELSE 'Lowest Level' END "LEVELS" 
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
GROUP BY "account name"
ORDER BY "total amount spent" DESC;


----5- We would like to identify top performing sales reps, which are sales reps associated with
----   more than 200 orders. Create a table with the sales rep name, the total number of orders,
----   and a column with top or not depending on if they have more than 200 orders. Place the top
----   sales people first in your final table.

SELECT s.name "sale rep names", COUNT(o.total) "total no of orders", 
       CASE WHEN COUNT(o.total) > 200 THEN 'top' 
            ELSE 'low' END Performance
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 2 DESC;

----6- The previous didn't account for the middle, nor the dollar amount associated with the sales.
----   Management decides they want to see these characteristics represented as well. We would like
----   to identify top performing sales reps, which are sales reps associated with more than 200 
----   orders or more than 750000 in total sales. The middle group has any rep with more than 150
----   orders or 500000 in sales. Create a table with the sales rep name, the total number of orders,
----   total sales across all orders, and a column with top, middle, or low depending on this criteria.
----   Place the top sales people based on dollar amount of sales first in your final table. You might
----   see a few upset sales people by this criteria!

SELECT s.name "sale rep names", COUNT(*) "total no of orders", SUM(o.total_amt_usd) "total sales in dollars", 
       CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 75000 THEN 'top' 
            WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 50000 THEN 'middle'
            ELSE 'low' END Performance
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 2 DESC;





