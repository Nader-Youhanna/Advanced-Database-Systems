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
    ------------------------------ FIRST QUERY ------------------------------------------------------

-- Non optimized query using 2 inner joins
SELECT
    Employee.Fname,
    Employee.Lname,
    Employee.Salary
FROM

    Employee
INNER JOIN
    Works_On ON Employee.Ssn = Works_On.Essn
INNER JOIN
    Project ON Works_On.Pno = Project.Pnumber
WHERE
    Project.Pname = 'ProductX'
ORDER BY

    Employee.Salary DESC
GO
    ------------------------------ SECOND QUERY ------------------------------------------------------