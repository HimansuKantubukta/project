 CREATE PROCEDURE update_salary
    (IN employee_number CHAR(6), IN rating INT)
    LANGUAGE SQL
    BEGIN
      DECLARE SQLSTATE CHAR(5);
      DECLARE not_found CONDITION FOR SQLSTATE '02000';
      DECLARE EXIT HANDLER FOR not_found
        SIGNAL SQLSTATE '02444';

      CASE rating
        WHEN 1 THEN 
          UPDATE employee
          SET salary = salary * 1.10, bonus = 1000
          WHERE empno = employee_number;
        WHEN 2 THEN 
          UPDATE employee
          SET salary = salary * 1.05, bonus = 500
          WHERE empno = employee_number;
        ELSE
          UPDATE employee
          SET salary = salary * 1.03, bonus = 0
          WHERE empno = employee_number;
       END CASE;
    END @
