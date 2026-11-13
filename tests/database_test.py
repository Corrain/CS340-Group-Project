"""CS 340 Group 37 - test our database application class.
We should run these against our own MySQL test database before submitting the project.
"""

import getpass
import os
import sys
from decimal import Decimal
from pathlib import Path

import mysql.connector

# Let this test import the class from the neighboring src folder
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from coffeeshop_database import CoffeeShopDAO


EXPECTED_COUNTS = {
    "Items": 3,
    "Ingredients": 3,
    "Vendors": 3,
    "Sales": 3,
    "Invoices": 4,
    "SalesItems": 5,
    "ItemIngredients": 5,
    "InvoiceIngredients": 5,
}


def show_and_check(name, rows):
    expected = EXPECTED_COUNTS[name]
    print("\n" + name + " (" + str(len(rows)) + " rows)")
    for row in rows:
        print(row)
    assert len(rows) == expected, f"{name}: expected {expected} rows, got {len(rows)}"
    print("PASS:", name, "has", expected, "rows")

def check_number_of_rows(dao, label):
    rows = dao.get_all_item_ingredients()
    print(f"\nItemIngredients number of entries after {label}: ({len(rows)} rows)")
    for row in rows:
        print(row)

def check_totals(dao):
    # Calculate totals using the rows returned by the class methods
    sale_totals = {}

    for r in dao.get_all_sale_items():
        sale_id = r["saleID"]
        sale_totals[sale_id] = sale_totals.get(sale_id, Decimal("0")) + r["quantity"] * r["salePrice"]
    for r in dao.get_all_sales():
        sale_id, date, total = r["saleID"], r["saleDateTime"], r["totalSaleValue"]
        assert sale_totals[sale_id] == total, f"Sale {sale_id} total does not match"
        print("PASS: Sale", sale_id, "total =", total)

    invoice_totals = {}
    for r in dao.get_all_invoice_ingredients():
        invoice_id = r["invoiceID"]
        invoice_totals[invoice_id] = invoice_totals.get(invoice_id, Decimal("0")) + r["quantityPurchased"] * r["unitCost"]
    for r in dao.get_all_invoices():
        invoice_id, vendor_id, date, total = r["invoiceID"], r["vendorID"], r["invoiceDate"], r["totalCost"]
        assert invoice_totals[invoice_id] == total, f"Invoice {invoice_id} total does not match"
        print("PASS: Invoice", invoice_id, "totalCost =", total)


def main():
    password = os.environ.get("CS340_DB_PASSWORD")
    if password is None:
        password = getpass.getpass("MySQL password: ")

    dao = CoffeeShopDAO(
        host=os.environ.get("CS340_DB_HOST", "127.0.0.1"),
        user=os.environ.get("CS340_DB_USER", "root"),
        password=password,
        database=os.environ.get("CS340_DB_NAME", "cs340_coffee_shop"),
    )

    try:
        print("CS 340 Group 37 - Coffee Shop Step 3 Test")
        print("Testing the eight READ methods")
        show_and_check("Items", dao.get_all_items())
        show_and_check("Ingredients", dao.get_all_ingredients())
        show_and_check("Vendors", dao.get_all_vendors())
        show_and_check("Sales", dao.get_all_sales())
        show_and_check("Invoices", dao.get_all_invoices())
        show_and_check("SalesItems", dao.get_all_sale_items())
        show_and_check("ItemIngredients", dao.get_all_item_ingredients())
        show_and_check("InvoiceIngredients", dao.get_all_invoice_ingredients())
        print("\nPASS: All eight READ methods worked")

        # The sample has no Latte + Chocolate Syrup relationship yet
        original = dao.get_all_item_ingredients()
        assert not any(row["itemID"] == 2 and row["ingredientID"] == 3 for row in original), (
            "Latte + Chocolate Syrup already exists. Re-import the test DDL first."
        )

        print("\nChecking the sale and invoice totals")
        check_totals(dao)

        print("\nTesting CREATE, UPDATE, DELETE on ItemIngredients")
        new_id = None
        try:
            new_id = dao.add_item_ingredient(2, 3, Decimal("0.03"))
            rows = [r for r in dao.get_all_item_ingredients() if r["itemIngredientID"] == new_id]
            assert len(rows) == 1 and (rows[0]["itemID"], rows[0]["ingredientID"]) == (2, 3)
            print("New item ingredient row:", rows[0])
            check_number_of_rows(dao, "CREATE")
            print("PASS CREATE: new itemIngredientID =", new_id)

            count = dao.update_item_ingredient(new_id, Decimal("0.05"))
            rows = [r for r in dao.get_all_item_ingredients() if r["itemIngredientID"] == new_id]
            assert count == 1 and rows[0]["quantityRequired"] == Decimal("0.05")
            print("Updated item ingredient row:", rows[0])
            check_number_of_rows(dao, "UPDATE")
            print("PASS UPDATE: quantityRequired =", rows[0]["quantityRequired"])

            count = dao.delete_item_ingredient(new_id)
            assert count == 1
            new_id = None
            check_number_of_rows(dao, "DELETE")
            print("PASS DELETE: temporary relationship was removed")
        finally:
            # Clean up if an earlier check failed after the insert
            if new_id is not None:
                dao.delete_item_ingredient(new_id)

        assert dao.get_all_item_ingredients() == original
        print("PASS: Original recipe records are restored")

        assert dao.update_item_ingredient(99999, Decimal("0.25")) == 0
        assert dao.delete_item_ingredient(99999) == 0
        print("PASS: Nonexistent primary keys affect 0 rows")

        try:
            dao.add_item_ingredient(1, 1, Decimal("0.02"))
            raise AssertionError("A duplicate relationship was accepted")
        except mysql.connector.IntegrityError:
            print("PASS: Duplicate relationship was rejected")

        try:
            dao.add_item_ingredient(99999, 1, Decimal("0.02"))
            raise AssertionError("An invalid foreign key was accepted")
        except mysql.connector.IntegrityError:
            print("PASS: Invalid foreign key was rejected")

        assert dao.get_all_item_ingredients() == original
        print("\nALL REQUIRED METHODS PASSED THIS LOCAL TEST")
    finally:
        dao.close()


if __name__ == "__main__":
    main()
