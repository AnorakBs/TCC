SELECT 
	BusinessEntityID ,
    name as Name_store,
    SalesPersonID ,
    s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') as BusinessType,
	s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/NumberEmployees)[1]', 'int') AS NumberEmployees,
s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/Specialty)[1]', 'nvarchar(50)') AS ProductLine,
s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/AnnualSales)[1]', 'money') AS AnnualSales,
s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/BankName)[1]', 'nvarchar(50)') AS BankName,
s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/AnnualRevenue)[1]', 'money') AS AnnualRevenue,
s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
    (/StoreSurvey/YearOpened)[1]', 'nvarchar(50)') AS YearOpened,

    ModifiedDate

FROM Sales.Store s