-- select countries which regions are included in database
SELECT DISTINCT country FROM customers;

SELECT DISTINCT country FROM customers WHERE region IS NOT null;

--Countries with the most and the least orders shipped to
WITH COUNTRY_REGIONS AS
(SELECT COUNTRY,
	COUNT(REGION) AS NUMBER OF REGIONS
FROM CUSTOMERS
WHERE REGION IS NOT NULL
GROUP BY COUNTRY)

SELECT '_average_' AS COUNTRY,
	AVG(NUMBER_OF_REGIONS) AS NUMBER_OF_REGIONS_PER_COUNTRY
FROM COUNTRY_REGIONS
UNION
SELECT *
FROM COUNTRY_REGIONS
ORDER BY 1;
