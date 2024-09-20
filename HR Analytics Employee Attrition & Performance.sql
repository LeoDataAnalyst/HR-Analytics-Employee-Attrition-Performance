-- The importation bring strange names to some columns, so let's change
ALTER TABLE educationlevel CHANGE ï»¿EducationLevelID EducationLevelID INT;
ALTER TABLE employee CHANGE ï»¿EmployeeID EmployeeID text;
ALTER TABLE performancerating CHANGE ï»¿PerformanceID PerformanceID text;
ALTER TABLE ratinglevel CHANGE ï»¿RatingID RatingID INT;
ALTER TABLE satisfiedlevel CHANGE ï»¿SatisfactionID SatisfactionID INT;

-- Let's check our tables
SELECT * FROM educationlevel;
SELECT * FROM employee;
SELECT * FROM performancerating;
SELECT * FROM ratinglevel;
SELECT * FROM satisfiedlevel;

-- Satisfaction Performance Analysis
-- Here we will find if exists relation between perfomance and satisfaction at the work
SELECT 
	JobSatisfaction,
	ROUND(AVG(managerrating), 2) AS AvgManagerRating
FROM performancerating
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction DESC;

-- Factors that Influence Employee Turnover
SELECT attrition, 
AVG(yearsatcompany) AS AvgYearsAtCompany, 
AVG(Salary) AS AvgSalary, 
AVG(YearsSinceLastPromotion) AS AvgYearsSinceLastPromotion
FROM employee
GROUP BY Attrition;

-- Working OverTime by department
SELECT Department,
	COUNT(OverTime)
FROM employee
GROUP BY Department;

-- Proportion OverTime Attrition
SELECT 
	(SELECT 
		COUNT(EmployeeID)
	FROM employee
	WHERE OverTime = "Yes" AND Attrition = "Yes") /
    (SELECT 
		COUNT(EmployeeID)
	FROM employee
	WHERE Attrition = "Yes") AS "Proportion OverTime Attrition";	

	
-- Relation between Satisfaction and Promotion
SELECT 
	JobSatisfaction,
	AVG(YearsSinceLastPromotion) AS "YearsSinceLastPromotion"
FROM employee
INNER JOIN performancerating
	ON performancerating.EmployeeID = employee.EmployeeID
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Performance by Department
SELECT 
	Department,
	AVG(ManagerRating) AS AvgManagerRating
FROM performancerating
INNER JOIN employee
	ON performancerating.EmployeeID = employee.EmployeeID
GROUP BY Department;

-- Analysis of Attributes Influencing High Performers
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







