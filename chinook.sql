SELECT *
FROM invoice
WHERE InvoiceDate BETWEEN '2013-01-01' AND '2014-01-01';


SELECT FirstName, Lastname, Country
FROM Customer
WHERE Country IN ('Brazil','Canada','India','Sweden');

SELECT t.Name, t.Composer, a.Title 
FROM Track t
JOIN Album a
ON t.AlbumId = a.AlbumId 
WHERE t.Name LIKE 'A%' AND t.Composer IS NOT NULL;


SELECT c.FirstName, c.Lastname, i.Total
FROM Customer c
JOIN Invoice i
ON i.CustomerId = c.CustomerId
ORDER BY i.Total DESC;
LIMIT 10;
