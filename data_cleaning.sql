---- ######################### LEFT & RIGHT Quizzes ########################## ---- 

----1- In the accounts table, there is a column holding the website for each company. 
----   The last three digits specify what type of web address they are using. A list 
----   of extensions (and pricing) is provided here. Pull these extensions and provide
----   how many of each website type exist in the accounts table.

SELECT RIGHT("website",3) AS "Extension", COUNT(*)
FROM accounts
GROUP BY 1;

----2- There is much debate about how much the name (or even the first letter of a company name)
----   matters. Use the accounts table to pull the first letter of each company name to see the 
----   distribution of company names that begin with each letter (or number).

SELECT LEFT(name,1) "First letter of company name", COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

----3- Use the accounts table and a CASE statement to create two groups: one group of company
----   names that start with a number and a second group of those company names that start with
----   a letter. What proportion of company names start with a letter?

SELECT CASE WHEN LEFT(name,1) IN ('1','2','3','4','5','6','7','8','9','0') THEN 'Begin with Number'
       ELSE 'Begin with Letter' END "NUMBER / LETTER",
       COUNT(*)
FROM accounts
GROUP BY 1;

----4- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, 
----   and what percent start with anything else?

SELECT CASE WHEN LEFT(UPPER(name),1) IN ('A','E','I','O','U') THEN 'Begin with vowel'
            ELSE 'Begins with NOT vowel' END "Vowel/Not Vowel",
            COUNT(*)
FROM accounts
GROUP BY 1


---- ######################### Quizzes POSITION & STRPOS ########################## ---- 

----1- Use the accounts table to create first and last name columns that hold the first and last
----   names for the primary_poc.

SELECT LEFT(primary_poc, STRPOS(primary_poc,' ')-1) "First name",
       RIGHT(primary_poc, LENGTH(primary_poc)-STRPOS(primary_poc,' ')) "Last name",
       primary_poc "Full name"
FROM accounts

----2- Now see if you can do the same thing for every rep name in the sales_reps table.
----   Again provide first and last name columns.

SELECT LEFT(name, STRPOS(name, ' ')-1) " FIRST NAME ",
       RIGHT(name, LENGTH(name) - STRPOS(name,' ')) " LAST NAME ", name
FROM sales_reps;

---- ######################### Quizzes CONCAT ########################## ---- 

----1- Each company in the accounts table wants to create an email address for each
----   primary_poc. The email address should be the first name of the primary_poc . 
----   last name primary_poc @ company name .com.

SELECT LEFT(primary_poc,STRPOS(primary_poc,' ')-1) ||'.'|| 
       RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) ||'@'||
       name||'.'||'com'
FROM accounts;

----2- You may have noticed that in the previous solution some of the company names
----   include spaces, which will certainly not work in an email address. See if you
----   can create an email address that will work by removing all of the spaces in the
----   account name, but otherwise your solution should be just as in question 1. 

SELECT REPLACE(LEFT(primary_poc,STRPOS(primary_poc,' ')-1) ||'.'|| 
       RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) ||'@'||
       name||'.'||'com',' ','')
FROM accounts;

----3- We would also like to create an initial password, which they will change after
----   their first log in. The first password will be the first letter of the primary_poc's
----   first name (lowercase), then the last letter of their first name (lowercase), the
----   first letter of their last name (lowercase), the last letter of their last name
----   (lowercase), the number of letters in their first name, the number of letters in their
----   last name, and then the name of the company they are working with, all capitalized
----   with no spaces.

WITH t1 AS (
    SELECT LOWER(LEFT(primary_poc,STRPOS(primary_poc,' ')-1)) "first name",
           LOWER(RIGHT(primary_poc, LENGTH(primary_poc)- STRPOS(primary_poc,' '))) "Last Name",
           LENGTH(LEFT(primary_poc,STRPOS(primary_poc,' ')-1)) "Length of First Name",
           LENGTH(RIGHT(primary_poc, LENGTH(primary_poc)- STRPOS(primary_poc,' '))) "Length of Last name",
           REPLACE(UPPER(name),' ','') "name of company",
           primary_poc
    FROM accounts  
)

SELECT primary_poc,
       LEFT("first name",1)  ||''||
       RIGHT("first name",1) ||''||
       LEFT("Last Name",1)   ||''||
       RIGHT("Last Name",1)  ||''||
       "Length of First Name"||''||
       "Length of Last name" ||''||
       "name of company" AS password    
FROM t1;


---- ######################### CAST Quizzes ########################## ----

----1-

SELECT COALESCE(a.id,a.id) "Filled ID",
       COALESCE(o.account_id,a.id) account_id,
       o.occurred_at,
       COALESCE(o.standard_qty,0)standard_qty,
       COALESCE(o.gloss_qty,0) gloss_qty,
       COALESCE(o.poster_qty,0) poster_qty,
       COALESCE(o.total,0) total, 
       COALESCE(o.standard_amt_usd,0) standard_amt_usd,
       COALESCE(o.gloss_amt_usd,0) gloss_amt_usd,
       COALESCE(o.poster_amt_usd,0) poster_amt_usd,
       COALESCE(o.total_amt_usd,0) total_amt_usd

FROM accounts a
LEFT JOIN orders o
ON o.account_id = a.id
WHERE o.total IS NULL;

----2-

SELECT COUNT(COALESCE(a.id,a.id)) "Filled ID",
       COUNT(COALESCE(o.account_id,a.id)) account_id,
       /*o.occurred_at,
       COALESCE(o.standard_qty,0)standard_qty,
       COALESCE(o.gloss_qty,0) gloss_qty,
       COALESCE(o.poster_qty,0) poster_qty,
       COALESCE(o.total,0) total, 
       COALESCE(o.standard_amt_usd,0) standard_amt_usd,
       COALESCE(o.gloss_amt_usd,0) gloss_amt_usd,
       COALESCE(o.poster_amt_usd,0) poster_amt_usd,
       COALESCE(o.total_amt_usd,0) total_amt_usd*/

FROM accounts a
LEFT JOIN orders o
ON o.account_id = a.id;

----6-

SELECT COALESCE(a.id,a.id) "Filled ID",
       COALESCE(o.account_id,a.id) account_id,
       o.occurred_at,
       COALESCE(o.standard_qty,0)standard_qty,
       COALESCE(o.gloss_qty,0) gloss_qty,
       COALESCE(o.poster_qty,0) poster_qty,
       COALESCE(o.total,0) total, 
       COALESCE(o.standard_amt_usd,0) standard_amt_usd,
       COALESCE(o.gloss_amt_usd,0) gloss_amt_usd,
       COALESCE(o.poster_amt_usd,0) poster_amt_usd,
       COALESCE(o.total_amt_usd,0) total_amt_usd

FROM accounts a
LEFT JOIN orders o
ON o.account_id = a.id;




