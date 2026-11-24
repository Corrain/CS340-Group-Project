"""CS 340 Group 37 - Coffee Shop database class.
Team members: Carl Curran and Thien Ngan Nguyen
Based on the group's starter code.

This code is our own work.
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
        query = "CALL sp_ReadAllItems()"
        # "SELECT itemID, itemName, description, unitPrice, isActive FROM Items ORDER BY itemID"
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        self.cursor.nextset()
        return rows

    def get_all_ingredients(self):
        '''Get all rows from the Ingredients table.'''
        query = "CALL sp_ReadAllIngredients()"
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        self.cursor.nextset()
        return rows

    def get_all_vendors(self):
        '''Get all rows from the Vendors table.'''
        query = "CALL sp_ReadAllVendors()"
        # """SELECT vendorID, vendorName, address, phone, contactEmail
        #            FROM Vendors ORDER BY vendorID"""
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        self.cursor.nextset()
        return rows

    def get_all_sales(self):
        '''Get all rows from the Sales table.'''
        query = "CALL sp_ReadAllSales()"
        # "SELECT saleID, saleDateTime, totalSaleValue FROM Sales ORDER BY saleID"
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        self.cursor.nextset()
        return rows

    def get_all_invoices(self):
        '''Get all rows from the Invoices table.'''
        query = "CALL sp_ReadAllInvoices()"
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        self.cursor.nextset()
        return rows

    def get_all_sale_items(self):
        # The table is called SalesItems, with an s
        '''Get all rows from the SalesItems table.'''
        query = "CALL sp_ReadAllSalesItems()"
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        self.cursor.nextset()
        return rows

    def get_all_item_ingredients(self):
        '''Get all rows from the ItemIngredients table.'''
        query = "CALL sp_ReadAllItemIngredients()"
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        self.cursor.nextset()
        return rows

    def get_all_invoice_ingredients(self):
        '''Get all rows from the InvoiceIngredients table.'''
        query = "CALL sp_ReadAllInvoiceIngredients()"
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        self.cursor.nextset()
        return rows

    # CREATE: Add an ingredient relationship for one menu item
    def add_item_ingredient(self, itemID, ingredientID, quantityRequired):
        '''Add an ingredient relationship for one menu item.'''
        query = "CALL sp_AddItemIngredient(%s, %s, %s, @new_id)"
        try:
            self.cursor.execute(query, (itemID, ingredientID, quantityRequired))
            while self.cursor.nextset():
                pass
            # new_id = self.cursor.lastrowid
            self.cursor.execute("SELECT @new_id AS newID")
            new_id = self.cursor.fetchone()["newID"]
            self._commit()
            # self.close()
            return new_id
        except mysql.connector.Error:
            self._rollback()
            raise

    # UPDATE: Change one recipe row using its primary key
    def update_item_ingredient(self, itemIngredientID, quantityRequired):
        '''Update the required quantity for one recipe row.'''
        query = "CALL sp_UpdateItemIngredient(%s, %s)"
        try:
            self.cursor.execute(query, (itemIngredientID, quantityRequired))
            # self.cursor.nextset()
            changed = self.cursor.rowcount
            self._commit()
            return changed
        except mysql.connector.Error:
            self._rollback()
            raise

    # DELETE: Remove one recipe row using its primary key
    def delete_item_ingredient(self, itemIngredientID):
        '''Delete one recipe row using its primary key.'''
        query = "CALL sp_DeleteItemIngredient(%s)"
        # """DELETE FROM ItemIngredients WHERE itemIngredientID = %s"""
        try:
            self.cursor.execute(query, (itemIngredientID,))
            # self.cursor.nextset()
            changed = self.cursor.rowcount
            # self.close()
            self._commit()
            return changed
        except mysql.connector.Error:
            self._rollback()
            raise

    # REST DB: Restore the database to its original state
    def reset_database(self):
        '''Restore the database to its original state.'''
        query = "CALL sp_ResetDB()"
        try:
            self.cursor.execute(query)
            while self.cursor.nextset():
                pass
            self._commit()
            # self.close()
            return True
        except mysql.connector.Error:
            self._rollback()
            raise