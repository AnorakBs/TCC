Select
ROW_NUMBER() OVER (Order by Name_currency) as Currencykey,
CurrencyCode as CurrencyAlternateKey,
Name_currency as CurrencyName

from raw_zone.Sales_Currency