# CS 340 Group 37 – Coffee Shop Inventory and Sales Management System
Carl Curran and Thien Ngan Nguyen

## Project Description
The Coffee Shop Inventory and Sales Management System uses a Python class to interact with a database that helps a small 
coffee shop manage item sales, ingredients, inventory purchases and vendor information in one place.
For Project Step 3, we created a Python class called `CoffeeShopDAO` that uses SQL queries to access our eight database
tables. The class includes SELECT methods for all eight tables and INSERT, UPDATE and DELETE methods for the 
`ItemIngredients` intersection table.
We also created a Python test script to call these methods and check that they work correctly.

## Project Files
- `sql/DDL.sql` – Creates the eight database tables and inserts sample data.
- `sql/DML.sql` – Contains the SELECT, INSERT, UPDATE and DELETE queries.
- `src/coffeeshop_database.py` – Contains the `CoffeeShopDAO` Python class.
- `tests/database_test.py` – Tests the required database methods.
- `CLI_OUT.txt` – Contains the actual command-line output from our tests.
- `requirements.txt` – Lists the Python package needed for the project.
- `Group37_Step3_Draft.pdf` – Contains the updated project report, ERD, schema and sample data.

## Requirements
To run our application, you need:
- Python 3
- MySQL or MariaDB
- `mysql-connector-python`
- A terminal or code editor such as VS Code

Install the required Python package by running:
python -m pip install -r requirements.txt

## Database Setup
1. Start your local MySQL or MariaDB server.
2. Open the project folder in VS Code.
3. Open a new terminal.
4. Create a separate database for testing:
mysql -h 127.0.0.1 -u root -p -e "CREATE DATABASE IF NOT EXISTS cs340_coffee_shop;"


5. Import the database tables and sample data:
mysql -h 127.0.0.1 -u root -p cs340_coffee_shop < sql/DDL.sql


Enter your MySQL password when prompted.
**Note:** `DDL.sql` deletes and recreates the eight project tables. We recommend using a separate test database so 
existing data is not affected.

## Running the Application
After setting up the database, run the test script from the main project folder:
python tests/database_test.py

Enter your MySQL password when prompted.
The script calls all eight SELECT methods and prints the records from each table. It also tests the CREATE, UPDATE and 
DELETE methods for `ItemIngredients`.

To save the command-line output in `CLI_OUT.txt`, run:
set -o pipefail
python -u tests/database_test.py 2>&1 | tee CLI_OUT.txt

## Expected Output
The original sample data should contain:

| Table | Expected Rows |
|---|---:|
| Items | 3 |
| Ingredients | 3 |
| Vendors | 3 |
| Sales | 3 |
| Invoices | 4 |
| SalesItems | 5 |
| ItemIngredients | 5 |
| InvoiceIngredients | 5 |

The test script first reads the records from all eight tables and checks that the sale and invoice totals match their detail records.
It then adds a temporary Latte and Chocolate Syrup relationship to `ItemIngredients`, updates its quantity and deletes the relationship.
The script also checks duplicate relationships, invalid foreign keys and updates or deletions involving nonexistent records.
If all tests pass, the output should end with:
ALL REQUIRED METHODS PASSED THIS LOCAL TEST

The original sample relationships should remain unchanged after the tests.

## Acknowledgments and Citations
We used our previous CS 340 project drafts and class materials to design the database and understand SQL queries, 
intersection tables and CRUD operations.
Other materials:
- Oregon State University CS 340 course explorations and assignment instructions.
- Our Group 37 Project Step 1 and Step 2 submissions.
- The group's earlier Python code and SQL files.