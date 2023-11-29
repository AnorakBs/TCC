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

base_reseller as (
SELECT 
c.CustomerID as ResellerKey,
dg.GeographyKey as GeographyKey,
AccountNumber as ResellerAlternateKey,
pp.PhoneNumber as Phone,
CASE 
    WHEN s.BusinessType = 'BM' THEN 'Value Added Reseller'
    WHEN s.BusinessType = 'BS' THEN 'Specialty Bike Shop'
    WHEN s.BusinessType = 'OS' THEN 'Warehouse'
else ''
end as BusinessType,
s.Name_store as ResellerName,
s.NumberEmployees,
 '' AS OrderFrequency, -- nao tem no banco os valores para as as keys 1-701 (que sao as keys que temos na dimensao)
 '' as OrderMonth, -- nao tem no banco os valores para as as keys 1-701 (que sao as keys que temos na dimensao)
 '' as FirstOrderYear, -- nao tem no banco os valores para as as keys 1-701 (que sao as keys que temos na dimensao)
 '' as LastOrderYear, -- ao tem no banco os valores para as as keys 1-701 (que sao as keys que temos na dimensao)
 s.ProductLine,
    a.AddressLine1 as AddressLine1,
    a.AddressLine2 as AddressLine2,
    s.AnnualSales,
    s. BankName,
    '' as MinPaymentType, --nao tem no banco
    '' as MinPaymentAmount, -- nao tem no banco
    s.AnnualRevenue,
    s.YearOpened,
    ROW_NUMBER () over (partition by c.CustomerID order by c.CustomerID asc) as rn
FROM 
raw_zone.Sales_Customer c
left join raw_zone.Sales_Store s on s.BusinessEntityID = c.StoreID 
left JOIN raw_zone.Person_BusinessEntityContact bec  on bec.BusinessEntityID =  s.BusinessEntityID 
left join raw_zone.Person_Person p on p.BusinessEntityID = bec.PersonID 
left outer join raw_zone.Person_PersonPhone pp on pp.BusinessEntityID = p.BusinessEntityID
left join raw_zone.Person_BusinessEntityAddress bea on bea.BusinessEntityID = s.BusinessEntityID 
left join raw_zone.Person_AddressType adt on adt.AddressTypeID = bea.BusinessEntityID 
left join raw_zone.Person_Address a on a.AddressID = bea.AddressID
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