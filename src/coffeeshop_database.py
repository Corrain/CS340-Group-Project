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
            self.cursor = self.connection.cursor()
        else:
            self.cursor = cursor
            self.connection = connection

    def _commit(self):
        if self.connection is not None:
            self.connection.commit()

    def _rollback(self):
        if self.connection is not None:
            self.connection.rollback()

    def close(self):
        # Only close the connection if this class opened it
        if self.owns_connection:
            self.cursor.close()
            self.connection.close()

    # READ: Get all rows from each of our eight tables
    def get_all_items(self):
        query = "SELECT itemID, itemName, description, unitPrice, isActive FROM Items ORDER BY itemID"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_ingredients(self):
        query = """SELECT ingredientID, ingredientName, description, unit,
                          inventoryQty, reorderLevel, shelfLifeDays
                   FROM Ingredients ORDER BY ingredientID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_vendors(self):
        query = """SELECT vendorID, vendorName, address, phone, contactEmail
                   FROM Vendors ORDER BY vendorID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_sales(self):
        query = "SELECT saleID, saleDateTime, totalSaleValue FROM Sales ORDER BY saleID"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_invoices(self):
        query = """SELECT invoiceID, vendorID, invoiceDate, totalCost
                   FROM Invoices ORDER BY invoiceID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_sale_items(self):
        # The table is called SalesItems, with an s
        query = """SELECT saleItemID, saleID, itemID, quantity, salePrice
                   FROM SalesItems ORDER BY saleItemID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_item_ingredients(self):
        query = """SELECT itemIngredientID, itemID, ingredientID, quantityRequired
                   FROM ItemIngredients ORDER BY itemIngredientID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_invoice_ingredients(self):
        query = """SELECT invoiceIngredientID, invoiceID, ingredientID,
                          quantityPurchased, unitCost
                   FROM InvoiceIngredients ORDER BY invoiceIngredientID"""
        self.cursor.execute(query)
        return self.cursor.fetchall()

    # CREATE: Add an ingredient relationship for one menu item
    def add_item_ingredient(self, itemID, ingredientID, quantityRequired):
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
        query = "DELETE FROM ItemIngredients WHERE itemIngredientID = %s"
        try:
            self.cursor.execute(query, (itemIngredientID,))
            changed = self.cursor.rowcount
            self._commit()
            return changed
        except mysql.connector.Error:
            self._rollback()
            raise
