----------------
--DELIVERABLE 1
----------------
SELECT
	e.emp_no
	,e.first_name
	,e.last_name
	,ti.title
	,ti.from_date
	,ti.to_date
INTO retirement_titles
FROM
employees AS e
INNER JOIN titles AS ti
	ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

------------------------------------------------------------------
SELECT DISTINCT ON
(rt.emp_no) emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles rt
ORDER BY rt.emp_no, rt.to_date DESC;
------------------------------------------------------------------
SELECT 
COUNT(emp_no),
title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;

------------------------------------------------------------------
----------------
--DELIVERABLE 2
----------------
SELECT 
DISTINCT ON (e.emp_no) e.emp_no
	,e.first_name
	,e.last_name
	,e.birth_date
	,de.from_date
	,de.to_date
	,ti.title
INTO mentorship_eligibility
FROM employees AS e
	INNER JOIN dept_emp AS de 
		ON e.emp_no = de.emp_no
	INNER JOIN titles AS ti
		ON e.emp_no = ti.emp_no
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no, ti.to_date DESC;

---------this emp doesn't match the image in challenge -- staff vs senior staff
select * from dept_emp
where emp_no = '10291';

select * from titles
where emp_no = '10291';

----------ADDITIONAL CODE (README)
SELECT 
COUNT(emp_no),
title
FROM mentorship_eligibility
GROUP BY title
ORDER BY COUNT DESC;

SELECT COUNT(*) FROM mentorship_eligibility;
--1,549 eligible mentors


SELECT me.*,de.dept_no,d.dept_name 
INTO TEMP TABLE me_dept_count
FROM mentorship_eligibility AS me
INNER JOIN dept_emp AS de
	ON me.emp_no = de.emp_no
INNER JOIN departments AS d
	ON de.dept_no = d.dept_no;

SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title,
dept_no,
dept_name
INTO TEMP TABLE me_dept_count2
FROM me_dept_count
ORDER BY emp_no, dept_name;

SELECT COUNT(emp_no),
dept_no,
dept_name
FROM me_dept_count2
GROUP BY dept_no,
dept_name
ORDER BY 1 DESC;


select sum(count) from retiring_titles;
--90,398 retiring employees


--////////////////////
--PNG PULLS
SELECT * FROM retirement_titles
LIMIT 10;

SELECT * FROM unique_titles
LIMIT 10;

SELECT * FROM retiring_titles
LIMIT 10;

SELECT * FROM mentorship_eligibility
LIMIT 10;

SELECT * FROM me_dept_count2
LIMIT 10;


