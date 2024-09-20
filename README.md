# HR Analytics: Employee Attrition & Performance Analysis
This repository contains SQL-based analyses using the HR Analytics Employee Attrition & Performance dataset. The dataset explores various aspects of employee satisfaction, performance, attrition, and other relevant HR factors. The goal of these analyses is to extract insights that can help companies improve employee retention, performance management, and decision-making.

Dataset Overview
The dataset consists of multiple tables:

PerformanceRating: Contains employee performance reviews, satisfaction levels, and ratings from both employees and managers.
Employee: Contains demographic and employment details of employees, such as age, gender, department, salary, and attrition status.
SatisfiedLevel: Satisfaction levels across various categories.
RatingLevel: Rating levels for employee performance.
EducationLevel: Education levels achieved by the employees.
Analyses Conducted
I have performed five key analyses using SQL, as outlined below:

## 1. Performance Analysis Based on Satisfaction
Goal: To determine whether there is a correlation between job satisfaction (work environment, job satisfaction, workplace relationships) and employee performance.

SQL Process:

Aggregate the ManagerRating by the JobSatisfaction, EnvironmentSatisfaction, and RelationshipSatisfaction fields.
Calculate the average performance rating for each satisfaction level.
SQL Query:

```sql
SELECT 
	JobSatisfaction,
	ROUND(AVG(managerrating), 2) AS AvgManagerRating
FROM performancerating
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction DESC;
```

## 2. Factors Influencing Employee Attrition
Goal: To identify the factors most associated with employee attrition (employees leaving the company). Does overtime, years at the company, or salary have a stronger impact on attrition?

SQL Process:

Group employees by attrition status (Yes/No) and calculate averages for years at the company, salary, and years since last promotion.
SQL Query:

```sql
SELECT attrition, 
AVG(yearsatcompany) AS AvgYearsAtCompany, 
AVG(Salary) AS AvgSalary, 
AVG(YearsSinceLastPromotion) AS AvgYearsSinceLastPromotion
FROM employee
GROUP BY Attrition;
```
## 3. Satisfaction vs. Years Since Last Promotion
Goal: To evaluate whether employees who have not been promoted in a while have lower job satisfaction.

SQL Process:

Join the employee and performance tables to analyze the correlation between job satisfaction and the number of years since the last promotion.
Calculate average years since the last promotion grouped by satisfaction levels.
SQL Query:
```sql
SELECT 
	JobSatisfaction,
	AVG(YearsSinceLastPromotion) AS "YearsSinceLastPromotion"
FROM employee
INNER JOIN performancerating
	ON performancerating.EmployeeID = employee.EmployeeID
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
```
## 4. Performance by Department
Goal: To identify which departments perform best on average by analyzing their ManagerRating.

SQL Process:

Join employee and performance tables to compare average manager ratings across different departments.
SQL Query:
```sql
SELECT 
	Department,
	AVG(ManagerRating) AS AvgManagerRating
FROM performancerating
INNER JOIN employee
	ON performancerating.EmployeeID = employee.EmployeeID
GROUP BY Department;
```

## 5. Analysis of Attributes Influencing High Performers
Goal: To identify common characteristics among high-performing employees by comparing various factors like satisfaction, years at the company, and work-life balance between high and low performers.

SQL Process:

Use a WITH clause to create two groups: high performers (employees with above-average ManagerRating) and low performers (those with below-average ratings).
Calculate the average values of factors like YearsAtCompany, TrainingOpportunitiesTaken, JobSatisfaction, and WorkLifeBalance for each group.
SQL Query:
```sql
WITH HighPerformers AS (
    SELECT pr.EmployeeID, 
           pr.ManagerRating, 
           em.YearsAtCompany, 
           em.YearsWithCurrManager, 
           em.StockOptionLevel, 
           pr.TrainingOpportunitiesTaken, 
           pr.WorkLifeBalance, 
           pr.JobSatisfaction, 
           pr.EnvironmentSatisfaction
    FROM performancerating pr
    JOIN employee em ON pr.EmployeeID = em.EmployeeID
    WHERE pr.ManagerRating > (SELECT AVG(ManagerRating) FROM performancerating)
), 
LowPerformers AS (
    SELECT pr.EmployeeID, 
           pr.ManagerRating, 
           em.YearsAtCompany, 
           em.YearsWithCurrManager, 
           em.StockOptionLevel, 
           pr.TrainingOpportunitiesTaken, 
           pr.WorkLifeBalance, 
           pr.JobSatisfaction, 
           pr.EnvironmentSatisfaction
    FROM performancerating pr
    JOIN employee em ON pr.EmployeeID = em.EmployeeID
    WHERE pr.ManagerRating <= (SELECT AVG(ManagerRating) FROM performancerating)
)
SELECT 
    'High Performers' AS PerformanceCategory,
    AVG(YearsAtCompany) AS AvgYearsAtCompany,
    AVG(YearsWithCurrManager) AS AvgYearsWithManager,
    AVG(StockOptionLevel) AS AvgStockOptionLevel,
    AVG(TrainingOpportunitiesTaken) AS AvgTrainingTaken,
    AVG(WorkLifeBalance) AS AvgWorkLifeBalance,
    AVG(JobSatisfaction) AS AvgJobSatisfaction,
    AVG(EnvironmentSatisfaction) AS AvgEnvironmentSatisfaction
FROM HighPerformers
UNION ALL
SELECT 
    'Low Performers' AS PerformanceCategory,
    AVG(YearsAtCompany) AS AvgYearsAtCompany,
    AVG(YearsWithCurrManager) AS AvgYearsWithManager,
    AVG(StockOptionLevel) AS AvgStockOptionLevel,
    AVG(TrainingOpportunitiesTaken) AS AvgTrainingTaken,
    AVG(WorkLifeBalance) AS AvgWorkLifeBalance,
    AVG(JobSatisfaction) AS AvgJobSatisfaction,
    AVG(EnvironmentSatisfaction) AS AvgEnvironmentSatisfaction
FROM LowPerformers;
```
