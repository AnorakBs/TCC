with base_geography as (
SELECT 
DISTINCT
city as City, --
sp.StateProvinceCode, --
sp.CountryRegionCode as CountryRegionCode,
cr.Name_countryregion as EnglishCountryRegionName,
a.PostalCode
from raw_zone.Person_Address a 
inner join 
	raw_zone.Person_StateProvince sp 
on
	a.StateProvinceID = sp.StateProvinceID
inner JOIN 
	raw_zone.Person_CountryRegion cr 
on 
	sp.CountryRegionCode = cr.CountryRegionCode 
Inner join 
	raw_zone.Sales_SalesTerritory st
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
p.BirthDate,
p.MaritalStatus,
p.Suffix as Suffix,
p.Gender,
ea.EmailAddress as EmailAddress,
p.YearlyIncome,
p.TotalChildren,
p.NumberChildrenAtHome,
p.EnglishEducation,
'' as SpanishEducation,
'' as FrenchEducation,
p.EnglishOccupation,
'' as SpanishOccupation,
'' as FrenchOccupation,
p.HouseOwnerFlag,
p.NumberCarsOwned,
a.AddressLine1,
a.AddressLine2,
pp.PhoneNumber as Phone,
p.DateFirstPurchase,
p.CommuteDistance,
ROW_NUMBER () over (partition by c.CustomerID order by c.CustomerID asc) as rn
from 
	raw_zone.sales_Customer c 
left join raw_zone.Person_Person p on c.PersonID = p.BusinessEntityID 
left join raw_zone.Person_EmailAddress ea on p.BusinessEntityID = ea.BusinessEntityID 
left join raw_zone.Person_BusinessEntityAddress bea on p.BusinessEntityID = bea.BusinessEntityID
left join raw_zone.Person_Address a on bea.AddressID = a.AddressID 
left join raw_zone.Person_PersonPhone pp on p.BusinessEntityID = pp.BusinessEntityID
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