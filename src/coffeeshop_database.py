import mysql.connector

class CoffeeShopDAO(object):
    """Class to handle queries for the Coffee Shop database."""

    def __init__(self, cursor, connection=None):
        self.cursor = cursor
        self.connection = connection

    def _commit(self):
        """Commit if a connection object was provided."""
        if self.connection is not None:
            self.connection.commit()

    def get_all_items(self):
        """Get all items."""
        query = "SELECT itemID, itemName, itemDescription, unitPrice, isActive FROM Items;"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_ingredients(self):
        """Get all ingredients."""
        query = "SELECT ingredientID, ingredientName, description, unit, inventoryQty FROM Ingredients;"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_invoices(self):
        """Get all invoices."""
        query = "SELECT invoiceID, vendorID, invoiceDate, totalCost FROM Invoices;"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_vendors(self):
        """Get all vendors."""
        query = "SELECT vendorID, vendorName, address, phone, contactEmail FROM Vendors;"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_sales(self):
        """Get all sales."""
        query = "SELECT saleID, saleDateTime, totalSaleValue FROM Sales;"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_sale_items(self):
        """Get all sale items."""
        query = "SELECT saleID, itemID, quantity FROM SaleItems;"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_invoice_ingredients(self):
        """Get all invoice ingredients."""
        query = "SELECT invoiceID, ingredientID, quantityPurchased, unitCost FROM InvoiceIngredients;"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def get_all_item_ingredients(self):
        """Get all item ingredients."""
        query = "SELECT itemID, ingredientID, quantityRequired FROM ItemIngredients;"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def add_item_ingredient(self, itemID, ingredientID, quantityRequired):
        """Add a new item ingredient."""
        query = "INSERT INTO ItemIngredients (itemID, ingredientID, quantityRequired) VALUES (%s, %s, %s);"

        try:
            self.cursor.execute(query, (itemID, ingredientID, quantityRequired))
            self._commit()
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            self.connection.rollback()  # Rollback in case of error
            raise  # Re-raise the exception to be handled by the caller

    def update_item_ingredient(self, itemID, ingredientID, quantityRequired):
        """Update an existing item ingredient."""
        query = "UPDATE ItemIngredients SET quantityRequired = %s WHERE itemID = %s AND ingredientID = %s;"

        try:
            self.cursor.execute(query, (quantityRequired, itemID, ingredientID))
            self._commit()
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            self.connection.rollback()  # Rollback in case of error
            raise  # Re-raise the exception to be handled by the caller

    def delete_item_ingredient(self, itemID, ingredientID):
        """Delete an item ingredient."""
        query = "DELETE FROM ItemIngredients WHERE itemID = %s AND ingredientID = %s;"
        try:
            self.cursor.execute(query, (itemID, ingredientID))
            self._commit()
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            self.connection.rollback()  # Rollback in case of error
            raise  # Re-raise the exception to be handled by the caller