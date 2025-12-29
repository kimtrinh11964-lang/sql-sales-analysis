-- Business Question:
-- What was the sales performance in June 2014?

-- Purpose:
-- Identify products that performed well or poorly in the most recent business month to support short-term sales adjustments.

WITH TotalSalesAmount AS(
	SELECT 
		P.ProductID,
		P.Name 'Product',
		PC.Name 'Category',
		PS.Name 'Subcategory',
		SUM(SOD.OrderQty) 'TotalSalesQuantity',
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
	WHERE MONTH(SOH.OrderDate)=6
	AND YEAR(SOH.OrderDate)=2014
	GROUP BY 
		P.ProductID,
		P.Name ,
		PC.Name,
		PS.Name )
SELECT 
	ProductID,
	Product,
	Category,
	Subcategory,
	TotalSalesQuantity,
	SUM(TotalSalesQuantity) OVER (PARTITION BY Category) 'TotalCatSalesQuantity',
	TotalSalesAmount,
	SUM(TotalSalesAmount) OVER (PARTITION BY Category) 'TotalCatSalesAmount'
FROM TotalSalesAmount 
ORDER BY 
	TotalSalesAmount DESC
