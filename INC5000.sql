/*
Project 1 - 2019 INC 5000
1. What is the average revenue among the companies on the 2019 INC 5000 List? 

2. Which states exhibited the highest revenue? 

2. Which industries are most and least represented in the list?

3. Which industries are the most/ least represented?

4. Which industries presented the highest revenue? 

5. Which companies presented the highest % of growth? 

6. Which companies had the largest increase in staff? 
*/

-- Table Creation
CREATE TABLE public.companies
(
    rank numeric,
    profile character varying,
    name character varying,
    url character varying,
    state character varying,
    revenue character varying,
    "growth_%" numeric,
    industry character varying,
    workers integer,
    previous_workers integer,
    founded integer,
    yrs_on_list integer,
    metro character varying,
    city character varying
);

ALTER TABLE IF EXISTS public.companies
    OWNER to kameronjackson;


-- Data Cleaning 
SELECT * FROM companies 

ALTER TABLE companies 
DROP COLUMN profile, DROP COLUMN url, DROP COLUMN yrs_on_list, DROP COLUMN metro, DROP COLUMN workers, DROP COLUMN previous_workers, DROP COLUMN city;

ALTER TABLE companies 
RENAME COLUMN "growth_%" to perc_rev_growth;

UPDATE companies
SET revenue = CASE
WHEN revenue LIKE '% Million' THEN CAST (REPLACE(revenue, 'Million', '')AS DECIMAL) * 1000000
WHEN revenue LIKE '% Billion' THEN CAST (REPLACE(revenue, 'Billion', '')AS DECIMAL) * 1000000000
ELSE CAST (revenue AS DECIMAL)
END;


#1 - What is the average revenue among the companies on the 2019 INC 5000 List? 
SELECT ROUND(AVG(CAST(revenue AS numeric)),2) AS average_revenue
FROM companies;

#2 - Which states exhibited the highest revenue?
SELECT state, ROUND (AVG(CAST(revenue AS numeric)) ,2)AS average_revenue
FROM companies
GROUP BY state
ORDER BY average_revenue DESC;

#3 - Which industries are the most/ least represented?
SELECT industry, COUNT(*) AS count
FROM companies
GROUP BY industry
ORDER BY count DESC;

SELECT industry, COUNT(*) AS count
FROM companies
GROUP BY industry
ORDER BY count ASC;

#4 - Which industries presented the highest revenue? 
SELECT industry, ROUND(AVG(revenue :: NUMERIC),2) AS ind_avg_rev
FROM companies 
GROUP BY industry
ORDER BY ind_avg_rev DESC;

 #5 - Which companies presented the highest % of growth?
SELECT name, ROUND(AVG(perc_rev_growth),2) AS avg_rev_growth
FROM companies 
GROUP BY name
ORDER BY avg_rev_growth DESC;

#6 - Which companies had the largest increase in staff? 
SELECT name, industry, (previous_workers - workers) AS new_hires
FROM companies
GROUP BY name, industry, previous_workers, workers
ORDER BY new_hires DESC;













 

