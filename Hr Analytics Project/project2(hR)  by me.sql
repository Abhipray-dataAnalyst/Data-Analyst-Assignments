create database HR;
use HR;

CREATE TABLE employee_data (
    Age INT,
    Attrition VARCHAR(3),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20)
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_1.csv' into table employee_data
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

CREATE TABLE  employee_data2(
    EmployeeID INT PRIMARY KEY,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 CHAR(1),
    OverTime VARCHAR(3),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
drop table employee_data2;


-----------------------------------------------------------------------------------------
###--KPI 1''
-------------------------------------------------------------------------------------------
SELECT 
    Department, 
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)*100 AS Average_Attrition_Rate
FROM 
    employee_data
GROUP BY 
    Department;
--------------------------------------------------------------------------------------------
####kpi 2
--------------------------------------------------------------------------------------------
SELECT 
    AVG(HourlyRate) AS Average_Hourly_Rate
FROM 
    employee_data
WHERE 
    Gender = 'Male' AND 
    JobRole = 'Research Scientist';
--------------------------------------------------------------------------------------------   
-----------------------------------------------------------------------------------------------
########kpi3
----------------------------------------------------------------------------------------------------

SELECT 
    e1.Attrition,
    COUNT(*) AS Employee_Count,
    AVG(e2.MonthlyIncome) AS Average_Monthly_Income,
    MIN(e2.MonthlyIncome) AS Min_Monthly_Income,
    MAX(e2.MonthlyIncome) AS Max_Monthly_Income
FROM 
    employee_data e1
JOIN 
    employee_data2 e2
ON 
    e1.EmployeeNumber = e2.EmployeeID
GROUP BY 
    e1.Attrition
LIMIT 1000;

---------------------------------------------------------------------------------------
###kpi4
-----------------------------------------
SELECT e.Department,
       AVG(d.TotalWorkingYears) AS AverageWorkingYears
FROM employee_data e
JOIN employee_data2 d ON e.EmployeeNumber = d.EmployeeID
GROUP BY e.Department;

--------------------------------------------------------------------------------------------------
###KPI 5 
--------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
select * from employee_data2;

select e.jobrole,d.worklifebalance, count(d.worklifebalance) Employee_count
from employee_data e join employee_data2 d
on e.employeenumber = d.EmployeeID
group by e.jobrole,d.worklifebalance
order by e.jobrole;


---------------------------------------------------------------------------------------------
###kpi6
-------------------------------------------------------------------------------------------

-- Calculating attrition rate for different ranges of years since last promotion

SELECT 
    CASE
        WHEN d.YearsSinceLastPromotion BETWEEN 0 AND 1 THEN '0-1 years'
        WHEN d.YearsSinceLastPromotion BETWEEN 2 AND 3 THEN '2-3 years'
        WHEN d.YearsSinceLastPromotion BETWEEN 4 AND 5 THEN '4-5 years'
        WHEN d.YearsSinceLastPromotion BETWEEN 6 AND 10 THEN '6-10 years'
        ELSE 'More than 10 years'
    END AS PromotionRange,
    AVG(CASE WHEN e.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 AS AttritionRate
FROM employee_data e
JOIN employee_data2 d ON e.EmployeeNumber = d.EmployeeID
GROUP by PromotionRange
order by PromotionRange;
    
---------------------------------------------------------------------------------

 