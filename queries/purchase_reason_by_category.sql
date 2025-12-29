-- Business Question:
-- What are the key purchasing reasons by product category over time?

-- Purpose:
-- Identify factors influencing sales performance and changes in customer behavior over time.

SELECT 
	Year,
	Month,
	Category,
	Reason,
	SUM(CountSalesReason) 'TotalSalesReason'
FROM(
SELECT 
	Year(SOH.OrderDate) 'Year',
	MONTH(SOH.OrderDate) 'Month',
	P.ProductID,
	P.Name 'Product',
	PC.Name 'Category',
	SR.Name 'Reason',
	SUM(SOD.LineTotal) 'TotalSalesAmount',
	COUNT(SR.Name) 'CountSalesReason'
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
LEFT JOIN sales.salesreason sr
ON SR.SalesReasonID=SOHR.SalesReasonID
GROUP BY  
	YEAR(SOH.OrderDate),
	MONTH(SOH.OrderDate),
	P.ProductID,
	P.Name,
	PC.Name,
	SR.Name
	) AS CTE
GROUP BY
	Year,
	Month,
	Category,
	Reason
ORDER BY
	Category,
	Year,
	Month,
	SUM(CountSalesReason)
