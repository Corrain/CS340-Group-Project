--Code based on sample DML file from canvas

-- These are some Database Manipulation queries for a partially implemented Python Database 
-- using the coffeeshop invnetory and sales management database.
-- Your submission should contain ALL the queries required to implement ALL the
-- functionalities listed in the Project Specs.

--These must include:

    --SELECT queries for all tables
    --INSERT, UPDATE, and DELETE queries for the intersection table

--Variables that will be supplied by your Python code should be clearly marked using placeholder notation of your choice (e.g., @varName), along with SQL comments explaining the convention.


--Read/SELECT queries for all tables
--get all vendors

SELECT * FROM Vendors;

--get all ingredients
SELECT * FROM Ingredients;

--get all items
SELECT * FROM Items;

--get all invoices
SELECT * FROM Invoices;

--get all sales
SELECT * FROM Sales;

--get all sale items
SELECT * FROM SaleItems;

--get all item ingredients
SELECT * FROM ItemIngredients;

--get all invoice ingredients
SELECT * FROM InvoiceIngredients;   

--INSERT, UPDATE, and DELETE queries for the intersection table
--PLACEHOLDER VALUES: @itemID, @ingredientID, @quantityRequired
SET @itemID = 1;
SET @ingredientID = 1;
SET @quantityRequired = 0.09;

INSERT INTO `ItemIngredients` (`itemID`, `ingredientID`, `quantityRequired`) VALUES (@itemID, @ingredientID, @quantityRequired);
UPDATE `ItemIngredients` SET `quantityRequired` = @quantityRequired WHERE `itemID` = @itemID AND `ingredientID` = @ingredientID;
DELETE FROM `ItemIngredients` WHERE `itemID` = @itemID AND `ingredientID` = @ingredientID;
