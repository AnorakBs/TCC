with cte1 as (
SELECT 
DISTINCT GroupName 
from HumanResources.Department d 

union

Select 'Corporate'
)

Select
ROW_NUMBER () over (order by GroupName asc) as DepartmentGroupKey,
CAST(CASE 
	when GroupName = 'Corporate' then NULL 
	else '1'
END as int) AS ParentDepartmentGroupKey,
GroupName as DepartmentGroupName
from cte1