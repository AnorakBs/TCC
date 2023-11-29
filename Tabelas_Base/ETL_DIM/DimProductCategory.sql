SELECT
    ProductCategoryID AS "ProductCategoryKey",
    ProductCategoryID AS "ProductCategoryAlternateKey",
    Name_productcategory AS "EnglishProductCategoryName",
    '' AS "SpanishProductCategoryName",
    '' AS "FrenchProductCategoryName"
FROM
    raw_zone.Production_ProductCategory
ORDER BY
    ProductCategoryID ASC;
