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








