/*

Project 1 - INC 5000

As my first SQL project, I have decided to use a data set from the 2019 "INC 5000", 
and analyze the relationships of the given data to answer a 
variety of questions. By analyzing this data, I have been able to use Tablueau.Public to
prepare a dashboard that visualizes the data, which has allowed me to draw meaningful conlcusions.

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


-- 1)  What is the average revenue among the companies on the 2019 INC 5000 List? 
SELECT ROUND(AVG(CAST(revenue AS numeric)),2) AS average_revenue
FROM companies;

-- 2) Which states exhibited the highest revenue?
SELECT state, ROUND (AVG(CAST(revenue AS numeric)) ,2)AS average_revenue
FROM companies
GROUP BY state
ORDER BY average_revenue DESC;

-- 6) Which industries are the most/ least represented?
SELECT industry, COUNT(*) AS count
FROM companies
GROUP BY industry
ORDER BY count DESC;

SELECT industry, COUNT(*) AS count
FROM companies
GROUP BY industry
ORDER BY count ASC;

-- 4) Which industries presented the highest revenue? 
SELECT industry, ROUND(AVG(revenue :: NUMERIC),2) AS ind_avg_rev
FROM companies 
GROUP BY industry
ORDER BY ind_avg_rev DESC;

-- 5) Which companies presented the highest % of growth?
SELECT name, ROUND(AVG(perc_rev_growth),2) AS avg_rev_growth
FROM companies 
GROUP BY name
ORDER BY avg_rev_growth DESC;

-- New column titled "new_hires" for calculating amount of new employees
ALTER TABLE companies
ADD new_hires INTEGER;

UPDATE companies
SET new_hires = workers - previous_workers;

-- 6) Which companies had the largest increase in staff? 
SELECT name, new_hires
FROM companies
GROUP BY name, new_hires
ORDER BY new_hires DESC;

-- 7) Which are the top 5 states represented on the 'INC 5000' list? 
SELECT state, COUNT (*) AS state_rank
FROM companies
GROUP BY state
ORDER BY state_rank DESC
LIMIT 5;




