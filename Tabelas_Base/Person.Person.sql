SELECT 
	BusinessEntityID,
    PersonType,
    NameStyle,
    Title,
    FirstName,
    MiddleName,
    LastName,
    Suffix,
    EmailPromotion,
	AdditionalContactInfo,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/BirthDate)[1]', 'varchar(50)') as BirthDate,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/MaritalStatus)[1]', 'varchar(50)') as MaritalStatus,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/Gender)[1]', 'varchar(1)') as Gender,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/YearlyIncome)[1]', 'varchar(50)') as YearlyIncome,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/TotalChildren)[1]', 'varchar(50)') as TotalChildren,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/NumberChildrenAtHome)[1]', 'varchar(50)') as NumberChildrenAtHome,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/Education)[1]', 'varchar(50)') as EnglishEducation,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/Occupation)[1]', 'varchar(50)') as EnglishOccupation,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/HomeOwnerFlag)[1]', 'varchar(50)') as HouseOwnerFlag,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/NumberCarsOwned)[1]', 'varchar(50)') as NumberCarsOwned,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/DateFirstPurchase)[1]', 'varchar(50)') as DateFirstPurchase,
	p.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
    (/IndividualSurvey/CommuteDistance)[1]', 'varchar(50)') as CommuteDistance,
    ModifiedDate

FROM Person.Person p