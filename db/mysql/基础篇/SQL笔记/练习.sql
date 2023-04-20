SELECT last_name,salary,department_id
FROM employees
WHERE department_id = 50 XOR salary > 6000;