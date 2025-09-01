SELECT * FROM hrdata

SELECT sum(employee_count) AS TOTAL_Employee FROM hrdata

Select COUNT(attrition) AS Attrition from hrdata
Where attrition='Yes'

Select Sum(active_employee) AS Avtive_Employee from hrdata

SELECT ROUND(AVG(age),2)  AS Average_Age from hrdata

SELECT 
  SUM(employee_count) AS Total_Employee,
  SUM(active_employee) AS Active_Employee,
  CONCAT(
    ROUND(
      (SUM(employee_count) - SUM(active_employee)) * 100.0 / SUM(employee_count),
      2
    ),
    '%'
  ) AS Attrition_Rate
FROM hrdata;

--Department wise Attrition
SELECT department,COUNT(attrition), 
ROUND((CAST(COUNT(attrition) as numeric)
/(SELECT COUNT(attrition) from hrdata where attrition='Yes'))*100,2)
AS PCT from hrdata
WHERE attrition='Yes' and gender='Female'
GROUP BY department
order by Count(attrition) DESC

--No of Employee by Age group
SELECT age,sum(employee_count) from hrdata
WHERE department='R&D'
group by age
order by age

--Education wise attrition
SELECT education_field,COUNT(employee_count) from hrdata
WHERE attrition='Yes'and department='Sales'
group by education_field
order by COUNT(attrition) desc

-- attrition rate by gender for different age_group
SELECT age_band,gender, COUNT(attrition),
ROUND((CAST(COUNT(attrition) as numeric)/(SELECT COUNT(attrition)from hrdata where attrition='Yes'))*100,2)
from hrdata
WHERE attrition='Yes'
group by age_band,gender
order by age_band ,gender

--Job Satisfaction Rate
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *
FROM crosstab(
  $$SELECT 
      job_role, 
      job_satisfaction, 
      SUM(employee_count)::numeric
    FROM hrdata
    GROUP BY job_role, job_satisfaction
    ORDER BY job_role, job_satisfaction$$
) AS ct(
  job_role varchar(50), 
  satisfaction_1 numeric, 
  satisfaction_2 numeric, 
  satisfaction_3 numeric, 
  satisfaction_4 numeric
)
ORDER BY job_role;
