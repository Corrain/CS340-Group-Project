/*
Group 37
Members:
- Carl Curran
- Thien Ngan Nguyen
*/

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

--Create Items Table
DROP TABLE IF EXISTS Items;
CREATE TABLE Items (
  itemID int(11) NOT NULL AUTO_INCREMENT,
  itemName varchar(100) NOT NULL,
  description VARCHAR(255) DEFAULT NULL,
  unitPrice DECIMAL(8,2) NOT NULL,
  isActive boolean NOT NULL,
  PRIMARY KEY (itemID),
  UNIQUE KEY itemName (itemName)
);

--Create Ingredients Table
DROP TABLE IF EXISTS Ingredients;
CREATE TABLE Ingredients (
  ingredientID int(11) NOT NULL AUTO_INCREMENT,
  ingredientName varchar(255) NOT NULL,
  description varchar(255) DEFAULT NULL,
  unit VARCHAR(255) NOT NULL,
  inventoryQty DECIMAL(10,2) NOT NULL,
  reorderLevel DECIMAL(10,2) NOT NULL,
  shelflifeDays int(11) NOT NULL,
  PRIMARY KEY (ingredientID)
);

--Create Vendors Table
DROP TABLE IF EXISTS Vendors;
CREATE TABLE Vendors (
  vendorID int(11) NOT NULL AUTO_INCREMENT,
  vendorName varchar(100) NOT NULL UNIQUE,
  address varchar(255) DEFAULT NULL,
  phone varchar(20) DEFAULT NULL,
  contactEmail varchar(100) DEFAULT NULL,
  PRIMARY KEY (vendorID)
);

--Create Invoices Table
DROP TABLE IF EXISTS Invoices;
CREATE TABLE Invoices (
  invoiceID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
  vendorID int(11) NOT NULL,
  invoiceDate DATE NOT NULL,
  totalCost DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (invoiceID),
  KEY vendorID (vendorID),
  FOREIGN KEY (vendorID) REFERENCES Vendors (vendorID)
);

--Create Sales Table
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
  saleID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
  saleDateTime DATETIME NOT NULL,
  totalSaleValue DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (saleID)
);

--Create SaleItems Table
DROP TABLE IF EXISTS SaleItems;
CREATE TABLE SaleItems (
  saleItemID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
  saleID int(11) NOT NULL,
  itemID int(11) NOT NULL,
  quantity int(11) NOT NULL,
  salePrice DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (saleItemID),
  FOREIGN KEY (saleID) REFERENCES Sales (saleID),
  FOREIGN KEY (itemID) REFERENCES Items (itemID)
);

--Create ItemIngredients Table
DROP TABLE IF EXISTS ItemIngredients;
CREATE TABLE ItemIngredients (
  itemIngredientID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
  itemID int(11) NOT NULL,
  ingredientID int(11) NOT NULL,
  quantityRequired DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (itemIngredientID),
  FOREIGN KEY (itemID) REFERENCES Items (itemID),
  FOREIGN KEY (ingredientID) REFERENCES Ingredients (ingredientID)
);

--Create InvoiceIngredients Table
DROP TABLE IF EXISTS InvoiceIngredients;
CREATE TABLE InvoiceIngredients (
  invoiceIngredientID int(11) NOT NULL AUTO_INCREMENT UNIQUE,
  invoiceID int(11) NOT NULL,
  ingredientID int(11) NOT NULL,
  quantityPurchased DECIMAL(10,2) NOT NULL,
  unitCost DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (invoiceIngredientID),
  FOREIGN KEY (invoiceID) REFERENCES Invoices (invoiceID),
  FOREIGN KEY (ingredientID) REFERENCES Ingredients (ingredientID)
);

--Insert sample data into Items Table
INSERT INTO Items (
  itemID,
  itemName,
  description,
  unitPrice,
  isActive
)
VALUES 
(1,'coffee','Medium blend drip coffee',2.50,True),
(2,'cookie','Chocolate chip cookie',4.00,True),
(3,'Latte','1/3 espresso, 1/3 steamed milk, 1/3 foam',5.50,True),
(4,'Pumpkin Spice Latte','Spiced pumpkin flavor in a creamy espresso drink ',6.50,True);

--Insert sample data into Ingredients Table
INSERT INTO Ingredients (
  ingredientID,
  ingredientName,
  description,
  unit,
  inventoryQty,
  reorderLevel,
  shelflifeDays
)
VALUES 
(1,'Coffee Beans','Costa Rican Tarrazu city blend','lbs',20.00,4.00,30),
(2,'sugar','Raw Hawaiian Sugar','lbs',5.00,1.00,240),
(3,'Milk','Whole Milk','gallons',3.00,1.00,7);

--Insert sample data into Vendors Table
INSERT INTO Vendors (
  vendorID,
  vendorName,
  address,
  phone,
  contactEmail
)
VALUES 
(1,'Costco','4401 4th Ave S, Seattle, WA 98134','(206) 622-3136',NULL),
(2,'Prestogeorge Coffee & Tea','1719 Penn Ave. Pittsburgh, PA 15222','412-471-0133','customerservice@prestogeorge.com'),
(3,'Levain Bakery ','1484 3rd Ave, New York, NY 10028','+19174645578','Lavain.contact@gmail.com');

--Insert sample data into Invoices Table
INSERT INTO Invoices (
  invoiceID,
  vendorID,
  invoiceDate,
  totalCost
)
VALUES 
(1,1,'2026-10-04',125.00),
(2,1,'2023-05-03',400.00),
(3,3,'2026-10-20',120.00);

--Insert sample data into Sales Table
INSERT INTO Sales (
  saleID,
  saleDateTime,
  totalSaleValue
)
VALUES 
(1,'2026-10-21 10:05:00',13.50),
(2,'2026-10-22 11:25:00',3.50),
(3,'2026-10-23 09:15:00',17.00);

--Insert sample data into SaleItems Table
INSERT INTO SaleItems (
  saleItemID,
  saleID,
  itemID,
  quantity,
  salePrice
)
VALUES 
(1,1,2,1,5.50),
(2,1,1,2,4.00),
(3,2,3,1,3.50),
(4,3,3,2,5.50),
(5,3,1,2,3.00); 

--Insert sample data into ItemIngredients Table
INSERT INTO ItemIngredients (
  itemIngredientID,
  itemID,
  ingredientID,
  quantityRequired
)
VALUES 
(1,1,1,0.03),
(2,1,2,0.25),
(3,2,3,0.24),
(4,3,3,0.02),
(5,3,2,0.04),
(6,4,3,0.25);

--Insert sample data into InvoiceIngredients Table
INSERT INTO InvoiceIngredients (
  invoiceIngredientID,
  invoiceID,
  ingredientID,
  quantityPurchased,
  unitCost
)
VALUES 
(1,1,1,10.00,10.00),
(2,1,2,5.00,5.00),
(3,2,3,20.00,20.00),
(4,3,2,40.00,3.00);  

SET FOREIGN_KEY_CHECKS=1;
COMMIT;