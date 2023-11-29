Select
SpecialOfferID as PromotionKey,
SpecialOfferID as PromotionAlternateKey,
Description as EnglishPromotionName,
'' as SpanishPromotionName,
'' as FrenchPromotionName,
DiscountPct as DiscountPct,
Type as EnglishPromotionType,
'' as SpanishPromotionType,
'' as FrenchPromotionType,
Category as EnglishPromotionCategory,
'' as SpanishPromotionCategory,
'' as FrenchPromotionCategory,
StartDate as StartDate,
EndDate as EndDate,
MinQty as MinQty,
MaxQty as MaxQty
from Sales.SpecialOffer