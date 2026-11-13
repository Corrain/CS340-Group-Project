"""CS 340 Group 37 - Coffee Shop database class.
Team members: Carl Curran and Thien Ngan Nguyen
Based on the group's starter code.
"""

import mysql.connector

class CoffeeShopDAO(object):
    """run the coffee shop queries through a Python class"""

    def __init__(self, cursor=None, connection=None, host="127.0.0.1",
                 user="root", password="", database="cs340_coffee_shop"):
        # The class can open a connection or use one provided by the caller
        self.owns_connection = cursor is None
        if self.owns_connection:
            self.connection = mysql.connector.connect(
                host=host, user=user, password=password, database=database
            )
            self.cursor = self.connection.cursor(dictionary=True)
        else:
            self.cursor = cursor
            self.connection = connection

    def _commit(self):
        '''Commit the current transaction if a connection is available.'''
        if self.connection is not None:
            self.connection.commit()

    def _rollback(self):
        '''Roll back the current transaction if a connection is available.'''
        if self.connection is not None:
            self.connection.rollback()

    def close(self):
        '''Close the cursor and connection if this class opened them.'''
        # Only close the connection if this class opened it
        if self.owns_connection:
            self.cursor.close()
            self.connection.close()

    # READ: Get all rows from each of our eight tables
    def get_all_items(self):
        '''Get all rows from the Items table.'''
        query = "SELECT itemID, itemName, description, unitPrice, isActive FROM Items ORDER BY itemID"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_ingredients(self):
        '''Get all rows from the Ingredients table.'''
        query = """SELECT ingredientID, ingredientName, description, unit,
                          inventoryQty, reorderLevel, shelfLifeDays
                   FROM Ingredients ORDER BY ingredientID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_vendors(self):
        '''Get all rows from the Vendors table.'''
        query = """SELECT vendorID, vendorName, address, phone, contactEmail
                   FROM Vendors ORDER BY vendorID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_sales(self):
        '''Get all rows from the Sales table.'''
        query = "SELECT saleID, saleDateTime, totalSaleValue FROM Sales ORDER BY saleID"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_invoices(self):
        '''Get all rows from the Invoices table.'''
        query = """SELECT invoiceID, vendorID, invoiceDate, totalCost
                   FROM Invoices ORDER BY invoiceID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_sale_items(self):
        # The table is called SalesItems, with an s
        '''Get all rows from the SalesItems table.'''
        query = """SELECT si.saleItemID, si.saleID, si.itemID, i.itemName,
                          si.quantity, si.salePrice
                   FROM SalesItems AS si
                   JOIN Items AS i ON si.itemID = i.itemID
                   ORDER BY si.saleItemID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_item_ingredients(self):
        '''Get all rows from the ItemIngredients table.'''
        query = """SELECT ii.itemIngredientID, ii.itemID, i.itemName, ii.ingredientID,
                          ing.ingredientName, ing.unit, ii.quantityRequired
                   FROM ItemIngredients AS ii
                   JOIN Items AS i ON ii.itemID = i.itemID
                   JOIN Ingredients AS ing ON ii.ingredientID = ing.ingredientID
                   ORDER BY ii.itemIngredientID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_invoice_ingredients(self):
        '''Get all rows from the InvoiceIngredients table.'''
        query = """SELECT ii.invoiceIngredientID, ii.invoiceID, ii.ingredientID,
                          ing.ingredientName, ii.quantityPurchased, ii.unitCost
                   FROM InvoiceIngredients AS ii
                   JOIN Ingredients AS ing ON ii.ingredientID = ing.ingredientID
                   ORDER BY ii.invoiceIngredientID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    # CREATE: Add an ingredient relationship for one menu item
    def add_item_ingredient(self, itemID, ingredientID, quantityRequired):
        '''Add an ingredient relationship for one menu item.'''
        query = """INSERT INTO ItemIngredients (itemID, ingredientID, quantityRequired)
                   VALUES (%s, %s, %s)"""
        try:
            self.cursor.execute(query, (itemID, ingredientID, quantityRequired))
            new_id = self.cursor.lastrowid
            self._commit()
            return new_id
        except mysql.connector.Error:
            self._rollback()
            raise

    # UPDATE: Change one recipe row using its primary key
    def update_item_ingredient(self, itemIngredientID, quantityRequired):
        '''Update the required quantity for one recipe row.'''
        query = """UPDATE ItemIngredients SET quantityRequired = %s
                   WHERE itemIngredientID = %s"""
        try:
            self.cursor.execute(query, (quantityRequired, itemIngredientID))
            changed = self.cursor.rowcount
            self._commit()
            return changed
        except mysql.connector.Error:
            self._rollback()
            raise

    # DELETE: Remove one recipe row using its primary key
    def delete_item_ingredient(self, itemIngredientID):
        '''Delete one recipe row using its primary key.'''
        query = "DELETE FROM ItemIngredients WHERE itemIngredientID = %s"
        try:
            self.cursor.execute(query, (itemIngredientID,))
            changed = self.cursor.rowcount
            self._commit()
            return changed
        except mysql.connector.Error:
            self._rollback()
            raise
