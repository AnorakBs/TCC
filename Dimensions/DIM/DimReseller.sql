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

base_reseller as (
SELECT 
c.CustomerID as ResellerKey,
dg.GeographyKey as GeographyKey,
AccountNumber as ResellerAlternateKey,
pp.PhoneNumber as Phone,
CASE 
    WHEN s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') = 'BM' THEN 'Value Added Reseller'
    WHEN s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') = 'BS' THEN 'Specialty Bike Shop'
    WHEN s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') = 'OS' THEN 'Warehouse'
else ''
end as BusinessType,
s.Name as ResellerName,
s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/NumberEmployees)[1]', 'int') AS NumberEmployees,
 '' AS OrderFrequency, -- nao tem no banco os valores para as as keys 1-701 (que sao as keys que temos na dimensao)
 '' as OrderMonth, -- nao tem no banco os valores para as as keys 1-701 (que sao as keys que temos na dimensao)
 '' as FirstOrderYear, -- nao tem no banco os valores para as as keys 1-701 (que sao as keys que temos na dimensao)
 '' as LastOrderYear, -- ao tem no banco os valores para as as keys 1-701 (que sao as keys que temos na dimensao)
 s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/Specialty)[1]', 'nvarchar(50)') AS ProductLine,
    a.AddressLine1 as AddressLine1,
    a.AddressLine2 as AddressLine2,
    s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/AnnualSales)[1]', 'money') AS AnnualSales,
    s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/BankName)[1]', 'nvarchar(50)') AS BankName,
    '' as MinPaymentType, --nao tem no banco
    '' as MinPaymentAmount, -- nao tem no banco
    s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/AnnualRevenue)[1]', 'money') AS AnnualRevenue,
    s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/YearOpened)[1]', 'nvarchar(50)') AS YearOpened,
    ROW_NUMBER () over (partition by c.CustomerID order by c.CustomerID asc) as rn
FROM 
Sales.Customer c
left join Sales.Store s on s.BusinessEntityID = c.StoreID 
left JOIN Person.BusinessEntityContact bec  on bec.BusinessEntityID =  s.BusinessEntityID 
left join Person.Person p on p.BusinessEntityID = bec.PersonID 
left outer join Person.PersonPhone pp on pp.BusinessEntityID = p.BusinessEntityID
left join Person.BusinessEntityAddress bea on bea.BusinessEntityID = s.BusinessEntityID 
left join Person.AddressType adt on adt.AddressTypeID = bea.BusinessEntityID 
left join Person.Address a on a.AddressID = bea.AddressID
LEFT JOIN DimGeography dg ON a.City = dg.City
where c.CustomerID BETWEEN 1 and 701
)

SELECT 
ResellerKey,
GeographyKey,
ResellerAlternateKey,
Phone,
BusinessType,
ResellerName,
NumberEmployees,
OrderFrequency,
OrderMonth,
FirstOrderYear,
LastOrderYear,
ProductLine,
AddressLine1,
AddressLine2,
AnnualSales,
BankName,
MinPaymentType,
MinPaymentAmount,
AnnualRevenue,
YearOpened
from base_reseller
where rn = 1
order by ResellerKey asc