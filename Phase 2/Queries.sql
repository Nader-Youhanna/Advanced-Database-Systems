USE [master]
GO
    CREATE DATABASE [ADB Project DB]
GO
    USE [ADB Project DB]
GO
    ------------------------------CREATE EMPLOYEE TABLE------------------------------------------------------
    CREATE TABLE Employee(
        Fname VARCHAR(15) NOT NULL,
        Minit VARCHAR(1) NOT NULL,
        Lname VARCHAR(15) NOT NULL,
        Ssn INT,
        Bdate DATE NOT NULL,
        Address VARCHAR(20) NOT NULL,
        Sex VARCHAR(1) NOT NULL,
        Salary INT NOT NULL,
        Super_Ssn INT,
        Dno INT,
        PRIMARY KEY (Ssn)
    )
GO
    ------------------------------CREATE DEPARTMENT TABLE------------------------------------------------------
    CREATE TABLE Department(
        Dname VARCHAR(15) NOT NULL,
        Dnumber INT,
        PRIMARY KEY (Dnumber)
    )
GO
    -------------------------------CREATE WORKS_ON TABLE-----------------------------------------------------
    CREATE TABLE Works_On(
        Essn INT,
        Pno INT,
        Hours INT NOT NULL PRIMARY KEY (Essn, Pno),
    )
GO
    -----------------------------------CREATE PROJECT TABLE-------------------------------------------------
    CREATE TABLE Project(
        Pname VARCHAR(15),
        Pnumber INT,
        Plocation VARCHAR(15),
        Dnum INT,
        PRIMARY KEY (Pnumber)
    )
GO
    ---------------------------------CREATE DEPENDENT TABLE---------------------------------------------------
    CREATE TABLE Dependent(
        Essn INT,
        Dependent_Name VARCHAR(15),
        Sex VARCHAR(1) NOT NULL,
        Bdate DATE NOT NULL,
        Relationship VARCHAR(15) NOT NULL,
        PRIMARY KEY (Essn, Dependent_Name)
    )
GO
    ---------------------------------CREATE DEPARTMENT LOCATION TABLE---------------------------------------------------
    CREATE TABLE Department_Location(
        Dnumber INT,
        Dlocation VARCHAR(15) NOT NULL,
        PRIMARY KEY (Dnumber, Dlocation)
    )
GO
    ------------------------------------ADD SUPER SSN FK TO EMPLOYEE------------------------------------------------
ALTER TABLE
    Employee
ADD
    CONSTRAINT FK_Employee_Super_Ssn FOREIGN KEY (Super_Ssn) REFERENCES Employee(Ssn) ON DELETE NO ACTION
GO
    -----------------------------------ADD DNO FK TO EMPLOYEE-------------------------------------------------
ALTER TABLE
    Employee
ADD
    CONSTRAINT FK_Employee_Dno FOREIGN KEY (Dno) REFERENCES Department(Dnumber) ON DELETE NO ACTION
GO
    ----------------------------------ADD ESSN FK TO WORKS_ON--------------------------------------------------
ALTER TABLE
    Works_On
ADD
    CONSTRAINT FK_Works_On_Essn FOREIGN KEY (Essn) REFERENCES Employee(Ssn) ON DELETE CASCADE
GO
    -------------------------------------ADD PNO FK TO WORKS_ON-----------------------------------------------
ALTER TABLE
    Works_On
ADD
    CONSTRAINT FK_Works_On_Pno FOREIGN KEY (Pno) REFERENCES Project(Pnumber) ON DELETE CASCADE
GO
    -------------------------------------ADD DNUM FK TO PROJECT-----------------------------------------------
ALTER TABLE
    Project
ADD
    CONSTRAINT FK_Project_Dnum FOREIGN KEY (Dnum) REFERENCES Department(Dnumber) ON DELETE CASCADE
GO
    --------------------------------------ADD ESSN FK TO DEPENDENT----------------------------------------------
ALTER TABLE
    Dependent
ADD
    CONSTRAINT FK_Dependent_Essn FOREIGN KEY (Essn) REFERENCES Employee(Ssn) ON DELETE CASCADE
GO
    --------------------------------------ADD DNUMBER FK TO DEPARTMENT_LOCATION----------------------------------------------
ALTER TABLE
    Department_Location
ADD
    CONSTRAINT FK_Department_Location_Dnumber FOREIGN KEY (Dnumber) REFERENCES Department(Dnumber) ON DELETE CASCADE
GO
    ---------------------------------- CLEAR THE CACHE ----------------------------------
    DBCC DROPCLEANBUFFERS
GO
    ------------------------------ FIRST QUERY ------------------------------------------------------
    --  NON OPTIMIZED QUERY
SELECT
    Employee.Fname,
    Employee.Lname,
    Employee.Salary,
    Pname
FROM
    Employee INNER LOOP
    JOIN Works_On ON Employee.Ssn = Works_On.Essn INNER LOOP
    JOIN Project ON Works_On.Pno = Project.Pnumber
WHERE
    Project.Pname = 'Emily13'
ORDER BY
    Employee.Salary DESC
GO
    --  OPTIMIZED QUERY
SELECT
    Employee.Fname,
    Employee.Lname,
    Employee.Salary,
    Pname
FROM
    Employee
    INNER JOIN Works_On ON Employee.Ssn = Works_On.Essn
    INNER JOIN Project ON Works_On.Pno = Project.Pnumber
WHERE
    Project.Pname = 'Emily13'
ORDER BY
    Employee.Salary DESC
GO
    --  Add non clustered index on Employee.SSN
    CREATE NONCLUSTERED INDEX IX_Employee_Ssn ON Employee(Ssn)
GO
    -- add non clustered index on Project.Pnumber
    CREATE NONCLUSTERED INDEX IX_Project_Pnumber ON Project(Pnumber)
GO
    -- remove the non clustered index on Employee.Ssn
    DROP INDEX IX_Employee_Ssn ON Employee
GO
    -- remove the non clustered index on Project.Pnumber
    DROP INDEX IX_Project_Pnumber ON Project
GO
    ------------------------------ SECOND QUERY ------------------------------------------------------
    --  We want to select the managers for employees that has salaries more than 10000 and work on project with Pnumber greater than 500
    -- NON OPTIMIZED
SELECT
    Employee.Fname,
    Employee.Salary,
    Employee.Super_Ssn,
    Pname,
    Hours
FROM
    Employee INNER LOOP
    JOIN Works_On ON Employee.Ssn = Works_On.Essn INNER LOOP
    JOIN Project ON Works_On.Pno = Project.Pnumber
WHERE
    Hours > 500
    AND Salary in (
        SELECT
            Salary
        FROM
            Employee
        WHERE
            Salary > 10000
    )
    AND Pnumber in (
        SELECT
            Pnumber
        FROM
            Project
        WHERE
            Pnumber > 500
    )
GO
    -- OPTIMIZED
SELECT
    Employee.Fname,
    Employee.Salary,
    Employee.Super_Ssn,
    Pname,
    Hours
FROM
    Employee
    INNER JOIN Works_On ON Employee.Ssn = Works_On.Essn
    INNER JOIN Project ON Works_On.Pno = Project.Pnumber
WHERE
    Salary > 10000
    AND Pnumber > 500
    AND Hours > 500
GO
    --  Add non clustered index on Employee.SSN
    CREATE NONCLUSTERED INDEX IX_Employee_Ssn ON Employee(Ssn)
GO
    -- add non clustered index on Project.Pnumber
    CREATE NONCLUSTERED INDEX IX_Project_Pnumber ON Project(Pnumber)
GO
    -- remove the non clustered index on Employee.Ssn
    DROP INDEX IX_Employee_Ssn ON Employee
GO
    -- remove the non clustered index on Project.Pnumber
    DROP INDEX IX_Project_Pnumber ON Project
GO
    ----------------------------------------   THIRD QUERY -------------------------------------------------
    --  We want to select the employee Name, Salary, Super_Ssn, Pname, Hours for employees that has salaries more than 10000 and work on project with Hours greater than 500
    -- NON OPTIMIZED
SELECT
    DISTINCT E.Fname,
    E.Salary,
    E.Super_Ssn,
    Pname,
    Hours
FROM
    Employee E,
    Employee M,
    Works_On W,
    Project P
WHERE
    Hours > 500
    AND E.Ssn = W.Essn
    AND W.Pno = P.Pnumber
    AND E.Super_Ssn in (
        SELECT
            M.Ssn
        FROM
            Employee E,
            Employee M
        WHERE
            E.Super_Ssn = M.Ssn
            AND E.Salary > 10000
    )
GO
    -- OPTIMIZED
SELECT
    DISTINCT E.Fname,
    E.Salary,
    E.Super_Ssn,
    Pname,
    Hours
FROM
    Employee E
    INNER join Employee M on E.Super_Ssn = M.Ssn
    inner join Works_On W on E.Ssn = W.Essn
    INNER join Project P on W.Pno = P.Pnumber
WHERE
    Hours > 500
    AND E.Salary > 10000
GO
    --  Add non clustered index on Employee.SSN
    CREATE NONCLUSTERED INDEX IX_Employee_Ssn ON Employee(Ssn)
GO
    -- Add non clustered index on Project.Pnumber
    CREATE NONCLUSTERED INDEX IX_Project_Pnumber ON Project(Pnumber)
GO
    -- Remove the non clustered index on Employee.Ssn
    DROP INDEX IX_Employee_Ssn ON Employee
GO
    -- Remove the non clustered index on Project.Pnumber
    DROP INDEX IX_Project_Pnumber ON Project
GO
    ----------------------------------------   FOURTH QUERY -------------------------------------------------
    -- NON OPTIMIZED
SELECT
    *
FROM
    Employee E
WHERE
    E.Super_Ssn IN (
        SELECT
            M.SSN
        FROM
            Employee E,
            Employee M
        WHERE
            E.Super_Ssn = M.Ssn
            AND M.Bdate > '1970-01-01'
    );

-- OPTIMIZED
EXEC sp_Employee_Super_Ssn '1970-01-01' --  Add non clustered index on Employee.SSN
-------------------------
CREATE NONCLUSTERED INDEX IX_Employee_Ssn ON Employee(Ssn)
GO
    -- Add non clustered index on Project.Pnumber
    CREATE NONCLUSTERED INDEX IX_Project_Pnumber ON Project(Pnumber)
GO
    -- Remove the non clustered index on Employee.Ssn
    DROP INDEX IX_Employee_Ssn ON Employee
GO
    -- Remove the non clustered index on Project.Pnumber
    DROP INDEX IX_Project_Pnumber ON Project
GO