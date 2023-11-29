SELECT 
	AddressID,
    AddressLine1,
    AddressLine2,
    City,
    StateProvinceID,
    PostalCode,
    CONVERT(VARCHAR(MAX), SpatialLocation) AS SpatialLocation,
    ModifiedDate


FROM Person.Address