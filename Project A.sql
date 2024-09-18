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




