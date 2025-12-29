-- Business Question:
-- How did the Bikes category perform in 2014 in terms of sales quantity, revenue, and percentage contribution compared to other categories?

DECLARE @BikesTotalSalesAmount14 MONEY 
SET @BikesTotalSalesAmount14 = 
	(SELECT SUM(SOD.LineTotal)
	FROM Sales.SalesOrderHeader SOH
	LEFT JOIN Sales.SalesOrderDetail SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	LEFT JOIN Production.Product P
	ON SOD.ProductID=P.ProductID
	LEFT JOIN Production.ProductSubCategory PSC
	ON P.ProductSubcategoryID=PSC.ProductSubcategoryID
	LEFT JOIN Production.ProductCategory PC
	ON PC.ProductCategoryID=PSC.ProductCategoryID
	WHERE 
		YEAR(SOH.OrderDate)=2014
		AND PC.Name='Bikes');

DECLARE @BikesTotalSalesQuantity14 MONEY 
SET @BikesTotalSalesQuantity14 = 
	(SELECT SUM(SOD.OrderQty)
	FROM Sales.SalesOrderHeader SOH
	LEFT JOIN Sales.SalesOrderDetail SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	LEFT JOIN Production.Product P
	ON SOD.ProductID=P.ProductID
	LEFT JOIN Production.ProductSubCategory PSC
	ON P.ProductSubcategoryID=PSC.ProductSubcategoryID
	LEFT JOIN Production.ProductCategory PC
	ON PC.ProductCategoryID=PSC.ProductCategoryID
	WHERE 
		YEAR(SOH.OrderDate)=2014
		AND PC.Name='Bikes');

SELECT 
	P.ProductID,
	P.Name 'Product',
	PC.Name 'Category',
	COUNT(SOD.OrderQty) 'TotalSalesQuantity',
	COUNT(SOD.OrderQty)/@BikesTotalSalesQuantity14*100.0 'PercentSOQ',
	SUM(SOD.LineTotal) 'TotalSalesAmount',
	SUM(SOD.LineTotal)/@BikesTotalSalesAmount14*100.0 'PercentSA'
FROM Sales.SalesOrderHeader SOH
LEFT JOIN Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID=SOD.SalesOrderID
LEFT JOIN Production.Product P
ON P.ProductID=SOD.ProductID
LEFT JOIN Production.ProductSubcategory PS
ON PS.ProductSubcategoryID=P.ProductSubcategoryID
LEFT JOIN Production.ProductCategory PC
ON PC.ProductCategoryID=PS.ProductCategoryID
WHERE PC.Name='Bikes'
AND YEAR(SOH.OrderDate)=2014
GROUP BY 
	P.ProductID,
	P.Name ,
	PC.Name
ORDER BY SUM(SOD.LineTotal) DESC
