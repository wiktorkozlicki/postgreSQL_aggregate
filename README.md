# postgreSQL_aggregate
Northwind in PostgreSQL Table Exploration with Simple Aggregation, Rank(), and NULL Values

# About the database

    The Northwind database is a sample database used by Microsoft to demonstrate the features of some of its products,
    including SQL Server and Microsoft Access. The database contains the sales data for Northwind Traders,
    a fictitious specialty foods exportimport company. 

Here I used version suited for PostgreSQL, which is available via this Github repository:
https://github.com/pthom/northwind_psql

Today we'll focus on two tables from the database, customers and orders.

# Goal of the project

 Today's goal was to show examples of queries that use:

- aggregate functions like COUNT(), AVG(), MIN(), MAX()
- RANK() function
- IS NULL operator


# Count()

Let's start with simple query that will show us the number of customers. 

    SELECT COUNT(*) AS number_of_Customers FROM CUSTOMERS;
When using aliases, the 'AS' keyword is optional.

We can add GROUP BY clause to see the number of custobers for each country:
    SELECT country, count(country) from customers group by country order by 2 desc;
If we don't use aliases the column will be called "count" by default. Notice that I use second column to sort the results, without having to reffer to it by it's name.

# AVG()

 When exploring the database I noticed that only specific countries have regions assigned to them:
    -- select countries which regions are included in database
    SELECT DISTINCT country FROM customers;

So I did a simple query to see which countries do have regions assigned to them, using IS NOT NULL condition:
    SELECT DISTINCT country FROM customers WHERE region IS NOT null;

For practice, I decided to count average number of regions per country, including only countries that have regions assigned to them in the database:
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

More complex query using Common Table Explression (lines 1-6)

# MIN() and MAX()

I decided to do more complex query for MIN() and MAX() Aggregate Functions. I wanted to create query that would return all countries which have either minimum or maximum number of orders in database:
    WITH COUNTRY_ORDERS AS
    (SELECT SHIP_COUNTRY,
			COUNT(*) AS NUMBER_OF_ORDERS
		FROM ORDERS
		GROUP BY SHIP_COUNTRY
		ORDER BY 2 DESC),
		
  	COUNTRY_ORDERS_MIN_MAX AS
  	(SELECT MIN(NUMBER_OF_ORDERS)
  		FROM COUNTRY_ORDERS
  	UNION
  	SELECT MAX(NUMBER_OF_ORDERS)
  		FROM COUNTRY_ORDERS)

    SELECT * FROM COUNTRY_ORDERS WHERE NUMBER_OF_ORDERS IN (SELECT * FROM COUNTRY_ORDERS_MIN_MAX);
Notice that one Common Table Expression can reffer to the other CTE's. Here COUNTRY_ORDERS_MIN_MAX (lines 8-13) reffers to COUNTRY_ORDERS (lines 1-6).
Notice that the main query (line 15) returns all rows which number of orders is either minimum or maximum. This helps if we have more than one result with either minimum or maximum value.

# RANK()
Let's stay with number of orders per country. We can use RANK() function to return ranking of countries of customers with most orders:

    -- Ranking of contries with most orders.
-- Ranking of contries with most orders.
    WITH ORDERS_COUNT AS
    	(SELECT C.COUNTRY,COUNT(*) AS NUMBER_OF_ORDERS
    		FROM ORDERS O
    		INNER JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
    		GROUP BY C.COUNTRY
    		ORDER BY 2 DESC)
    		
    SELECT COUNTRY,
    	RANK() OVER(ORDER BY NUMBER_OF_ORDERS DESC) AS ORDERS_RANKING,
    	NUMBER_OF_ORDERS
    FROM ORDERS_COUNT
    ORDER BY NUMBER_OF_ORDERS DESC;


# IS NULL operator

I used IS NULL as a part of previous queries, but let's do one, last example.

This query returns rows with any NULL values: 
    SELECT * FROM customers WHERE NOT (customers is not null);
    
Let's select all columns but the "region" column
    WITH customers_without_regions AS
    (
    SELECT customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax
    FROM customers
    )
    SELECT * FROM customers_without_regions where NOT (customers_without_regions is not null);
Simple use of CTE gives us good base for next queries.


WITH customers_without_regions AS
(
SELECT customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax
FROM customers
)

Let's show the companies with missing info in fax and postal_code columns:
    SELECT company_name, country, 'no postal_code' AS missing_info FROM customers_without_regions WHERE postal_code IS null
    UNION
    SELECT company_name, country, 'no fax' AS missing_info FROM customers_without_regions WHERE fax IS null
    ORDER BY missing_info DESC, country;

That's all for today. Thanks for reading!


 Sources:

- Northwind database for Postgres:
https://github.com/pthom/northwind_psql
    
- What is Northwind Database:
https://www.unife.it/ing/informazione/Basi_dati/lucidi/materiali-di-laboratorio/esercizi-sql-base-di-dati-nothwind

- How to Find All Null Values in an Entire Table Using PostgreSQL:
https://medium.com/@mrbean0228/how-to-find-all-null-values-in-an-entire-table-using-postgresql-981769bbe620
