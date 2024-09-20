--Employee Count:
select sum(employee_count) as Employee_Count from hrdata;

--Attrition Count:
select count(attrition) from hrdata where attrition='True';

--Attrition Rate:
SELECT ROUND(CAST(COUNT(CASE WHEN attrition = 'True' THEN 1 END) AS FLOAT) / NULLIF(SUM(employee_count), 0) * 100, 2) AS Attrition_rate
FROM hrdata;

--Active Employee:
select sum(employee_count) - (select count(attrition) from hrdata  where attrition='True') from hrdata;

--Average Age:
select round(avg(age),0) from hrdata;

--Attrition by Gender
select gender, count(attrition) as attrition_count from hrdata
where attrition='True'
group by gender
order by count(attrition) desc; 

--Department Wise Attrition
select department, count(attrition), round((cast (count(attrition) as numeric) / 
(select count(attrition) from hrdata where attrition= 'True')) * 100, 2) as pct from hrdata
where attrition='True'
group by department 
order by count(attrition) desc;

--No of Employee by Age Group
SELECT age,  sum(employee_count) AS employee_count FROM hrdata
GROUP BY age
order by age;

--Education field wise attrition:
select education_field, count(attrition) as attrition_count from hrdata
where attrition='True'
group by education_field
order by count(attrition) desc;

--Attrition Rate by Gender for different Age Group:
select age_band, gender, count(attrition) as attrition, 
round((cast(count(attrition) as numeric) / (select count(attrition) from hrdata where attrition = 'True')) * 100,2) as pct
from hrdata
where attrition = 'True'
group by age_band, gender
order by age_band, gender desc;

--Job Satisfaction Rating

SELECT job_role,
       [1] AS one,
       [2] AS two,
       [3] AS three,
       [4] AS four
FROM (
    SELECT job_role, job_satisfaction, SUM(employee_count) AS total_count
    FROM hrdata
    GROUP BY job_role, job_satisfaction
) AS SourceTable
PIVOT (
    SUM(total_count) 
    FOR job_satisfaction IN ([1], [2], [3], [4])
) AS PivotTable
ORDER BY job_role;
