SELECT id,occurred_at,total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;


SELECT id,account_id,total_amt_usd
FROM orders 
ORDER BY total_amt_usd DESC
LIMIT 5;


SELECT id,account_id,total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

############### 22 #################

SELECT id,account_id,total_amt_usd
FROM orders
ORDER BY account_id,total_amt_usd DESC;


SELECT id,account_id,total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC,account_id;


################ 23 #################

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;


SELECT * 
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

################### 28 ##############

SELECT name,website,primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

############ 31 ###############

SELECT id, account_id, (standard_amt_usd/standard_qty) AS unit_price
FROM orders
LIMIT 10;

SELECT id,account_id, (poster_amt_usd/(poster_amt_usd + gloss_amt_usd + standard_amt_usd))* 100 AS poster_per_rev
FROM orders
LIMIT 10;


########### 34 ################

SELECT *
FROM accounts
WHERE name LIKE 'C%';

SELECT *
FROM accounts
WHERE name LIKE '%one%';

SELECT *
FROM accounts
WHERE name LIKE '%s';


########## 38 ###########

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target','Nordstrom');

SELECT *
FROM web_events 
WHERE channel IN ('organic','adwords');


######### 41 ##########

SELECT name,primary_poc,sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel NOT IN ('organic','adwords');

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%s';

################# 44 #############

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

SELECT *
FROM web_events
WHERE channel IN ('organic','adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

SELECT gloss_qty, occurred_at
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29; 


###### 47 ######

SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 or poster_qty > 1000);

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%');



########## JOIN ###########
############# 4 ###########
SELECT *
FROM orders
JOIN accounts
ON accounts.id = orders.account_id;

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.primary_poc, accounts.website  
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
limit 10;


############ 11 #############

SELECT accounts.primary_poc,accounts.name, web_events.channel,web_events.occurred_at
FROM accounts
JOIN web_events
ON accounts.id = web_events.account_id
WHERE accounts.name = 'Walmart';

        ### OR #######

SELECT a.primary_poc,a.name, w.channel,w.occurred_at
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.name = 'Walmart';

SELECT s.name sn, a.name an, r.name rn
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id;



SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;


SELECT o.total_amt_usd/(o.total + 0.01) unit_price, a.name an, r.name rn 
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;


#################### last check ##############

SELECT r.name regionName, s.name salesName, a.name accName
FROM sales_reps s
JOIN region r
ON  s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name; 


SELECT r.name regionName, s.name salesName, a.name accName
FROM sales_reps s
JOIN region r
ON  s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name; 

SELECT r.name regionName, s.name salesName, a.name accName
FROM sales_reps s
JOIN region r
ON  s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name; 

SELECT r.name RegionName, a.name AccName, o.total_amt_usd/(total+0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE O.standard_qty > 100;


SELECT r.name RegionName, a.name AccName, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.poster_qty > 50 AND o.standard_qty > 100
ORDER BY unit_price;

SELECT r.name RegionName, a.name AccName, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.poster_qty > 50 AND o.standard_qty > 100
ORDER BY unit_price DESC;

SELECT a.name accName, w.channel webEventsChannels
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.id = '1001';


SELECT o.occurred_at OrderOccuredAt, a.name AccName, o.total OrderTotal, o.OrderTotalUSD
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at DESC;;
