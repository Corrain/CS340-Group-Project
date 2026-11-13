-- CS 340 Group 37 - Data Manipulation Queries (DML)
-- Team members: Carl Curran and Thien Ngan Nguyen
-- These match the SQL statements in src/coffeeshop_database.py
-- Each SELECT returns all records from one of the eight project tables
-- Python passes user values safely with %s placeholders
-- In this stand alone MySQL file, @variables demonstrate the same inputs
-- Run this in the cs340_coffee_shop TEST database after importing DDL.sql

-- READ for all eight tables
SELECT itemID, itemName, description, unitPrice, isActive FROM Items ORDER BY itemID;

SELECT ingredientID, ingredientName, description, unit, inventoryQty,
       reorderLevel, shelfLifeDays
FROM Ingredients ORDER BY ingredientID;

SELECT vendorID, vendorName, address, phone, contactEmail
FROM Vendors ORDER BY vendorID;

SELECT saleID, saleDateTime, totalSaleValue FROM Sales ORDER BY saleID;

SELECT invoiceID, vendorID, invoiceDate, totalCost FROM Invoices ORDER BY invoiceID;

SELECT si.saleItemID, si.saleID, si.itemID, i.itemName, si.quantity, si.salePrice
FROM SalesItems AS si
JOIN Items AS i ON si.itemID = i.itemID
ORDER BY si.saleItemID;

SELECT ii.itemIngredientID, ii.itemID, i.itemName, ii.ingredientID,
       ing.ingredientName, ing.unit, ii.quantityRequired
FROM ItemIngredients AS ii
JOIN Items AS i ON ii.itemID = i.itemID
JOIN Ingredients AS ing ON ii.ingredientID = ing.ingredientID
ORDER BY ii.itemIngredientID;

SELECT ii.invoiceIngredientID, ii.invoiceID, ii.ingredientID,
       ing.ingredientName, ii.quantityPurchased, ii.unitCost
FROM InvoiceIngredients AS ii
JOIN Ingredients AS ing ON ii.ingredientID = ing.ingredientID
ORDER BY ii.invoiceIngredientID;

-- Only ItemIngredients has CREATE, UPDATE and DELETE in this step
-- Item 2 (Latte) does not yet have Ingredient 3 (Chocolate Syrup)
-- These values are for a reversible example, not a permanent recipe change
SET @itemID = 2;
SET @ingredientID = 3;
SET @quantityRequired = 0.03;

START TRANSACTION;

-- CREATE one intersection-table row
INSERT INTO ItemIngredients (itemID, ingredientID, quantityRequired)
VALUES (@itemID, @ingredientID, @quantityRequired);

-- Save the new primary key for the update and delete queries
SET @itemIngredientID = LAST_INSERT_ID();
SELECT itemIngredientID, itemID, ingredientID, quantityRequired
FROM ItemIngredients WHERE itemIngredientID = @itemIngredientID;

-- UPDATE that new row
SET @quantityRequired = 0.05;
UPDATE ItemIngredients SET quantityRequired = @quantityRequired
WHERE itemIngredientID = @itemIngredientID;
SELECT itemIngredientID, itemID, ingredientID, quantityRequired
FROM ItemIngredients WHERE itemIngredientID = @itemIngredientID;

-- DELETE that new row
DELETE FROM ItemIngredients WHERE itemIngredientID = @itemIngredientID;
SELECT itemIngredientID, itemID, ingredientID, quantityRequired
FROM ItemIngredients WHERE itemIngredientID = @itemIngredientID;

-- The demo does not permanently change the imported sample data
ROLLBACK;
