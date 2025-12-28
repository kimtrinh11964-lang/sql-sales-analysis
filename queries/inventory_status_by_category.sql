-- Business Question:
-- What is the current inventory level by product category?

SELECT 
	PC.ProductCategoryID,
	PC.Name,
	SUM(PI.Quantity) 'TotaQuantity'
FROM Production.ProductCategory PC
LEFT JOIN Production.ProductSubcategory PS
ON PC.ProductCategoryID=PS.ProductCategoryID
FULL JOIN Production.Product P
ON PS.ProductSubcategoryID=P.ProductSubcategoryID
LEFT JOIN Production.ProductInventory PI
ON P.ProductID=PI.ProductID
GROUP BY
	PC.ProductCategoryID,
	PC.Name
ORDER BY 
	SUM(PI.Quantity) DESC,
	PC.ProductCategoryID
