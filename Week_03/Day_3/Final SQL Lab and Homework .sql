

-- Q1
-- How many employee records are lacking both a grade and salary?

SELECT 
  COUNT(id) AS number_employees 
FROM employees 
WHERE (grade, salary) IS NULL ;

-- Q2
/* Produce a table with the two following fields (columns):

    the department
    the employees full name (first and last name)

Order your resulting table alphabetically by department, and then by last name*/

SELECT
	department,
	CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
ORDER BY department, last_name;

-- Q3
-- Find the details of the top ten highest paid employees who have a last_name beginning with ‘A’.

SELECT *
FROM employees
WHERE last_name LIKE 'A%'
ORDER BY salary DESC NULLS LAST
LIMIT 10;

--Q4
-- Obtain a count by department of the employees who started work with the corporation in 2003.

SELECT
	department,
	COUNT(id)
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;

-- BETWEEN is inclusive

-- Q5
/*Obtain a table showing department, fte_hours and the number of employees in each department who 
 * work each fte_hours pattern. Order the table alphabetically by department, and then in ascending 
 * order of fte_hours.
Hint
You need to GROUP BY two columns here. */

SELECT
	department,
	fte_hours,
	COUNT(id) AS number_of_employees
FROM employees
GROUP BY department, fte_hours
ORDER BY department, fte_hours;


--Q6
/*Provide a breakdown of the numbers of employees enrolled, not enrolled, 
 * and with unknown enrollment status in the corporation pension scheme.
 */

SELECT
	pension_enrol,
	COUNT(id) AS numbers_of_employees
FROM employees
GROUP BY pension_enrol;

--Q7
-- Obtain the details for the employee with the highest salary in the ‘Accounting’ 
--department who is not enrolled in the pension scheme?

SELECT *
FROM employees
WHERE department = 'Accounting' AND pension_enrol = FALSE
ORDER BY salary DESC NULLS LAST
LIMIT 1;


--Q8
/* Get a table of country, number of employees in that country, and the average salary of employees 
 * in that country for any countries in which more than 30 employees are based. Order the table by average salary descending.

Hints
A HAVING clause is needed to filter using an aggregate function. 

*You can pass a column alias to ORDER BY. */

SELECT
	country,
	COUNT(id) AS number_of_employees,
	AVG(salary) AS average_salary
FROM employees
GROUP BY country
HAVING  COUNT(id) > 30
ORDER BY AVG(salary) DESC;

--09
/* Return a table containing each employees first_name, last_name, 
 * full-time equivalent hours (fte_hours), salary, and a new column 
 * effective_yearly_salary which should contain fte_hours multiplied by salary. 
 * Return only rows where effective_yearly_salary is more than 30000.

 */

SELECT
	first_name, 
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_yearly_salary
FROM employees	
WHERE fte_hours * salary > 3000;	
	
	
--Q10
/*Find the details of all employees in either Data Team 1 or Data Team 2
Hint
name is a field in table `teams */

SELECT *
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
WHERE t.name = 'Data Team 1' OR t.name = 'Data Team 2';


-- Q11
/*Find the first name and last name of all employees who lack a local_tax_code.

Hint
local_tax_code is a field in table pay_details, and first_name and last_name are fields in table employees*/

SELECT
	first_name, 
	last_name
FROM employees AS e LEFT JOIN pay_details AS p
ON e.pay_detail_id = p.id
WHERE local_tax_code IS NULL;

-- Q12
/*The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, 
 * where charge_cost depends upon the team to which the employee belongs. Get a table showing expected_profit for each employee.

Hints
charge_cost is in teams, while salary and fte_hours are in employees, so a join will be necessary

You will need to change the type of charge_cost in order to perform the calculation */

SELECT 
	e.id,
	e.first_name, 
	e.last_name,
	(48 * 35 * CAST ( t.charge_cost AS int4 ) - e.salary) * e.fte_hours AS expected_profit
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id;

-- Q13
/*Find the first_name, last_name and salary of the lowest paid employee in Japan who works the least common full-time 
 * equivalent hours across the corporation.”
Hint
You will need to use a subquery to calculate the mode */

SELECT
	first_name, 
	last_name, 
	salary
FROM employees
WHERE country = 'Japan' AND fte_hours IN (
  SELECT fte_hours
  FROM employees
  GROUP BY fte_hours
  HAVING COUNT(*) = (
    SELECT MIN(count)
    FROM (
      SELECT COUNT(*) AS count
      FROM employees
      GROUP BY fte_hours
    ) AS temp
  )
)
ORDER BY salary 
LIMIT 1;


--Q14
/* Obtain a table showing any departments in which there are two or more employees lacking 
 * a stored first name. Order the table in descending order of the number of employees lacking a 
 * first name, and then in alphabetical order by department.*/

SELECT
	department,
	COUNT(id) AS number_of_employees
FROM employees
WHERE first_name IS NULL
GROUP BY department
HAVING COUNT(id) >= 2
ORDER BY number_of_employees DESC, department ;


-- Q15
/* Return a table of those employee first_names shared by more than one employee, together with a count 
 * of the number of times each first_name occurs. Omit employees without a stored first_name from the table. 
 * Order the table descending by count, and then alphabetically by first_name.
 */

SELECT
	first_name,
	COUNT(id) AS number_of_employees
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name
HAVING COUNT(id) >1
ORDER BY number_of_employees DESC, first_name;


-- Q16
/* Find the proportion of employees in each department who are grade 1.
Hints
Think of the desired proportion for a given department as the number of employees in that department who are grade 1, 
divided by the total number of employees in that department.


You can write an expression in a SELECT statement, e.g. grade = 1. This would result in BOOLEAN values.


If you could convert BOOLEAN to INTEGER 1 and 0, you could sum them. The CAST() function lets you convert data types.


In SQL, an INTEGER divided by an INTEGER yields an INTEGER. To get a REAL value, you need to convert the top, bottom or 
both sides of the division to REAL. */

SELECT
	department,
	SUM(CAST( grade = '1' AS INT )) / CAST(COUNT(id) AS REAL) AS prop_grade_1
FROM employees
GROUP BY department;

-- Class work out to round the number 
SELECT 
	department ,
	CAST(SUM(CAST(grade = '1' AS INT)) / CAST(COUNT(id) AS REAL)AS DECIMAL(10,2)) AS proportion_in_grade_1
FROM employees
GROUP BY department;

-- Ricardo work 
WITH table1 AS (SELECT COUNT(*), department, grade
	FROM employees
	WHERE grade IS NOT NULL
	GROUP BY department, grade
	ORDER BY department),
table2 AS (SELECT COUNT(*) AS total_count, department 
	FROM employees
	WHERE grade IS NOT NULL 
	GROUP BY department
	ORDER BY department)
SELECT table1.department,
table1.count,
table2.total_count,
CAST(table1.count AS REAL) / CAST(table2.total_count AS REAL) AS proportion
FROM table1 LEFT JOIN table2
ON table1.department = table2.department
WHERE table1.grade = 1
ORDER BY proportion DESC;







-