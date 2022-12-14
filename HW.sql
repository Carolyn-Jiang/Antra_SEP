-- 1
SELECT People.FullName, People.FaxNumber, Suppliers.FaxNumber, Suppliers.PhoneNumber
FROM Application.People AS People
LEFT JOIN Purchasing.Suppliers AS Suppliers
ON People.PersonID = Suppliers.PrimaryContactPersonID;

-- 2
SELECT CustomerName FROM
(SELECT PersonID, PhoneNumber FROM Application.People UNION
SELECT PersonID, PhoneNumber FROM Application.People_Archive) AS P
INNER JOIN
(SELECT CustomerName, PhoneNumber, PrimaryContactPersonID FROM Sales.Customers UNION
SELECT CustomerName, PhoneNumber, PrimaryContactPersonID FROM Sales.Customers_Archive) AS C
ON p.PersonID = C.PrimaryContactPersonID
WHERE P.PhoneNumber = C.PhoneNumber;

-- 3
SELECT DISTINCT Sales.Customers.CustomerName, Sales.CustomerTransactions.TransactionDate as T_date
FROM Sales.Customers INNER JOIN
Sales.CustomerTransactions ON Sales.Customers.CustomerID = Sales.CustomerTransactions.CustomerID
WHERE YEAR(T_date) < '2016-01-01' ORDER BY T_date DESC;

-- 4
SELECT Stock.StockItemName,Stock.QuantityPerOuter
FROM Warehouse.StockItems AS Stock
INNER JOIN Purchasing.PurchaseOrders AS Orders
ON Stock.SupplierID = Orders.SupplierID
WHERE Orders.OrderDate = '2013';

-- 5
SELECT StockItemName FROM Warehouse.StockItems AS Stock
WHERE LEN(Stock.StockItemName) > 10;

-- 6
SELECT Stock.StockItemName, Area.StateProvinceName, Orders.OrderDate
FROM (((Warehouse.StockItems AS Stock
INNER JOIN Application.StateProvinces AS Area
ON Stock.LastEditedBY = Area.Lasteduted BY)
INNER JOIN Sales.OrderLines AS SOL
ON Stock.StockItemID = SOL.StockItemID)
INNER JOIN Sales.Orders AS Orders
ON SOL.OrderID = Orders.OrderID)
WHERE YEAR (Orders.OrderDate) != '2014' AND Area.StateProvinceName != ('ALABAMA''GEORGIA');


-- 7

-- 8

-- 9

-- 10

-- 11

-- 12

-- 13

-- 14

-- 15

-- 16

-- 17

-- 18

-- 19
CREATE VIEW view_table
AS SELECT year, 
SUM(CASE `group` WHEN 'Stock Group Name1' THEN quantity ELSE 0 END) as 'Stock Group Name1',
SUM(CASE `group` WHEN 'Stock Group Name2' THEN quantity ELSE 0 END) as 'Stock Group Name2',
SUM(CASE `group` WHEN 'Stock Group Name3' THEN quantity ELSE 0 END) as 'Stock Group Name3',
SUM(CASE `group` WHEN 'Stock Group Name4' THEN quantity ELSE 0 END) as 'Stock Group Name4',
FROM Warehouse.StockItems
WHERE year >= 2013-01-01
AND year <= 2017-12-31
GROUP BY year;

-- 20

-- 21

-- 22

-- 23

-- 24 

-- 25
SELECT year, 
SUM(CASE `group` WHEN 'Stock Group Name1' THEN quantity ELSE 0 END) as 'Stock Group Name1',
SUM(CASE `group` WHEN 'Stock Group Name2' THEN quantity ELSE 0 END) as 'Stock Group Name2',
SUM(CASE `group` WHEN 'Stock Group Name3' THEN quantity ELSE 0 END) as 'Stock Group Name3',
SUM(CASE `group` WHEN 'Stock Group Name4' THEN quantity ELSE 0 END) as 'Stock Group Name4'
FROM Warehouse.StockItems
WHERE year >= 2013-01-01
AND year <= 2017-12-31
GROUP BY year
FOR JSON AUTO;

-- 26
SELECT year, 
SUM(CASE `group` WHEN 'Stock Group Name1' THEN quantity ELSE 0 END) as 'Stock Group Name1',
SUM(CASE `group` WHEN 'Stock Group Name2' THEN quantity ELSE 0 END) as 'Stock Group Name2',
SUM(CASE `group` WHEN 'Stock Group Name3' THEN quantity ELSE 0 END) as 'Stock Group Name3',
SUM(CASE `group` WHEN 'Stock Group Name4' THEN quantity ELSE 0 END) as 'Stock Group Name4'
FROM Warehouse.StockItems
WHERE year >= 2013-01-01
AND year <= 2017-12-31
GROUP BY year
FOR XML PATH(''), ROOT ('company');

-- 27
CREATE TABLE IF NOT EXISTS `ods.ConfirmedDeviveryJson`(
   `id` INT UNSIGNED AUTO_INCREMENT,
   `date` DATE NOT NULL,
   `value` VARCHAR(4096) NOT NULL,
   PRIMARY KEY ( `id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER $$
CREATE PROCEDURE insert_json(IN create_date DATE)
BEGIN
	DECLARE json_line VARCHAR(4096);
	DECLARE json_lines CURSOR FOR SELECT GROUP_CONCAT(JSON_OBJECT( 
'id',id,'date',create_date,'xxxx',xxxx, 'xxxxx', xxxxx)) as xxxxxx FROM xxxtable ;
	DECLARE flag INT DEFAULT 0;
	open json_lines;
	REPEAT
		FETCH json_lines INTO json_line;
		INSERT INTO ods.ConfirmedDeviveryJson (JSON_EXTRACT(json_line,'$.date'), value) VALUES (date, json_line);
	UNTIL flag = 1
	END REPEAT
	CLOSE json_lines;
END$$
DELIMITER ;
call insert_json('2022-08-03')

CREATE PROCEDURE select_json_by_id(IN id INT UNSIGNED)
BEGIN
	SELECT value FROM ods.ConfirmedDeviveryJson WHERE JSON_EXTRACT(value,'$.id') = id;
END$$
DELIMITER ;

call select_json_by_id(1)