-- CS 340 Project Step 3 Draft - Group 37
-- Coffee Shop Inventory and Sales Management System
-- Team members: Carl Curran and Thien Ngan Nguyen
-- Sample data matches our Group 37 Step 3 report
-- WARNING: This script deletes and recreates these eight tables
-- Run only inside a separate project TEST database

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS InvoiceIngredients;
DROP TABLE IF EXISTS ItemIngredients;
DROP TABLE IF EXISTS SalesItems;
DROP TABLE IF EXISTS Invoices;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Vendors;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Items;
SET FOREIGN_KEY_CHECKS = 1;

-- Main tables
CREATE TABLE Items (
    itemID INT NOT NULL AUTO_INCREMENT,
    itemName VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    unitPrice DECIMAL(8,2) NOT NULL,
    isActive BOOLEAN NOT NULL,
    PRIMARY KEY (itemID)
) ENGINE=InnoDB;

CREATE TABLE Ingredients (
    ingredientID INT NOT NULL AUTO_INCREMENT,
    ingredientName VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    unit VARCHAR(20) NOT NULL,
    inventoryQty DECIMAL(10,2) NOT NULL,
    reorderLevel DECIMAL(10,2) NOT NULL,
    shelfLifeDays INT NULL,
    PRIMARY KEY (ingredientID)
) ENGINE=InnoDB;

CREATE TABLE Vendors (
    vendorID INT NOT NULL AUTO_INCREMENT,
    vendorName VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255) NULL,
    phone VARCHAR(20) NULL,
    contactEmail VARCHAR(100) NULL,
    PRIMARY KEY (vendorID)
) ENGINE=InnoDB;

CREATE TABLE Sales (
    saleID INT NOT NULL AUTO_INCREMENT,
    saleDateTime DATETIME NOT NULL,
    totalSaleValue DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (saleID)
) ENGINE=InnoDB;

CREATE TABLE Invoices (
    invoiceID INT NOT NULL AUTO_INCREMENT,
    vendorID INT NOT NULL,
    invoiceDate DATE NOT NULL,
    totalCost DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (invoiceID),
    FOREIGN KEY (vendorID) REFERENCES Vendors(vendorID)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Each intersection table has its own primary key and two foreign keys.
-- A UNIQUE pair prevents the same relationship from being entered twice.
CREATE TABLE SalesItems (
    saleItemID INT NOT NULL AUTO_INCREMENT,
    saleID INT NOT NULL,
    itemID INT NOT NULL,
    quantity INT NOT NULL,
    salePrice DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (saleItemID),
    UNIQUE (saleID, itemID),
    FOREIGN KEY (saleID) REFERENCES Sales(saleID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (itemID) REFERENCES Items(itemID)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ItemIngredients (
    itemIngredientID INT NOT NULL AUTO_INCREMENT,
    itemID INT NOT NULL,
    ingredientID INT NOT NULL,
    quantityRequired DECIMAL(10,2) NOT NULL,
    CHECK (quantityRequired > 0),
    PRIMARY KEY (itemIngredientID),
    UNIQUE (itemID, ingredientID),
    FOREIGN KEY (itemID) REFERENCES Items(itemID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ingredientID) REFERENCES Ingredients(ingredientID)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE InvoiceIngredients (
    invoiceIngredientID INT NOT NULL AUTO_INCREMENT,
    invoiceID INT NOT NULL,
    ingredientID INT NOT NULL,
    quantityPurchased DECIMAL(10,2) NOT NULL,
    unitCost DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (invoiceIngredientID),
    UNIQUE (invoiceID, ingredientID),
    FOREIGN KEY (invoiceID) REFERENCES Invoices(invoiceID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ingredientID) REFERENCES Ingredients(ingredientID)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Sample data below matches the Step 3 PDF tables.
START TRANSACTION;
INSERT INTO Items (itemID, itemName, description, unitPrice, isActive) VALUES
    (1, 'Espresso', 'Double espresso', 3.00, 1),
    (2, 'Latte', 'Espresso with steamed milk', 4.50, 1),
    (3, 'Hot Chocolate', NULL, 4.00, 1);

INSERT INTO Ingredients (ingredientID, ingredientName, description, unit, inventoryQty, reorderLevel, shelfLifeDays) VALUES
    (1, 'Espresso Beans', NULL, 'kg', 4.50, 1.00, 90),
    (2, 'Whole Milk', 'Refrigerated dairy milk', 'L', 12.00, 4.00, 7),
    (3, 'Chocolate Syrup', NULL, 'L', 2.00, 0.50, 180);

INSERT INTO Vendors (vendorID, vendorName, address, phone, contactEmail) VALUES
    (1, 'Cascadia Cafe Supply', '100 Market Way, Corvallis, OR', '541-555-0131', 'orders@cascadia.example.com'),
    (2, 'Cocoa Pantry Wholesale', '250 Depot Rd, Albany, OR', '541-555-0132', 'orders@cocoa.example.com'),
    (3, 'Willamette Dairy Co.', NULL, '541-555-0133', 'orders@dairy.example.com');

INSERT INTO Sales (saleID, saleDateTime, totalSaleValue) VALUES
    (1, '2026-10-23 09:15:00', 12.00),
    (2, '2026-10-23 10:05:00', 4.50),
    (3, '2026-10-24 11:30:00', 7.00);

INSERT INTO Invoices (invoiceID, vendorID, invoiceDate, totalCost) VALUES
    (1, 1, '2026-10-19', 73.00),
    (2, 1, '2026-10-20', 37.50),
    (3, 2, '2026-10-21', 30.00),
    (4, 3, '2026-10-22', 19.20);

INSERT INTO SalesItems (saleItemID, saleID, itemID, quantity, salePrice) VALUES
    (1, 1, 2, 2, 4.50),
    (2, 1, 1, 1, 3.00),
    (3, 2, 2, 1, 4.50),
    (4, 3, 3, 1, 4.00),
    (5, 3, 1, 1, 3.00);

INSERT INTO ItemIngredients (itemIngredientID, itemID, ingredientID, quantityRequired) VALUES
    (1, 1, 1, 0.02),
    (2, 2, 1, 0.02),
    (3, 2, 2, 0.24),
    (4, 3, 2, 0.25),
    (5, 3, 3, 0.03);

INSERT INTO InvoiceIngredients (invoiceIngredientID, invoiceID, ingredientID, quantityPurchased, unitCost) VALUES
    (1, 1, 1, 2.00, 24.00),
    (2, 1, 2, 10.00, 2.50),
    (3, 2, 1, 1.50, 25.00),
    (4, 3, 3, 3.00, 10.00),
    (5, 4, 2, 8.00, 2.40);
COMMIT;

-- These read-only checks help compare the headers with their detail rows.
SELECT s.saleID, s.totalSaleValue, SUM(si.quantity * si.salePrice) AS calculatedTotal
FROM Sales AS s INNER JOIN SalesItems AS si ON s.saleID = si.saleID
GROUP BY s.saleID, s.totalSaleValue ORDER BY s.saleID;

SELECT i.invoiceID, i.totalCost, SUM(ii.quantityPurchased * ii.unitCost) AS calculatedTotal
FROM Invoices AS i INNER JOIN InvoiceIngredients AS ii ON i.invoiceID = ii.invoiceID
GROUP BY i.invoiceID, i.totalCost ORDER BY i.invoiceID;
