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
ORDER BY rt.emp_no, to_date DESC;
------------------------------------------------------------------
SELECT 
COUNT(emp_no),
title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;
----------------------