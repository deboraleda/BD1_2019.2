-- Q1
SELECT COUNT(*) FROM employee AS e WHERE sex = 'F';

--Q2
SELECT avg(salary) FROM employee WHERE sex = 'M' AND address LIKE '%TX';

--Q3
SELECT DISTINCT e.superssn , count(e.ssn) AS qtd_supervisionados FROM employee AS e  GROUP BY e.superssn ORDER BY qtd_supervisionados;

-- Q4
SELECT fname, qtd_supervisionados FROM (SELECT s.fname, s.ssn, COUNT(*) AS qtd_supervisionados FROM employee AS e JOIN employee AS s ON
e.superssn = s.ssn GROUP BY s.ssn, s.fname) AS supervisores ORDER BY qtd_supervisionados;

-- Q5
SELECT fname, qtd_supervisionados FROM (SELECT s.fname, s.ssn, COUNT(*) AS qtd_supervisionados FROM employee AS e LEFT JOIN 
employee AS s ON e.superssn = s.ssn GROUP BY s.ssn, s.fname) AS supervisores ORDER BY qtd_supervisionados;

--Q6
SELECT MIN(qtdes) AS qtd FROM (SELECT pno, COUNT(*) AS qtdes FROM works_on GROUP BY pno) AS quantidade_funcs;

--Q7
SELECT pno, qtd FROM (SELECT pno, COUNT(*) AS qtd FROM works_on GROUP BY pno ) AS quantidades WHERE ( qtd) IN 
((SELECT MIN(qtdes) AS qtd FROM (SELECT COUNT(*) AS qtdes FROM works_on GROUP BY pno) AS quantidade_funcs));

--Q8
SELECT pno, AVG(salary) FROM employee, works_on WHERE essn = ssn GROUP BY pno;

--Q9
SELECT pno, pname, AVG(salary) FROM employee, works_on, project WHERE essn = ssn AND pnumber = pno GROUP BY pno, pname;

--Q10
SELECT fname, salary FROM (employee LEFT JOIN works_on ON essn = ssn) WHERE (pno <> 92 OR pno IS NULL) AND salary > ALL 
(SELECT salary FROM employee, works_on WHERE essn = ssn AND pno = 92);

--Q11
SELECT ssn, COUNT(pno) FROM (employee LEFT JOIN works_on ON essn = ssn) GROUP BY ssn ORDER BY COUNT(pno);  

--Q12
SELECT pno AS num_proj, qtd_func FROM (SELECT pno, COUNT(*) AS qtd_func FROM employee LEFT JOIN works_on ON ssn = essn GROUP BY pno HAVING COUNT(*) < 5) 
AS menos_de_5 ORDER BY qtd_func;

--Q13
SELECT fname FROM employee WHERE ssn IN (SELECT essn FROM works_on, project WHERE plocation = 'Sugarland' AND pno = pnumber) AND
ssn IN (SELECT essn FROM employee, dependent WHERE ssn = essn);

--Q14
SELECT dname FROM department WHERE NOT EXISTS (SELECT dnum FROM project WHERE dnumber = dnum);

--Q15
SELECT DISTINCT fname, lname FROM employee AS e, works_on WHERE essn = ssn AND ssn <> '123456789' AND NOT EXISTS ((SELECT pno FROM works_on WHERE essn = '123456789')
EXCEPT(SELECT pno FROM works_on WHERE essn = e.ssn));
