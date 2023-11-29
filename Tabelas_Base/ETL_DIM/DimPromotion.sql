SELECT
    SpecialOfferID AS "PromotionKey",
    SpecialOfferID AS "PromotionAlternateKey",
    Description AS "EnglishPromotionName",
    '' AS "SpanishPromotionName",
    '' AS "FrenchPromotionName",
    DiscountPct AS "DiscountPct",
    Type_field AS "EnglishPromotionType",  -- Corrigido para usar "Type" entre aspas duplas
    '' AS "SpanishPromotionType",
    '' AS "FrenchPromotionType",
    Category AS "EnglishPromotionCategory",
    '' AS "SpanishPromotionCategory",
    '' AS "FrenchPromotionCategory",
    StartDate,
    EndDate,
    MinQty,
    MaxQty
FROM
    raw_zone.Sales_SpecialOffer;
