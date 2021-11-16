/* MVP */
/* Q1 */
/* Find all the employees who work in the ‘Human Resources’ department.*/

SELECT *
FROM employees
WHERE department = 'Human Resources';

/* MVP */
/* Q2 */
/* Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.*/

SELECT 
	first_name, 
	last_name, 
	country
FROM employees
WHERE department = 'Legal'; 

/* MVP */
/* Q3 */
/* Count the number of employees based in Portugal. */

SELECT 
  COUNT(*) AS portugal_based
FROM employees 
WHERE country = 'Portugal';

/* MVP */
/* Q4 */
/* Count the number of employees based in either Portugal or Spain.*/

SELECT 
	COUNT(*) AS portugal_based
FROM employees 
WHERE country = 'Spain';

/* Homework anwser */
SELECT 
  COUNT(id) AS num_employees_Portugal_Spain
FROM employees
WHERE country IN ('Portugal', 'Spain'

/* MVP */
/* Q5 */
/* Count the number of pay_details records lacking a local_account_no. */

SELECT 
	COUNT(*) AS missing_accouts
FROM pay_details 
WHERE local_account_no IS NULL;

/* MVP */
/* Q6 */
/* Are there any pay_details records lacking both a local_account_no and iban number?*/

SELECT 
	COUNT(*) AS missing_accouts
FROM pay_details 
WHERE local_account_no IS NULL AND iban IS NULL;

/* MVP */
/* Q7 */
/* Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).*/

SELECT 
	first_name, 
	last_name 
FROM employees 
ORDER BY 
	last_name ASC NULLS LAST;
	
/* MVP */
/* Q8 */
/* Get a table of employees first_name, 
 * last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last).*/

SELECT
	first_name, 
	last_name,
	country
FROM employees 
ORDER BY 
	country ASC NULLS LAST,
	last_name ASC NULLS LAST;

/* MVP */
/* Q9 */
/* Find the details of the top ten highest paid employees in the corporation.*/

SELECT *
FROM employees
ORDER BY
	salary DESC NULLS LAST
LIMIT 10;

/* MVP */
/* Q10 */
/* Find the first_name, last_name and salary of the lowest paid employee in Hungary.*/

SELECT 
	first_name, 
	last_name, 
	salary
FROM employees
WHERE country = 'Hungary'
ORDER BY
	salary ASC NULLS LAST
LIMIT 1;

/* MVP */
/* Q11 */
/* How many employees have a first_name beginning with ‘F’?*/

SELECT 
  COUNT(*) AS employees_beginning_f
FROM employees 
WHERE first_name LIKE 'F%';

SELECT 
  first_name
FROM employees 
WHERE first_name LIKE 'F%';

/* MVP */
/* Q12 */
/* Find all the details of any employees with a ‘yahoo’ email address?*/

SELECT *
FROM employees
WHERE email LIKE '%yahoo%';

/* MVP */
/* Q13 */
/* Count the number of pension enrolled employees not based in either France or Germany.*/

SELECT 
  COUNT(*) AS pension_miss_fra_ger
FROM employees 
WHERE pension_enrol IS TRUE AND 
	country  NOT IN ('France', 'Germany');

SELECT 
  COUNT(*) AS pension_miss_fra_ger
FROM employees 
WHERE pension_enrol IS TRUE;

/* 13 diffrent*/

SELECT *
FROM employees 
WHERE pension_enrol IS TRUE AND 
	country IN ('France', 'Germany');

/* MVP */
/* Q14 */
/* What is the maximum salary among 
 * those employees in the ‘Engineering’ department who 
 * work 1.0 full-time equivalent hours (fte_hours)?*/

SELECT 
	salary,
	fte_hours
FROM employees 
WHERE department = 'Engineering' AND fte_hours >= 1.0;

SELECT 
	salary
FROM employees 
WHERE department = 'Engineering' AND fte_hours >= 1.0
ORDER BY salary DESC
LIMIT 1;

/* Homework anwser*/
SELECT 
  MAX(salary) AS max_salary_engineering_ft
FROM employees
WHERE department = 'Engineering' AND fte_hours = 

/* MVP */
/* Q15 */
/* Return a table containing each employees first_name, 
 * last_name, full-time equivalent hours (fte_hours), salary, 
 * and a new column effective_yearly_salary which should 
 * contain fte_hours multiplied by salary.*/

SELECT 
	first_name, 
 	last_name,
 	fte_hours,
 	salary, 
 	(fte_hours*salary) AS effective_yearly_salary
 FROM employees;

/* EXT */
/* Q16 */
/* The corporation wants to make name badges for a forthcoming conference. 
 * Return a column badge_label showing employees’ first_name and last_name 
 * joined together with their department in the following style: ‘Bob Smith - Legal’. 
 * Restrict output to only those employees with stored first_name, last_name and department. 
 */

SELECT  
  first_name, 
  last_name, 
  department,
  CONCAT(first_name, ' ', last_name, ' ', '-', ' ', department) AS badge_label
FROM employees
WHERE (first_name, last_name, department) IS NOT NULL;

/* EXT */
/* Q17 */
/* One of the conference organisers thinks it would be nice to add the year of the 
 employees’ start_date to the badge_label to celebrate long-standing colleagues, in 
 the following style ‘Bob Smith - Legal (joined 1998)’. Further restrict output to only 
 those employees with a stored start_date.

[If you’re really keen - try adding the month as a string: ‘Bob Smith - Legal (joined July 1998)’] */

SELECT  
  first_name, 
  last_name, 
  department,
  start_date,
  CONCAT(first_name, ' ', last_name, ' ', '-', ' ', department, ' ', '(', 'joined', ' ', start_date, ')') AS badge_label
FROM employees
WHERE (first_name, last_name, department, start_date) IS NOT NULL;



SELECT  
  first_name, 
  last_name, 
  department,
  format(start_date, 'MMM-yy') AS month_year, 
  CONCAT(first_name, ' ', last_name, ' ', '-', ' ', department, ' ', '(', 'joined', ' ', month_year,')') AS badge_label
FROM employees
WHERE (first_name, last_name, department, start_date) IS NOT NULL;

/* homework answers*/
SELECT
  first_name,
  last_name,
  department,
  start_date,
  CONCAT(
    first_name, ' ', last_name, ' - ', department, 
    ' (joined ', EXTRACT(YEAR FROM start_date), ')'
  ) AS badge_label
FROM employees
WHERE 
  first_name IS NOT NULL AND 
  last_name IS NOT NULL AND 
  department IS NOT NULL AND
  start_date IS NOT NULL;
 /* homework answers*/ 
SELECT
  first_name,
  last_name,
  department,
  start_date,
  CONCAT(
    first_name, ' ', last_name, ' - ', department, ' (joined ', 
    TO_CHAR(start_date, 'FMMonth'), ' ', TO_CHAR(start_date, 'YYYY'), ')'
  ) AS badge_label
FROM employees
WHERE 
  first_name IS NOT NULL AND 
  last_name IS NOT NULL AND 
  department IS NOT NULL AND
  start_date IS NOT NULL;

/* EXT */
/* Q18 */
/* Return the first_name, last_name and salary of all employees together 
 * with a new column called salary_class with a value 'low' where salary is less 
 * than 40,000 and value 'high' where salary is greater than or equal to 40,000. */

SELECT 
	first_name, 
  	last_name,
  	salary,
  		CASE WHEN salary IS NULL THEN 'Unknown'
  		WHEN salary >= 40000 THEN 'high'
  					ELSE 'low' END AS salary_class		
FROM employees;



/* https://www.sqlshack.com/understanding-sql-server-case-statement/
 * You can evaluate multiple conditions in the CASE statement.

Let’s write a SQL Server CASE statement which sets the value of the condition column to “New” if the value in the model column is greater than 2010, to ‘Average’ if the value in the model column is greater than 2000, and to ‘Old’ if the value in the model column is greater than 1990.

Look at the following script:*/

SELECT name,
       model,
       CASE WHEN model > 2010 THEN 'New'
      WHEN model > 2000 THEN 'Average'
      WHEN model > 1990 THEN 'Old'
                ELSE 'Old' END AS condition
  FROM Cars