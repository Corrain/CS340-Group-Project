import mysql.connector

class CoffeeShopQueries(object):

    def __init__(self, cursor, connection=None):
        self.cursor = cursor
        self.connection = connection

    def _commit(self):
        """Commit if a connection object was provided."""
        if self.connection is not None:
            self.connection.commit()

    def get_all_items(self):
        """Get all items."""
        query = "SELECT Items.ItemID AS 'Item ID', Items.itemName AS Name, Items.itemDescription AS Description, Items.price AS Price FROM items"
        self.cursor.execute(query)
        return self.cursor.fetchall()

    # def get_all_item_ingredients(self):

    #     """Get all item ingredients."""
    #     query = "SELECT * FROM item_ingredients"
    #     self.cursor.execute(query)
    #     return self.cursor.fetchall()