-- Business Question:
-- What are the top 3 product combinations most frequently purchased together?

-- Purpose:
-- Support cross-selling initiatives, promotional bundles, and sales effectiveness improvement.

WITH OderList AS(
	SELECT 
		SOH.SalesOrderNumber,
		COUNT(SOD.ProductID) 'NumberOfProduct'
	From Sales.SalesOrderHeader SOH
	LEFT JOIN Sales.SalesOrderDetail SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	GROUP BY 
		SOH.SalesOrderNumber
	HAVING COUNT(SOD.ProductID)>=3),
Info AS(
	SELECT 
		OL.SalesOrderNumber,
		SOD.ProductID,
		P.Name 'NameProduct'
	FROM OderList OL
	JOIN Sales.SalesOrderHeader SOH
	ON SOH.SalesOrderNumber=OL.SalesOrderNumber
	JOIN Sales.SalesOrderDetail SOD
	ON SOH.SalesOrderID=SOD.SalesOrderID
	LEFT JOIN Production.Product P
	ON P.ProductID=SOD.ProductID
	WHERE YEAR(SOH.OrderDate)=2014)
SELECT 
	I1.ProductID 'Product1',
	I2.ProductID 'Product2',
	I3.ProductID 'Product3',
	I1.NameProduct 'NameProduct1',
	I2.NameProduct 'NameProduct2',
	I3.NameProduct 'NameProduct3',
	COUNT(*) 'Frequency'
FROM Info I1
JOIN Info I2
ON I1.SalesOrderNumber=I2.SalesOrderNumber
JOIN Info I3
ON I2.SalesOrderNumber=I3.SalesOrderNumber
WHERE
	I1.ProductID <> I2.ProductID
	AND I1.ProductID<I2.ProductID
	AND I2.ProductID <>I3.ProductID
	AND I2.ProductID<I3.ProductID
GROUP BY 
	I1.ProductID,
	I2.ProductID,
	I3.ProductID,
	I1.NameProduct,
	I2.NameProduct,
	I3.NameProduct
ORDER BY COUNT(*) DESC
