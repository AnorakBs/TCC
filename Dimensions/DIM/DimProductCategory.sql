Select
ProductCategoryID as  ProductCategoryKey,
ProductCategoryID as ProductCategoryAlternateKey, -- NAO EH ISSO MAS NAO APARENTA SER NENHUM OUTRO (TALVEZ O MESMO ALTERNATE DA DIMPRODUCT) 
Name as EnglishProductCategoryName,
'' as SpanishProductCategoryName, -- nao existe no banco essa informacao (pelo menos nao no schema Production e nem no Sales). Provavelmente vem de uma tabela auxiliar
'' as FrenchProductCategoryName -- nao existe no banco essa informacao (pelo menos nao no schema Production e nem no Sales). Provavelmente vem de uma tabela auxiliar
from Production.ProductCategory
order by ProductCategoryID asc