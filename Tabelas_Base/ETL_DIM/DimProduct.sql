Select
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ProductKey,
ProductNumber as ProductAlternateKey,
ProductSubcategoryID as ProductSubcategoryKey,
WeightUnitMeasureCode as WeightUnitMeasureCode,
SizeUnitMeasureCode as SizeUnitMeasureCode,
P.Name_product as EnglishProductName,
'' as SpanishProductName,-- nao existe no banco essa informacao (pelo menos nao no schema Production e nem no Sales). Provavelmente vem de uma tabela auxiliar
'' as FrenchProductName, -- nao existe no banco essa informacao (pelo menos nao no schema Production e nem no Sales). Provavelmente vem de uma tabela auxiliar
CAST(Case 
	WHEN StandardCost = 0 Then NULL
    else StandardCost
end as FLOAT) AS  StandardCost,
FinishedGoodsFlag as FinishedGoodsFlag,
CASE
	WHEN Color is null Then 'NA'
	else Color
end as Color,
SafetyStockLevel as SafetyStockLevel,
ReorderPoint as ReorderPoint,
raw_zone.ufnGetProductListPrice(p.ProductID,current_date):: float AS ListPrice, -- talvez seja uma funçao como a DealerPrice
Size_product as Size_product,
CASE
  WHEN Size_product ~ '^[0-9]+$' THEN 
    (Size_product::int - 2)::text || '-' || (Size_product::int + 2)::text || ' CM'
  WHEN Size_product IS NULL THEN 
    'NA'
  ELSE 
    Size_product
END AS SizeRange,
Weight as Weight,
DaysToManufacture as DaysToManufacture,
ProductLine as ProductLine,
raw_zone.ufnGetProductDealerPrice(p.ProductID,current_date):: FLOAT as DealerPrice, -- UMA FUNCAO QUE ESTA ARMAZENADA NO BANDO ADVENTUREWORKS (CAGUEI MUITO PRA ACHAR KKKKKKKKKKKKKKKKKK)
Class_product as Class_product,
Style_product as Style_product,
PM.Name_productmodel as ModelName,
PP.LargePhoto as LargePhoto, ----------------------------------------------------------------------- TALVEZ REMOVER DESCRICOES PARA UMA CTE PARA EVITAR GROUP BY
    MAX(CASE WHEN PMPDC.CultureID = 'en' THEN PD.Description END) AS EnglishDescription, --
    MAX(CASE WHEN PMPDC.CultureID = 'fr' THEN PD.Description END) AS FrenchDescription, --
    MAX(CASE WHEN PMPDC.CultureID = 'zh-cht' THEN PD.Description END) AS ChineseDescription, --
    MAX(CASE WHEN PMPDC.CultureID = 'ar' THEN PD.Description END) AS ArabicDescription,  --
    MAX(CASE WHEN PMPDC.CultureID = 'he' THEN PD.Description END) AS HebrewDescription, --
    MAX(CASE WHEN PMPDC.CultureID = 'th' THEN PD.Description END) AS ThaiDescription, --
    MAX(CASE WHEN PMPDC.CultureID = 'de' THEN PD.Description END) AS GermanDescription, --ntem tem no banco
    MAX(CASE WHEN PMPDC.CultureID = 'ja' THEN PD.Description END) AS JapaneseDescription, --ntem no banco
    MAX(CASE WHEN PMPDC.CultureID = 'tr' THEN PD.Description END) AS TurkishDescription, -- ntem no banco
SellStartDate as StartDate,
SellEndDate as EndDate,
Case
    WHEN SellEndDate is NULL then NULL
    WHEN SellStartDate:: text <> '' then 'Current'
    else 'para analise'
    end as Status -- Nao achei nenhum valor correspondente a 'Current' ou NULL. Talvez alguma Regra de negocio 
From raw_zone.Production_Product P
left join raw_zone.Production_ProductModel PM on P.ProductModelID = PM.ProductModelID
left join raw_zone.Production_ProductProductPhoto PPP on P.ProductID = PPP.ProductID
left join raw_zone.Production_ProductPhoto PP on PPP.ProductPhotoID = PP.ProductPhotoID
left join raw_zone.Production_ProductModelProductDescriptionCulture PMPDC on P.ProductModelID = PMPDC.ProductModelID
left join raw_zone.Production_ProductDescription PD on PMPDC.ProductDescriptionID = PD.ProductDescriptionID
group by 
P.ProductId,
ProductNumber,
ProductSubcategoryID,
WeightUnitMeasureCode,
SizeUnitMeasureCode,
P.Name_product,
StandardCost,
FinishedGoodsFlag,
Color,
SafetyStockLevel,
ReorderPoint,
ListPrice,
Size_product,
--SizeRange,
Weight,
DaysToManufacture,
ProductLine,
Class_product,
Style_product,
PM.Name_productmodel,
PP.LargePhoto,
SellStartDate,
SellEndDate