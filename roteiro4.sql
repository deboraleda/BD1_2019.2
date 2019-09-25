--Debora Leda

--Q1

SELECT * FROM department;

--Q2

SELECT * FROM dependent;

--Q3

SELECT * FROM dept_locations;

--Q4

SELECT * FROM employee;

--Q5

SELECT * FROM project;

--Q6

SELECT * FROM works_on;

--Q7

SELECT fname, lname FROM employee WHERE sex = 'M';

--Q8

SELECT fname FROM employee WHERE sex = 'M' AND superssn IS NULL;

--Q9

SELECT f.fname, s.fname FROM employee AS f, employee AS s WHERE f.superssn = s.ssn;

--Q10

SELECT F.fname FROM employee AS F, employee AS S WHERE F.superssn = S.ssn AND S.fname = 'Franklin';

--Q11

SELECT  dname, dlocation FROM department, dept_locations WHERE department.dnumber = dept_locations.dnumber;

--Q12

SELECT dname FROM department, dept_locations WHERE department.dnumber = dept_locations.dnumber AND dlocation LIKE 'S%';

--Q13

SELECT fname, lname, dependent_name FROM employee, dependent WHERE ssn = essn;

--Q14

SELECT (fname || minit || lname) AS full_name, salary FROM employee WHERE salary > 50000;

--Q15

SELECT pname, dname FROM project, department WHERE dnum = dnumber;

--Q16

SELECT pname, fname FROM project, employee, department WHERE dnum = dnumber AND mgrssn = ssn AND pnumber > 30;

--Q17

SELECT pname, fname FROM project, works_on, employee WHERE pnumber = pno AND essn = ssn;

--Q18

SELECT fname, dependent_name, relationship FROM project, dependent, employee, works_on WHERE pnumber = 91 AND pno = pnumber
AND employee.ssn = works_on.essn AND dependent.essn = employee.ssn;

































