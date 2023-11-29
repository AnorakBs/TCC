Select
ProductSubcategoryID as ProductSubcategoryAlternateKey,
ProductSubcategoryID as ProductSubcategoryKey, -- NAO EH ISSO MAS NAO APARENTA SER NENHUM OUTRO (TALVEZ O MESMO ALTERNATE DA DIMPRODUCT)
Name_productsubcategory as EnglishProductSubcategoryName,
'' as SpanishProductSubcategoryName, -- nao existe no banco essa informacao (pelo menos nao no schema Production e nem no Sales). Provavelmente vem de uma tabela auxiliar
'' as FrenchProductSubcategoryName, -- nao existe no banco essa informacao (pelo menos nao no schema Production e nem no Sales). Provavelmente vem de uma tabela auxiliar
ProductCategoryID as  ProductCategoryKey
from raw_zone.Production_ProductSubcategory