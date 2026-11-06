# CS 340 Group 37 – Coffee Shop Inventory and Sales Management System

Authors: Carl Curran and Thien Ngan Nguyen

This code is aligned to the current Group 37 Step 3 report and its eight-table schema. It uses one Python application 
class to read all eight tables and add, update or delete relationships in `ItemIngredients`.

## What changed from the `folderSetup` GitHub branch

- Corrected `itemDescription` to `description` in `Items` and `SaleItems` to `SalesItems`.
- Included the remaining fields in the Ingredients and intersection table SELECT methods.
- Updated and deleted `ItemIngredients` by the `itemIngredientID` primary key, as described in the report.
- Returned `lastrowid` or `rowcount` from the write methods.
- Added safe rollback and an optional database connection within the class.
- Replaced the old DDL and DML with the schema, constraints and sample data from the current report.
- Replaced the unfinished 12-line test example with a driver that calls every required method and checks the results.

## Files

- `sql/DDL.sql` – recreates the eight tables and inserts report sample data
- `sql/DML.sql` – SQL for the eight READs and the three `ItemIngredients` writes
- `src/coffeeshop_database.py` – the `CoffeeShopDAO` class
- `tests/database_test.py` – the test/driver program
- `requirements.txt` – Python dependency

## Run locally on Mac or VS Code

1. Start MySQL or MariaDB and open the extracted project folder in VS Code.
2. In the integrated Terminal, run `python -m pip install -r requirements.txt`.
3. Create a **separate test database**:
   `mysql -h 127.0.0.1 -u root -p -e "CREATE DATABASE IF NOT EXISTS cs340_coffee_shop;"`
4. Import the sample schema and records:
   `mysql -h 127.0.0.1 -u root -p cs340_coffee_shop < sql/DDL.sql`
5. Test: `python tests/database_test.py` and enter your database password when prompted.
6. After it succeeds, capture genuine output for submission:
   `set -o pipefail; python -u tests/database_test.py 2>&1 | tee CLI_OUT.txt`

**Warning:** DDL.sql drops and recreates the eight project tables. Never import it into a database with important data.

Expected starting counts: Items 3, Ingredients 3, Vendors 3, Sales 3, Invoices 4, SalesItems 5, ItemIngredients 5 and 
InvoiceIngredients 5. All tests should end with `ALL REQUIRED METHODS PASSED THIS LOCAL TEST`.

The driver adds a temporary Latte/Chocolate Syrup recipe row, updates its quantity, then deletes it. The original 
records should remain unchanged afterward. It also checks duplicate relationships, nonexistent IDs, foreign keys and the 
original sale/invoice totals.

## Integration with your teammate's repository

Copy `src/coffeeshop_database.py`, `tests/database_test.py`, `sql/DDL.sql` and `sql/DML.sql` into the corresponding 
folders on the GitHub branch. The class name remains `CoffeeShopDAO` and the existing `CoffeeShopDAO(cursor, conn)` 
constructor still works. **Update any callers:** `update_item_ingredient(itemIngredientID, quantityRequired)` and 
`delete_item_ingredient(itemIngredientID)` now use the row's primary key rather than `(itemID, ingredientID)`.

The final ZIP includes the project PDF and the local test output in `CLI_OUT.txt`. Confirm they match the final code and review the AI disclosure before uploading. One teammate should then submit the 
Ed Discussion URL to Canvas.

## Acknowledgments

Our class started from the Group 37 team code and the CS 340 Python CRUD assignment concepts.
 