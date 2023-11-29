Select
ROW_NUMBER() OVER (Order by Name) as Currencykey,
CurrencyCode as CurrencyAlternateKey,
Name as CurrencyName
from Sales.Currency