--Exploring mental health and total hours of sunshine 
--Datasets downloaded from Kaggle


--Count number of distinct countries in each table. 
SELECT Count(distinct Entity)
FROM MentalHealth
WHERE Code is NOT NULL AND depression is not NULL;

SELECT Count(distinct Country)
FROM sunshineHours;

--Explore sunshine hours and 2017 depression rates
SELECT mh.year, country, city, s.total_hours, mh.depression
FROM sunshineHours s
JOIN MentalHealth mh
ON s.country = mh.entity
WHERE mh.Code is NOT NULL AND mh.depression is not NULL 
AND mh.year = 2017 
ORDER BY depression DESC;

--Calculate average sunshine hours for each country 
SELECT country, city, s.total_hours, 
AVG(total_hours) OVER (Partition by Country) as AvgTotalHours,
mh.depression
FROM sunshineHours s
JOIN MentalHealth mh
ON s.country = mh.entity
WHERE mh.Code is NOT NULL AND mh.depression is not NULL 
AND mh.year = 2017 
ORDER BY 1, 2 

With AvgSunVsDepression (country, city, total_hours, AvgTotalHours, depression)
 AS
 (
     SELECT country, city, s.total_hours, 
AVG(total_hours) OVER (Partition by Country) as AvgTotalHours,
mh.depression
FROM sunshineHours s
JOIN MentalHealth mh
ON s.country = mh.entity
WHERE mh.Code is NOT NULL AND mh.depression is not NULL 
AND mh.year = 2017 
)
Select *
FROM AvgSunVsDepression

--Create views for Visualizations
CREATE VIEW AvgSunVsDepression AS
 SELECT s.country, s.city, s.total_hours, 
AVG(total_hours) OVER (Partition by Country) as AvgTotalHours,
mh.depression
FROM sunshineHours s
JOIN MentalHealth mh
ON s.country = mh.entity
WHERE mh.Code is NOT NULL AND mh.depression is not NULL 
AND mh.year = 2017;


With SunVsAnxiety (country, city, total_hours, AvgTotalHours, Anxiety_disorders)
 AS
 (
     SELECT country, city, s.total_hours, 
AVG(total_hours) OVER (Partition by Country) as AvgTotalHours,
mh.Anxiety_disorders
FROM sunshineHours s
JOIN MentalHealth mh
ON s.country = mh.entity
WHERE mh.Code is NOT NULL AND mh.Anxiety_disorders is not NULL 
AND mh.year = 2017 
)
Select * 
FROM SunVsAnxiety

CREATE VIEW SunVsAnxiety AS
SELECT country, city, s.total_hours, 
AVG(total_hours) OVER (Partition by Country) as AvgTotalHours,
mh.Anxiety_disorders
FROM sunshineHours s
JOIN MentalHealth mh
ON s.country = mh.entity
WHERE mh.Code is NOT NULL AND mh.Anxiety_disorders is not NULL 
AND mh.year = 2017 
