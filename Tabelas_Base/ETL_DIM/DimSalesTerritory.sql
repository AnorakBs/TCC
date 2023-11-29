
SELECT
    TerritoryID AS "SalesTerritoryKey",
    TerritoryID AS "SalesTerritoryAlternateKey",
    Name_salesterritory AS "SalesTerritoryRegion",
    CASE
        WHEN CountryRegionCode <> 'US' THEN Name_salesterritory
        WHEN CountryRegionCode = 'US' THEN 'United States'
        ELSE ''
    END AS "SalesTerritoryCountry",
    "Group" AS "SalesTerritoryGroup",
    '' AS "SalesTerritoryImage"
FROM
    raw_zone.Sales_SalesTerritory

UNION

-- Segunda consulta
SELECT
    11 AS "SalesTerritoryKey",
    '0' AS "SalesTerritoryAlternateKey",
    'NA' AS "SalesTerritoryRegion",
    'NA' AS "SalesTerritoryCountry",
    'NA' AS "SalesTerritoryGroup",
    NULL AS "SalesTerritoryImage";
