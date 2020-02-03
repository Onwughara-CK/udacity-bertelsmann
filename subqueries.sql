---- ############################ QUIZ SUBQUERY ############################## ---- 

SELECT channel, AVG(event_count) avg_event_count
FROM (SELECT DATE_TRUNC('day', occurred_at),channel, COUNT(*) event_count 
FROM web_events w
GROUP BY 1,2)sub
GROUP BY 1;

SELECT AVG(standard_qty) standard_avg,
       AVG(gloss_qty) gloss_avg,
       AVG(poster_qty) poster_avg,
       SUM(total_amt_usd) 
FROM (SELECT *
FROM orders
WHERE DATE_TRUNC('month',occurred_at) = (SELECT DATE_TRUNC('month',MIN(occurred_at))
FROM orders))table1;

----1- Provide the name of the sales_rep in each region with the largest amount 
----   of total_amt_usd sales.

--#get the sum total in sales for each sale rep t1
--#get the Max total in sales t2
--#join the two tables and filter based on t2.max

SELECT t2.id, t2.region_name, t3.sales_rep_name
FROM (SELECT id, region_name, MAX(sales_rep_sum_per_region) max
FROM(SELECT  r.id, r.name region_name, s.name sales_rep_name,SUM(o.total_amt_usd) sales_rep_sum_per_region 
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1,2,3) t1
GROUP BY 1,2) t2
JOIN (SELECT  r.id, r.name region_name, s.name sales_rep_name,SUM(o.total_amt_usd) sales_rep_sum_per_region 
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1,2,3) t3
ON t1.id = t2.id AND t2.max = t3.sales_rep_sum_per_region;

----2- For the region with the largest (sum) of sales total_amt_usd, how many total
----   (count) orders were placed?

SELECT r.name, COUNT(o.total_amt_usd)
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE r.name =  (SELECT t1.name
FROM (SELECT r.name, SUM(o.total_amt_usd) sum
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id  
GROUP BY r.name
ORDER BY 2 DESC
LIMIT 1)t1)
GROUP BY r.name

----3- How many accounts had more total purchases than the account name which has
----   bought the most standard_qty paper throughout their lifetime as a customer?

--# find the account with the most standard_qty paper

SELECT MAX("total standard qty per account")
FROM (SELECT a.name, SUM(o.standard_qty) "total standard qty per account"
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name)t1

--# find the total purchase of that account at 1

SELECT t2.sum
FROM (SELECT o.account_id, SUM(o.total) 
FROM orders o
GROUP BY 1
HAVING SUM(o.standard_qty) = (SELECT MAX("total standard qty per account")
FROM (SELECT a.name, SUM(o.standard_qty) "total standard qty per account"
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name)t1))t2;

--# return and count accounts that had a high purchase than 1.

SELECT COUNT(*)
FROM (SELECT a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total) > (SELECT t2.sum
FROM (SELECT o.account_id, SUM(o.total) 
FROM orders o
GROUP BY 1
HAVING SUM(o.standard_qty) = (SELECT MAX("total standard qty per account")
FROM (SELECT a.name, SUM(o.standard_qty) "total standard qty per account"
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name)t1))t2
))t3


----4- For the customer that spent the most (in total over their lifetime as
----   a customer) total_amt_usd, how many web_events did they have for each channel?

--# find the customer with the most total_amt_usd:group by account and sum total_amt_usd

/*SELECT MAX(t1.sum)
FROM (SELECT a.name, SUM(o.total_amt_usd) sum
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name) t1;*/

SELECT t1.name
FROM (SELECT a.name, SUM(o.total_amt_usd) sum
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY 2 DESC
LIMIT 1) t1;

--# join account and web events table and group by account,channel and count(*)

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE a.name = (SELECT t1.name
FROM (SELECT a.name, SUM(o.total_amt_usd) sum
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY 2 DESC
LIMIT 1) t1) 
GROUP BY 1, 2
ORDER BY 1;

----5- What is the lifetime average amount spent in terms of total_amt_usd for the 
----   top 10 total spending accounts?

--# Calc the SUM for the top 10 customers: group by account name;join accounts to orders

SELECT a.name, SUM(o.total_amt_usd)
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--# Find the Average of the top 10 accounts

SELECT AVG(t1.sum)
FROM (SELECT a.name, SUM(o.total_amt_usd) sum
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10) t1

----6- What is the lifetime average amount spent in terms of total_amt_usd,
----   including only the companies that spent more per order, on average, 
----   than the average of all orders.



  
---- ######################### WITH SUBQUERY ########################## ---- 

----1- Provide the name of the sales_rep in each region with the largest amount
----   of total_amt_usd sales.

--==-- WITH :provide a table with rows: sales_rep names, group by region, total_amt_used

WITH t1 AS (
SELECT s.name "sales rep name", r.name "region name", SUM(o.total_amt_usd) sum 
FROM region r
JOIN sales_reps s
ON  s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1,2),

t2 AS (
SELECT "region name", MAX(sum) max
FROM t1
GROUP BY 1)

SELECT t2."region name", t1."sales rep name", "max"
FROM t2
JOIN t1
ON t2.max =  t1.sum
ORDER BY max;

----2- For the region with the largest sales total_amt_usd, how many total orders were placed?

--==-- find the region with the highest sales total_amt_usd
--== t1
--join region and orders
--group by region,SUM(total_amt_usd)
--ORDER by sum and LIMIT 1

WITH t1 AS(
SELECT o.total_amt_usd "total amt usd", r.name "region name", o.total "total qty per order"
FROM region r
JOIN sales_reps s
ON  s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
),
t2 AS (
SELECT "region name", SUM("total amt usd") "sum per region"
FROM t1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1)

SELECT "region name", COUNT(*)
FROM t1
WHERE "region name" = (SELECT "region name" FROM t2)
GROUP BY 1;


----3- How many accounts had more total purchases than the account name which has bought
----   the most standard_qty paper throughout their lifetime as a customer?


WITH t1 AS (
    SELECT a.name "account name", SUM(o.standard_qty) "sum of standard", SUM(o.total) "total purchase"
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1
),

    t2 AS (
        SELECT a.name "account name"
        FROM orders o
        JOIN accounts a
        ON o.account_id = a.id
        GROUP BY 1
        HAVING SUM(o.total) > (SELECT t1."total purchase" FROM t1)
)

SELECT COUNT(*)
FROM t2


----4- For the customer that spent the most (in total over their lifetime as a customer) 
----   total_amt_usd, how many web_events did they have for each channel?

WITH t1 AS (
    SELECT a.name "account name", SUM(o.total_amt_usd) "most spent amt"
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1
)

SELECT w.channel "web event channel", COUNT(w.occurred_at) 
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE a.name = (SELECT "account name" FROM t1)
GROUP BY 1

----5- What is the lifetime average amount spent in terms of total_amt_usd for the 
----   top 10 total spending accounts?

WITH t1 AS (
    SELECT a.name, SUM(o.total_amt_usd) sum
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
)

SELECT AVG(t1.sum)
FROM t1





