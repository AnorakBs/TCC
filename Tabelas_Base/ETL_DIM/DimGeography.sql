with cte as (
SELECT 
DISTINCT
city as City,
sp.StateProvinceCode,
sp.Name_stateprovince as StateProvinceName,
sp.CountryRegionCode as CountryRegionCode,
cr.Name_countryregion as EnglishCountryRegionName,
'' as SpanishCountryRegionName,
'' as FrenchCountryRegionName,
a.PostalCode,
st.TerritoryID as SalesTerritoryKey,
'' as IpAddressLocator --- de fora
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
    st.TerritoryID = sp.TerritoryID
order by cr.Name_countryregion, sp.StateProvinceCode asc)

select
ROW_NUMBER() over (order by EnglishCountryRegionName,StateProvinceCode asc) as GeographyKey,
*
from cte
