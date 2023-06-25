--Examining various quality measures across inpatient psychiatric facilities across the United States
--Dataset obtained from Centers for Medicare & Medicaid Services (CMS.gov)


SELECT *
FROM facility
 
 --Number of facilities with no reported readmission category 

SELECT state, 
    COUNT(CASE WHEN READcat IS NULL THEN 1 END) AS total_null
FROM facility 
GROUP BY state
ORDER BY state;

--Total number of facilities per state 

SELECT state,
    count (distinct facility_id) AS total_facilities
    from facility 
    group by state ;
       

--Count and percentage of facilities in each category per state (better, worse, or same as national average)

SELECT state, 
    COUNT(CASE WHEN READcat = 'worse' THEN facility_ID END) AS Count_worse,
    COUNT(CASE WHEN READcat = 'better' THEN facility_ID END) AS Count_better,
    COUNT(CASE WHEN READcat= 'same' THEN facility_ID END) AS Count_same,
    ROUND ((COUNT(CASE WHEN READcat = 'worse' THEN Facility_ID END) * 100.0) / COUNT(*), 2) AS Percent_worse,
    ROUND ((COUNT(CASE WHEN READcat = 'better' THEN Facility_ID END) * 100.0) / COUNT(*), 2) AS Percent_better,
    ROUND ((COUNT(CASE WHEN READcat = 'Same' THEN Facility_ID END) * 100.0) / COUNT(*), 2)AS Percent_same
FROM facility 
GROUP BY state;

--calculate avg higher and lower readmission rate estimates for each state 

SELECT state, ROUND(avg(READ_Higher_Estimate),2) AS avg_READhigher_est, ROUND(avg(READ_Lower_Estimate),2) AS avg_READlower_est
FROM facility
GROUP BY State 
ORDER BY avg_READhigher_est DESC

-- Average Seclusion and Restraint Rates Per state

SELECT state, ROUND(avg(restraintrate_per_1000),2) AS avg_restraint, ROUND(avg(seclustionrate_per_1000),2) AS avg_seclusion
FROM facility
GROUP BY State 
ORDER BY avg_restraint DESC 

--View precent of patients receiving follow-up care within 30 days (FUH-30)

SELECT state, FUH_30
FROM facility
ORDER BY FUH_30 DESC

--Find average FUH-30 per state 

SELECT state, ROUND(AVG(FUH_30),2) AS average_30FUH
FROM facility
GROUP BY state 
ORDER BY average DESC

--Find average timely transition of record per state 

SELECT state, AVG(Timely_Transition) AS average_Timely
FROM facility
GROUP BY state 

--Find facilities with highest use of seclusion in each state

SELECT state, MAX(facility_name), ROUND (MAX(seclustionrate_per_1000),2) AS max_seclusion -- MAX(RestraintRate_per_1000) AS max_restraint
FROM facility
GROUP BY State
ORDER BY max_seclusion DESC


