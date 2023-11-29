SELECT 
	BusinessEntityID,
    NationalIDNumber,
    LoginID,
	CONVERT(VARCHAR(MAX), OrganizationNode) as OrganizationNode,
    OrganizationLevel,
    JobTitle,
    BirthDate,
    MaritalStatus,
    Gender,
    HireDate,
    SalariedFlag,
    VacationHours,
    SickLeaveHours,
    CurrentFlag,
    ModifiedDate 



FROM HumanResources.Employee