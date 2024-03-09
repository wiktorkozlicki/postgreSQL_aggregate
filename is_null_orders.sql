SELECT * FROM customers WHERE NOT (customers is not null);

WITH customers_without_regions AS
(
SELECT customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax
FROM customers
)
SELECT * FROM customers_without_regions where NOT (customers_without_regions is not null);

WITH customers_without_regions AS
(
SELECT customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax
FROM customers
)


SELECT company_name, country, 'no postal_code' AS missing_info FROM customers_without_regions WHERE postal_code IS null
UNION
SELECT company_name, country, 'no fax' AS missing_info FROM customers_without_regions WHERE fax IS null
ORDER BY missing_info DESC, country;
