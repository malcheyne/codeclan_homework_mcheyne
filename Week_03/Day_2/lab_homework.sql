

--MVP
--Q1

/*(a). Find the first name, last name and team name of employees who are members of teams.

Hint
We only want employees who are also in the teams table. So which type of join should we use?*/

SELECT
	e.first_name,
	e.last_name,
	t.name AS team_name
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id	; 


/*(b). Find the first name, last name and team name of employees who are members of teams and are enrolled in the pension scheme.*/

SELECT
	e.first_name,
	e.last_name,
	t.name AS team_name
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id	
WHERE e.pension_enrol = TRUE;


/*(c). Find the first name, last name and team name of employees who are members of teams, where their team has a charge cost greater than 80.

Hint
charge_cost may be the wrong type to compare with value 80. Can you find a way to convert it without changing the database? */

SELECT
	e.first_name,
	e.last_name,
	t.name AS team_name,
	CAST ( t.charge_cost AS int4 )
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id	
WHERE CAST ( t.charge_cost AS int4 ) >= 80;


--MVP
--Q2

/*(a). Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them.

Hints
local_account_no and local_sort_code are fields in pay_details, and employee details are held in employees, so this query requires a JOIN.

What sort of JOIN is needed if we want details of all employees, even if they don’t have stored local_account_no and local_sort_code?*/

SELECT 
	e.*,
	p.local_account_no,
	p.local_sort_code
FROM employees AS e LEFT JOIN pay_details AS p
ON e.pay_detail_id = p.id	


/*(b). Amend your query above to also return the name of the team that each employee belongs to.

Hint
The name of the team is in the teams table, so we will need to do another join. */

SELECT 
	e.*,
	p.local_account_no,
	p.local_sort_code,
	t.name AS team_name
FROM 
	(employees AS e LEFT JOIN teams AS t
	ON e.team_id = t.id)
LEFT JOIN pay_details AS p
ON e.pay_detail_id = p.id;




--MVP
--Q3

 --   (a). Make a table, which has each employee id along with the team that employee belongs to.

SELECT 
	e.id,
	t.name AS team_name
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id;


/*    (b). Breakdown the number of employees in each of the teams.

    Hint
    You will need to add a group by to the table you created above.*/

SELECT 
	COUNT(e.id) AS employee_sum,
	t.name AS team_id
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.name;


 --   (c). Order the table above by so that the teams with the least employees come first. 

SELECT 
	COUNT(e.id) AS employee_sum,
	t.name AS team_id
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.name
ORDER BY employee_sum ASC;

--MVP
--Q4

--(a). Create a table with the team id, team name and the count of the number of employees in each team.

SELECT 
	COUNT(t.id) AS employee_sum,
	t.name AS team_id
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.name; 


-- Homework work thruogh
SELECT 
  t.id,  
  t.name,
  COUNT(e.id)
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id

/*(b). The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number 
 * of employees in the team. Calculate the total_day_charge for each team.

Hint
If you GROUP BY teams.id, because it’s the primary key, you can SELECT any other column of teams that you 
want (this is an exception to the rule that normally you can only SELECT a column that you GROUP BY).*/

SELECT 
	COUNT(t.id) AS employee_sum,
	t.name AS team_id,
	CAST ( t.charge_cost AS int4 ) * COUNT(t.id) AS total_day_charge
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
--WHERE CAST ( t.charge_cost AS int4 ) 
GROUP BY t.id;




-- (c). How would you amend your query from above to show only those teams with a total_day_charge greater than 5000? 

SELECT 
	COUNT(t.id) AS employee_sum,
	t.name AS team_id,
	CAST ( t.charge_cost AS int4 ) * COUNT(t.id) AS total_day_charge
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
HAVING CAST ( t.charge_cost AS int4 ) * COUNT(t.id) > 5000;

-- Homework work thruogh
-- EXT
-- Q5
-- How many of the employees serve on one or more committees?

SELECT
	COUNT(DISTINCT(employee_id)) AS num_employees_on_committees
FROM employees_committees;


-- Homework work thruogh
-- EXT
-- Q6
-- How many of the employees do not serve on a committee?

SELECT
	COUNT(*) AS num_not_in_comittees
FROM employees AS e
LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id
WHERE ec.employee_id IS NULL;

-- 2nd way to do it

SELECT 
  (SELECT COUNT(id) FROM employees) -
  (SELECT COUNT(DISTINCT(employee_id)) 
FROM employees_committees)
    AS num_not_in_committees

