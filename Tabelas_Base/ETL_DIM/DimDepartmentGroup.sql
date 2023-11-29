WITH cte1 AS (
    SELECT 
        DISTINCT GroupName 
    FROM raw_zone.HumanResources_Department


    UNION

    SELECT 'Corporate'
)

SELECT
    ROW_NUMBER() OVER (ORDER BY GroupName ASC) AS DepartmentGroupKey,
    CASE 
        WHEN GroupName = 'Corporate' THEN NULL 
        ELSE 1
    END AS ParentDepartmentGroupKey,
    GroupName AS DepartmentGroupName
FROM
    cte1;