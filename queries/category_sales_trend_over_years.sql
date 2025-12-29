-- Business Question:
-- How have sales trends of product categories changed over the years?

-- Purpose:
-- Identify high-revenue categories, declining categories, and potential anomalies in long-term sales performance.

SELECT *,
	RANK() OVER (PARTITION BY Category,Year ORDER BY TotalSalesAmount DESC) 'HighestTSA'
FROM(
 SELECT 
	YEAR(SOH.OrderDate) 'Year',
	MONTH(SOH.OrderDate) 'Month',
	PC.Name 'Category',
	COUNT(SOD.OrderQty) 'TotalSalesQuantity',
	SUM(SOD.LineTotal) 'TotalSalesAmount'
FROM Sales.SalesOrderHeader SOH
LEFT JOIN Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID=SOD.SalesOrderID
LEFT JOIN Production.Product P
ON P.ProductID=SOD.ProductID
LEFT JOIN Production.ProductSubcategory PS
ON PS.ProductSubcategoryID=P.ProductSubcategoryID
LEFT JOIN Production.ProductCategory PC
ON PC.ProductCategoryID=PS.ProductCategoryID
GROUP BY 
	YEAR(SOH.OrderDate),
	MONTH(SOH.OrderDate),
	PC.Name) AS CTE
