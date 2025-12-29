-- Business Question:
-- How much total revenue did each product category generate in 2014?

-- Purpose:
-- Support decisions on selecting and developing product categories with strong financial potential.

DECLARE @TotalSalesAmount14 MONEY 
SET @TotalSalesAmount14 = 
	(SELECT SUM(SOD.LineTotal)
	FROM Sales.SalesOrderHeader SOH
	LEFT JOIN Sales.SalesOrderDetail SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	WHERE 
		YEAR(SOH.OrderDate)=2014);

WITH SalesAmount AS(
SELECT 
	SOD.ProductID,
	SUM(SOD.LineTotal) 'TotalSalesAmount'
FROM Sales.SalesOrderHeader SOH
LEFT JOIN Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID=SOD.SalesOrderID
WHERE YEAR(SOH.OrderDate)=2014
GROUP BY  
	YEAR(SOH.OrderDate),
	SOD.ProductID),
Category AS(
SELECT 
	PC.ProductCategoryID,
	PC.Name 'CategoryName',
	P.ProductID,
	P.Name 'ProductName'
FROM Production.Product P
	LEFT JOIN Production.ProductSubcategory PS
	ON PS.ProductSubcategoryID=P.ProductSubcategoryID
	LEFT JOIN Production.ProductCategory PC
	ON PC.ProductCategoryID=PS.ProductCategoryID
	)
SELECT 
	C.ProductCategoryID,
	C.CategoryName,
	SUM(SA.TotalSalesAmount) 'TotalSalesAmount',
	SUM(SA.TotalSalesAmount)/@TotalSalesAmount14*100.0 'Percent'
FROM SalesAmount SA
LEFT JOIN Category C
ON SA.ProductID=C.ProductID 
GROUP BY 
	C.ProductCategoryID,
	C.CategoryName
ORDER BY 
	SUM(SA.TotalSalesAmount) DESC
