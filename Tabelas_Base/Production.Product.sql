SELECT 

	ProductID,
    name as Name_product,
    ProductNumber,
    MakeFlag,
    FinishedGoodsFlag,
    Color,
    SafetyStockLevel,
    ReorderPoint,
    StandardCost,
    ListPrice,
    size as Size_product,
    SizeUnitMeasureCode,
    WeightUnitMeasureCode,
    Weight,
    DaysToManufacture,
    ProductLine,
    class as Class_product,
    style as Style_product,
    ProductSubcategoryID ,
    ProductModelID ,
    SellStartDate,
    SellEndDate ,
    DiscontinuedDate,
    ModifiedDate

FROM Production.Product