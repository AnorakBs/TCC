Select
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ProductKey,
ProductNumber as ProductAlternateKey,
ProductSubcategoryID as ProductSubcategoryKey,
WeightUnitMeasureCode as WeightUnitMeasureCode,
SizeUnitMeasureCode as SizeUnitMeasureCode,
P.Name as EnglishProductName,
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
CAST(dbo.ufnGetProductListPrice(p.[ProductID],GETDATE()) AS float) AS ListPrice, -- talvez seja uma funçao como a DealerPrice
Size as Size_product,
CASE ----- NAO REPRESENTA A TRANFORMACAO REAL MAS É BEM PROXIMO DO RESULTADO. PARA UMA REPRESENTACAO FIDEDIGNA TERIAMOS QUE SABER A EXATA REGRA DE NEGOCIO APLICADA A ESSE CAMPO
	WHEN ISNUMERIC(Size) = 1 THEN 
	CAST(CAST(Size as int) - 2 AS nvarchar)
	+ '-'
	+ CAST(CAST(Size as int) + 2 as nvarchar)
	+ ' CM'
	WHEN Size is null then 'NA'
	else Size
	end as SizeRange,
Weight as Weight,
DaysToManufacture as DaysToManufacture,
ProductLine as ProductLine,
CAST(dbo.ufnGetProductDealerPrice(p.[ProductID],GETDATE()) AS FLOAT) as DealerPrice, -- UMA FUNCAO QUE ESTA ARMAZENADA NO BANDO ADVENTUREWORKS (CAGUEI MUITO PRA ACHAR KKKKKKKKKKKKKKKKKK)
Class as Class_product,
Style as Style_product,
PM.Name as ModelName,
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
    WHEN SellStartDate <> '' then 'Current'
    else 'para analise'
    end as Status -- Nao achei nenhum valor correspondente a 'Current' ou NULL. Talvez alguma Regra de negocio 
From Production.Product P
left join Production.ProductModel PM on P.ProductModelID = PM.ProductModelID
left join Production.ProductProductPhoto PPP on P.ProductID = PPP.ProductID
left join Production.ProductPhoto PP on PPP.ProductPhotoID = PP.ProductPhotoID
left join Production.ProductModelProductDescriptionCulture PMPDC on P.ProductModelID = PMPDC.ProductModelID
left join Production.ProductDescription PD on PMPDC.ProductDescriptionID = PD.ProductDescriptionID
group by 
P.ProductId,
ProductNumber,
ProductSubcategoryID,
WeightUnitMeasureCode,
SizeUnitMeasureCode,
P.Name,
StandardCost,
FinishedGoodsFlag,
Color,
SafetyStockLevel,
ReorderPoint,
ListPrice,
Size,
--SizeRange,
Weight,
DaysToManufacture,
ProductLine,
Class,
Style,
PM.Name,
PP.LargePhoto,
SellStartDate,
SellEndDate