with cte as (
SELECT 
DISTINCT
city as City,
sp.StateProvinceCode,
sp.Name as StateProvinceName,
sp.CountryRegionCode as CountryRegionCode,
cr.Name as EnglishCountryRegionName,
'' as SpanishCountryRegionName,
'' as FrenchCountryRegionName,
a.PostalCode,
st.TerritoryID as SalesTerritoryKey,
'' as IpAddressLocator --- de fora
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
	st.TerritoryID = sp.TerritoryID)
--order by cr.Name,sp.StateProvinceCode asc)

select
ROW_NUMBER() over (order by EnglishCountryRegionName,StateProvinceCode asc) as GeographyKey,
*
from cte