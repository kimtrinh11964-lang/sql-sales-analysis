-- Business Question:
-- How did revenue in Q2 2014 compare to Q2 of the previous year?

-- Purpose:
-- Assess year-over-year business performance and identify seasonal or structural growth patterns.

SELECT 
	YEAR(SOH.OrderDate) 'Year',
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
WHERE 
	DATEPART(QUARTER,SOH.OrderDate) = 2
	AND YEAR(SOH.OrderDate) IN (2013, 2014)
GROUP BY 
	DATEPART(YEAR,SOH.OrderDate),
	PC.Name
ORDER BY 
	PC.Name,
	YEAR(SOH.OrderDate)
