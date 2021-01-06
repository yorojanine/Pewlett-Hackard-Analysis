-- Creating tables for PH-EmployeeDB
DROP TABLE departments CASCADE;
CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);
/*A constraint is a rule that is applied to a column in a SQL table. 
It will limit the data in a way that provides more accuracy and reliability when working with it.
The unique constraint implies that the data in that column is unique. 
This ensures that if the table were to be updated in the future, nothing will be duplicated.
Take the table holding all of the department names and numbers, for example. 
Say that a developer wanted to update that table to add a new department, but reused department number d007.
If that were to happen, then d007 would reference current Sales Employees and 
Employees in the new department. Not a great situation, right? 
This creates dirty data, or data that is flawed, and would require extensive cleaning to fix.*/
DROP TABLE employees CASCADE;
CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

DROP TABLE dept_manager CASCADE;
CREATE TABLE dept_manager(
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
 	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)	
);

DROP TABLE salaries CASCADE;
CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

DROP TABLE dept_emp CASCADE;
CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
 	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

DROP TABLE titles CASCADE;
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, title, from_date),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- DROP TABLE titles2
-- CREATE TABLE titles2 (
-- 	emp_no INT NOT NULL,
-- 	title VARCHAR NOT NULL,
-- 	from_date DATE NOT NULL,
-- 	to_date DATE NOT NULL,
-- 	PRIMARY KEY (emp_no),
-- 	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
-- );

--loaded
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;
---not working because they had multiple FKs -- fixed
SELECT * FROM dept_emp; 
SELECT * FROM dept_manager;

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01'AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
--22,857

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
--23,228


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';
--23,104

-- Retirement eligibility --90,398
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--41,380

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--***************************************************************************
--***************************************************************************
DROP TABLE retirement_info;
SELECT emp_no,first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;


-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
		retirement_info.first_name,
		retirement_info.last_name,
		dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

--readability
SELECT ri.emp_no,
		ri.first_name,
		ri.last_name,
		de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE to_date = ('9999-01-01');

SELECT * FROM current_emp;
--33,118

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Employee count by department number
SELECT 
de.dept_no,
COUNT(ce.emp_no)
INTO emp_count_bydept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');
 
select * from emp_info
limit 10;

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT ri.*
-- ,de.dept_no
,d.dept_name
FROM retirement_info as ri
LEFT JOIN dept_emp as de
on ri.emp_no = de.emp_no
LEFT JOIN departments as d
on de.dept_no = d.dept_no
WHERE de.dept_no IN ('d007','d005')
-- WHERE de.dept_no = 'd007'
-- LIMIT 10;

select * from departments;
