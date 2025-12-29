-- Business Question:
-- How did revenue in Q2 2014 compare to Q1 2014?

-- Purpose:
-- Evaluate changes in business performance compared to the previous quarter.

SELECT 
    PC.Name 'Category',
    DATEPART(QUARTER, SOH.OrderDate) 'Quarter',
    SUM(SOD.LineTotal) 'TotalSalesAmount'
FROM Sales.SalesOrderHeader AS SOH
LEFT JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN Production.Product AS P
ON SOD.ProductID = P.ProductID
JOIN Production.ProductSubcategory AS PSC
ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PC
ON PSC.ProductCategoryID = PC.ProductCategoryID
WHERE 
	YEAR(SOH.OrderDate) = 2014
    AND DATEPART(QUARTER, SOH.OrderDate) IN (1, 2)
GROUP BY 
    PC.Name,
    DATEPART(QUARTER, SOH.OrderDate)
ORDER BY 
    PC.Name,
    DATEPART(QUARTER, SOH.OrderDate)
