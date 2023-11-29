SELECT
emp.BusinessEntityID as EmployeeKey,
(
    SELECT man.BusinessEntityID
    FROM raw_zone.HumanResources_Employee man
    WHERE
    emp.OrganizationNode LIKE man.OrganizationNode || '%'
    AND length(regexp_replace(emp.OrganizationNode, '[^/]', '', 'g')) - 1 = length(regexp_replace(man.OrganizationNode, '[^/]', '', 'g'))
    AND emp.BusinessEntityID <> man.BusinessEntityID -- Ensure employee is not matched with themselves
) AS ParentEmployeeKey,
emp.NationalIDNumber as EmployeeNationalIDAlternateKey,
(
    SELECT man.NationalIDNumber -- ID of the manager of this employee
    FROM raw_zone.HumanResources_Employee man
    WHERE
    emp.OrganizationNode LIKE man.OrganizationNode || '%'
    AND length(regexp_replace(emp.OrganizationNode, '[^/]', '', 'g')) - 1 = length(regexp_replace(man.OrganizationNode, '[^/]', '', 'g'))
    AND emp.BusinessEntityID <> man.BusinessEntityID -- Ensure employee is not matched with themselves
) AS ParentEmployeeNationalIDAlternateKey,
CASE
    WHEN sth.BusinessEntityID IS NOT NULL THEN sth.TerritoryID
    ELSE 11
 END AS SalesTerritoryKey,
p.FirstName,
p.LastName,
p.MiddleName,
p.NameStyle,
emp.JobTitle as Title,
emp.HireDate,
emp.BirthDate,
emp.LoginID,
ea.EmailAddress,
pp.PhoneNumber as Phone,
emp.MaritalStatus,
Concat(FirstName,' ',LastName) as EmergencyContactName,
pp.PhoneNumber as EmergencyContactPhone,
emp.SalariedFlag,
emp.Gender,
eph.PayFrequency,
eph.Rate as BaseRate,
emp.VacationHours,
emp.SickLeaveHours,
emp.CurrentFlag,
CASE
    WHEN s.BusinessEntityID IS NOT NULL THEN 1
    ELSE 0
    END AS SalesPersonFlag,
d.name_department as DepartmentName,
edh.StartDate, -- checar se nao existe outro. Valor diferente na dimensao
edh.EndDate, -- checar se nao existe outro. Valor diferente na dimensao
CASE
    WHEN edh.EndDate is null then 'Current'
    else NULL
END as Status,
'' as EmployeePhoto -- nao tem no banco
from raw_zone.HumanResources_Employee emp
inner join raw_zone.Person_Person p
on emp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN
    raw_zone.Sales_SalesTerritoryHistory sth
ON
    emp.BusinessEntityID = sth.BusinessEntityID
INNER JOIN
    raw_zone.Person_EmailAddress ea
on
    ea.BusinessEntityID = emp.BusinessEntityID
INNER JOIN
    raw_zone.Person_PersonPhone pp
on
    pp.BusinessEntityID = emp.BusinessEntityID
LEFT JOIN
    raw_zone.Sales_SalesPerson s
ON
    emp.BusinessEntityID = s.BusinessEntityID
Inner join
    raw_zone.HumanResources_EmployeeDepartmentHistory edh
on
    emp.BusinessEntityID = edh.BusinessEntityID
Inner JOIN
    raw_zone.HumanResources_Department d
on
    edh.DepartmentID = d.DepartmentID
Inner JOIN
(
SELECT
BusinessEntityID,
Rate,
PayFrequency,
ROW_NUMBER() over (partition by BusinessEntityID order by ModifiedDate desc) rn
from raw_zone.HumanResources_EmployeePayHistory
) as eph
on emp.BusinessEntityID = eph.BusinessEntityID
where eph.rn = 1
order by HireDate asc

