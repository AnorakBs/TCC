with base_geography as (
SELECT 
DISTINCT
city as City, --
sp.StateProvinceCode, --
sp.CountryRegionCode as CountryRegionCode,
cr.Name as EnglishCountryRegionName,
a.PostalCode
from Person.Address a 
inner join 
	Person.StateProvince sp 
on
	a.StateProvinceID = sp.StateProvinceID
inner JOIN 
	Person.CountryRegion cr 
on 
	sp.CountryRegionCode = cr.CountryRegionCode 
Inner join 
	Sales.SalesTerritory st
on 
	st.TerritoryID = sp.TerritoryID),
--order by cr.Name,sp.StateProvinceCode asc)

DimGeography as (
select
ROW_NUMBER() over (order by EnglishCountryRegionName,StateProvinceCode asc) as GeographyKey,
*
from base_geography
),

base_customer as (
SELECT 
c.CustomerID as CustomerKey,
dg.GeographyKey as GeographyKey,
c.AccountNumber as CustomerAlternateKey,
p.Title as Title,
p.FirstName as FirstName,
p.MiddleName as MiddleName,
p.LastName as LastName,
p.NameStyle as NameStyle,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/BirthDate)[1]', 'varchar(50)') as BirthDate,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/MaritalStatus)[1]', 'varchar(50)') as MaritalStatus,
p.Suffix as Suffix,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/Gender)[1]', 'varchar(1)') as Gender,
ea.EmailAddress as EmailAddress,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/YearlyIncome)[1]', 'varchar(50)') as YearlyIncome,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/TotalChildren)[1]', 'varchar(50)') as TotalChildren,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/NumberChildrenAtHome)[1]', 'varchar(50)') as NumberChildrenAtHome,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/Education)[1]', 'varchar(50)') as EnglishEducation,
'' as SpanishEducation,
'' as FrenchEducation,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/Occupation)[1]', 'varchar(50)') as EnglishOccupation,
'' as SpanishOccupation,
'' as FrenchOccupation,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/HomeOwnerFlag)[1]', 'varchar(50)') as HouseOwnerFlag,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/NumberCarsOwned)[1]', 'varchar(50)') as NumberCarsOwned,
a.AddressLine1,
a.AddressLine2,
pp.PhoneNumber as Phone,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/DateFirstPurchase)[1]', 'varchar(50)') as DateFirstPurchase,
p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/CommuteDistance)[1]', 'varchar(50)') as CommuteDistance,
ROW_NUMBER () over (partition by c.CustomerID order by c.CustomerID asc) as rn
from 
	sales.Customer c 
left join Person.Person p on c.PersonID = p.BusinessEntityID 
left join Person.EmailAddress ea on p.BusinessEntityID = ea.BusinessEntityID 
left join Person.BusinessEntityAddress bea on p.BusinessEntityID = bea.BusinessEntityID
left join Person.Address a on bea.AddressID = a.AddressID 
left join Person.PersonPhone pp on p.BusinessEntityID = pp.BusinessEntityID
LEFT JOIN DimGeography dg ON a.City = dg.City --AND a.StateProvinceID = dg.StateProvinceCode AND a.PostalCode = dg.PostalCode AND a.CountryRegionCode = dg.CountryRegionCode
where CustomerID >= 11000
and CustomerID <=29483)

SELECT 
CustomerKey,
GeographyKey,
CustomerAlternateKey,
Title,
FirstName,
MiddleName,
LastName,
NameStyle,
BirthDate,
MaritalStatus,
Suffix,
Gender,
EmailAddress,
YearlyIncome,
TotalChildren,
NumberChildrenAtHome,
EnglishEducation,
SpanishEducation,
FrenchEducation,
EnglishOccupation,
SpanishOccupation,
FrenchOccupation,
HouseOwnerFlag,
NumberCarsOwned,
AddressLine1,
AddressLine2,
Phone,
DateFirstPurchase,
CommuteDistance
from base_customer
where rn =1