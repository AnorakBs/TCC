SELECT
emp.BusinessEntityID as EmployeeKey,
(SELECT  
 	man.BusinessEntityID -- ID DO MANAGER DESSE EMPLOYEE
 FROM 
 	HumanResources.Employee man 
WHERE 
	emp.OrganizationNode.GetAncestor(1)=man.OrganizationNode OR -- ancestral do hierarchyid do funcionario é = ao hierarchyid de outro funcionario
	(emp.OrganizationNode.GetAncestor(1) = 0x AND man.OrganizationNode IS NULL) -- ancestral do hierarchyid do funcionario é = '0x' (NULO EM HEXADECIMAL) AND hierarchyid é nulo usado para identificar funcionários que estão no nível raiz e gerentes que não estão associados a nenhuma hierarquia específica.
) AS ParentEmployeeKey,
emp.NationalIDNumber as EmployeeNationalIDAlternateKey,
(SELECT  
 	man.NationalIDNumber -- ID DO MANAGER DESSE EMPLOYEE
 FROM 
 	HumanResources.Employee man 
WHERE 
	emp.OrganizationNode.GetAncestor(1)=man.OrganizationNode OR -- ancestral do hierarchyid do funcionario é = ao hierarchyid de outro funcionario
	(emp.OrganizationNode.GetAncestor(1) = 0x AND man.OrganizationNode IS NULL) -- ancestral do hierarchyid do funcionario é = '0x' (NULO EM HEXADECIMAL) AND hierarchyid é nulo usado para identificar funcionários que estão no nível raiz e gerentes que não estão associados a nenhuma hierarquia específica.
) AS ParentEmployeeNationalIDAlternateKey, -- por algum motivo NULL na dimensao
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
d.name as DepartmentName,
edh.StartDate, -- checar se nao existe outro. Valor diferente na dimensao
edh.EndDate, -- checar se nao existe outro. Valor diferente na dimensao
CASE 
	WHEN edh.EndDate is null then 'Current'
	else NULL
END as Status,
'' as EmployeePhoto -- nao tem no banco
from HumanResources.Employee emp 
inner join Person.Person p 
on emp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN 
	Sales.SalesTerritoryHistory sth 
ON 
	emp.BusinessEntityID = sth.BusinessEntityID
INNER JOIN 
	Person.EmailAddress ea 
on 
	ea.BusinessEntityID = emp.BusinessEntityID
INNER JOIN
	Person.PersonPhone pp 
on 
	pp.BusinessEntityID = emp.BusinessEntityID
LEFT JOIN
    Sales.SalesPerson s 
ON 
	emp.BusinessEntityID = s.BusinessEntityID
Inner join 
	HumanResources.EmployeeDepartmentHistory edh
on 
	emp.BusinessEntityID = edh.BusinessEntityID 
Inner JOIN
	HumanResources.Department d 
on 
	edh.DepartmentID = d.DepartmentID 
Inner JOIN 
(
SELECT
BusinessEntityID,
Rate,
PayFrequency,
ROW_NUMBER() over (partition by BusinessEntityID order by ModifiedDate desc) rn
from HumanResources.EmployeePayHistory
) as eph 
on emp.BusinessEntityID = eph.BusinessEntityID 
where eph.rn = 1
order by HireDate asc