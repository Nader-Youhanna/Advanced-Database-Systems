CREATE PROCEDURE sp_Employee_Super_Ssn @Bdate DATETIME AS BEGIN
Select
    *
from
    Employee E
Where
    E.Super_Ssn in (
        Select
            M.Ssn
        From
            Employee E,
            Employee M
        where
            E.Super_Ssn = M.Ssn
            And M.Bdate > @Bdate
    )
END