-- Business Question:
-- What are the quarterly revenue trends by product category over the years?

-- Purpose:
-- Compare and evaluate consumption trends over time to support strategic planning.

SELECT 
	YEAR(SOH.OrderDate) 'Year',
	DATEPART(QUARTER,SOH.OrderDate) 'Quarter',
	PC.Name 'Category',
    SUM(SOD.LineTotal) 'TotalSalesAmount'
FROM Sales.SalesOrderHeader SOH
LEFT JOIN Sales.SalesOrderDetail SOD
ON SOD.salesorderid=SOH.salesorderid
LEFT JOIN Production.Product P
ON P.ProductID=SOD.ProductID
LEFT JOIN Production.ProductSubcategory PS
ON PS.ProductSubcategoryID=p.ProductSubcategoryID
LEFT JOIN Production.ProductCategory PC
ON PC.ProductCategoryID=PS.ProductCategoryID
LEFT JOIN Sales.SalesOrderHeaderSalesReason SOHR
ON SOH.SalesOrderID=SOHR.SalesOrderID
GROUP BY 
	YEAR(SOH.OrderDate),
	DATEPART(QUARTER,SOH.OrderDate),
	PC.Name
ORDER BY 
	YEAR(SOH.OrderDate),
	PC.Name,
	SUM(SOD.LineTotal) DESC
