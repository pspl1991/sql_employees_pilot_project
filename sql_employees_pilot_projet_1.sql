#Select the information from the “emp_no” column of the “employees” table.

SELECT
emp_no
FROM
employees;
SELECT
*
FROM
employees

#Inside employees table, use the IN operator to select all individuals
#whose first name is "Mary" or "Alain".as

SELECT

*
FROM

employees

WHERE
first_name IN ('MARY', 'ALAIN'); 


#Select exclusively the names of all departments whose department number value is NOT NULL

SELECT
dept_name
FROM
departments
WHERE
dept_no IS NOT NULL;

#Organize all data from employees table, ordering it by last_name in ascending order

SELECT
*
FROM
employees
order by last_name ASC;

#OR by hire_date in descending order

SELECT
*
FROM
employees
order by hire_date DESC;

#Select the employee numbers of all individuals who have signed 
#more than 1 contract after the 1st of January 1997.

SELECT
emp_no
FROM
dept_emp
WHERE
from_date >'1997-01-01'
group by emp_no
HAVING COUNT(from_date)>1
order by emp_no;

#OR just 1 contract after the 1st of January 2000

SELECT
emp_no
FROM
dept_emp
WHERE
from_date>'2000-01-01'
GROUP BY 
emp_no
HAVING count(from_date)<1
order by emp_no;

#Join the 'employees' and the 'dept_manager' tables to return a subset of all the employees 
#whose last name is Markovitch

SELECT
e.emp_no,
e.first_name,
e.last_name,
dm.dept_no,
dm.from_date
FROM
employees e 
LEFT JOIN
dept_manager dm ON e.emp_no = dm.emp_no  

WHERE  

    e.last_name = 'Markovitch'  

ORDER BY dm.dept_no ASC, e.emp_no;

#The average salary of male and female employees in each department.
SELECT
    d.dept_name, e.gender, AVG(salary)
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON d.dept_no = de.dept_no
GROUP BY de.dept_no , e.gender
ORDER BY de.dept_no;

#The lowest department number encountered the 'dept_emp' table and the highest department number.
SELECT
    MIN(dept_no)
FROM
    dept_emp;

SELECT
    MAX(dept_no)
FROM
    dept_emp;
    
# The procedure that asks you to insert an employee number to obtain an output containing the same number, as well as the number and name of the last department the employee has worked for.
# The procedure will calls employee number 10010.

DROP procedure IF EXISTS last_dept;

DELIMITER $$
CREATE PROCEDURE last_dept (in p_emp_no integer)
BEGIN
SELECT
    e.emp_no, d.dept_no, d.dept_name
FROM
    employees e
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
WHERE
    e.emp_no = p_emp_no
        AND de.from_date = (SELECT
            MAX(from_date)
        FROM
            dept_emp
        WHERE
            emp_no = p_emp_no);
END$$
DELIMITER ;

call employees.last_dept(10010);

#The function that retrieves the largest contract salary value of the nº 11356 employee.
#Then, the lowest salary value per contract of the same employee

DROP FUNCTION IF EXISTS f_highest_salary;

DELIMITER $$
CREATE FUNCTION f_highest_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

DECLARE v_highest_salary DECIMAL(10,2);

SELECT
    MAX(s.salary)
INTO v_highest_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;

RETURN v_highest_salary;
END$$

DELIMITER ;


SELECT f_highest_salary(11356);


DROP FUNCTION IF EXISTS f_lowest_salary;

DELIMITER $$
CREATE FUNCTION f_lowest_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

DECLARE v_lowest_salary DECIMAL(10,2);

SELECT
    MIN(s.salary)
INTO v_lowest_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;

RETURN v_lowest_salary;
END$$

DELIMITER ;


SELECT f_lowest_salary(10356);

