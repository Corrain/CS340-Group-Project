-- CS 340 Project Step 4 DRAFT - Group 37 

-- PL/SQL Procedures for Coffee Shop Inventory and Sales Management System
-- Team members: Carl Curran and Thien Ngan Nguyen
-- These match the SQL statements in src/coffeeshop_database.py

-- Each read procedure returns all records from one of the eight project tables
-- Python passes user values safely with %s placeholders

-- This code is our own work.

-- READ for all eight tables
DROP PROCEDURE IF EXISTS sp_ReadAllItems;
DELIMITER //
CREATE PROCEDURE sp_ReadAllItems()
BEGIN
    SELECT itemID, itemName, description, unitPrice, isActive FROM Items ORDER BY itemID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReadAllIngredients;
DELIMITER //
CREATE PROCEDURE sp_ReadAllIngredients()
BEGIN
    SELECT ingredientID, ingredientName, description, unit, inventoryQty,
        reorderLevel, shelfLifeDays
    FROM Ingredients ORDER BY ingredientID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReadAllVendors;
DELIMITER //
CREATE PROCEDURE sp_ReadAllVendors()
BEGIN
    SELECT vendorID, vendorName, address, phone, contactEmail
    FROM Vendors ORDER BY vendorID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReadAllSales;
DELIMITER //
CREATE PROCEDURE sp_ReadAllSales()
BEGIN
    SELECT saleID, saleDateTime, totalSaleValue FROM Sales ORDER BY saleID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReadAllInvoices;
DELIMITER //
CREATE PROCEDURE sp_ReadAllInvoices()
BEGIN
    SELECT invoiceID, vendorID, invoiceDate, totalCost FROM Invoices ORDER BY invoiceID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReadAllSalesItems;
DELIMITER //
CREATE PROCEDURE sp_ReadAllSalesItems()
BEGIN
    SELECT si.saleItemID, si.saleID, si.itemID, i.itemName, si.quantity, si.salePrice
    FROM SalesItems AS si
    JOIN Items AS i ON si.itemID = i.itemID
    ORDER BY si.saleItemID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReadAllItemIngredients;
DELIMITER //
CREATE PROCEDURE sp_ReadAllItemIngredients()
BEGIN
    SELECT ii.itemIngredientID, ii.itemID, i.itemName, ii.ingredientID,
           ing.ingredientName, ing.unit, ii.quantityRequired
    FROM ItemIngredients AS ii
    JOIN Items AS i ON ii.itemID = i.itemID
    JOIN Ingredients AS ing ON ii.ingredientID = ing.ingredientID
    ORDER BY ii.itemIngredientID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReadAllInvoiceIngredients;
DELIMITER //
CREATE PROCEDURE sp_ReadAllInvoiceIngredients()
BEGIN
    SELECT ii.invoiceIngredientID, ii.invoiceID, ii.ingredientID,
           ing.ingredientName, ii.quantityPurchased, ii.unitCost
    FROM InvoiceIngredients AS ii
    JOIN Ingredients AS ing ON ii.ingredientID = ing.ingredientID
    ORDER BY ii.invoiceIngredientID;
END //
DELIMITER ;

-- Only ItemIngredients has CREATE, UPDATE and DELETE in this step

-- CREATE one intersection-table row
DROP PROCEDURE IF EXISTS sp_AddItemIngredient;
DELIMITER //
CREATE PROCEDURE sp_AddItemIngredient(
    IN p_itemID INT,
    IN p_ingredientID INT,
    IN p_quantityRequired DECIMAL(10, 2),
    OUT p_id INT
)
BEGIN
    INSERT INTO ItemIngredients (itemID, ingredientID, quantityRequired)
    VALUES (p_itemID, p_ingredientID, p_quantityRequired);
    -- SELECT LAST_INSERT_ID() INTO p_id;
    SET p_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- UPDATE a specific row
DROP PROCEDURE IF EXISTS sp_UpdateItemIngredient;
DELIMITER //
CREATE PROCEDURE sp_UpdateItemIngredient(
    IN p_itemIngredientID INT,
    IN p_quantityRequired DECIMAL(10, 2)
)
BEGIN
    UPDATE ItemIngredients
    SET quantityRequired = p_quantityRequired
    WHERE itemIngredientID = p_itemIngredientID;
END //
DELIMITER ;

-- Delete a specific row
DROP PROCEDURE IF EXISTS sp_DeleteItemIngredient;
DELIMITER //
CREATE PROCEDURE sp_DeleteItemIngredient(
    IN p_itemIngredientID INT
)
BEGIN
    DELETE FROM ItemIngredients WHERE itemIngredientID = p_itemIngredientID;
END //
DELIMITER ;
