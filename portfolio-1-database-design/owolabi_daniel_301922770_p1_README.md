# Portfolio 1 Database Design and Modelling

# Case study: 
A Bank system where customers deposit, withdraw, and collect loan. Employee checks customer account and  keep records before issuing any transactions.

# Users
Customers  makes transactions and Employee registers customers, maintains account, record transactions  

# Main Operation
Register account, deposit money, withdraw money, issue a loan, record the return loan, customer loan history and overdue loans 


## Business Rule 
- Every employee must have a unique employee ID. 
- Every bank account must have a unique account number.
- An account may have multiple deposits and withdrawals.
- Every customer must have a unique customer ID.
- Every system user must have a unique login identity.
- Access to the database must be restricted according to assigned roles and permissions.
- Customers must only access their own authorized account information.
- Passwords must be stored securely using appropriate password hashing.
- Each deposit must record its date, amount, method, and status.
- Loans must be approved before disbursement.
- A customer may own one or more bank accounts.
- Each customer record must contain valid contact information where required.
- Each employee must have an assigned job title and access privileges appropriate to their responsibilities.
- Each account must have an account type, opening date, and status.
- Each account must be linked to at least one customer.
- Customer information can only be accessed or modified by authorized users.

## Scope Assumption
- Every customer, employee, account, deposit, withdrawal, and loan has a unique identification number.
- Only authorized users can access banking records, and transactions must follow the bank's business rules.
## Design and implementation files

| File | Contents |
| --- | --- |
| [Design](portfolio-1-database-design/owolabi_daniel_301922770_P1_Design.md) | Entities, attributes, keys and relationships. |
| [ER diagram](portfolio-1-database-design/owolabi_daniel_301922770_P1_ERDiagram.md) | The seven tables and  six relationships. |
| [Normalisation](portfolio-1-database-design/owolabi_daniel_301922770_P1_Normalisation.md) | Example tables showing 1NF, 2NF and 3NF. |
| [Schema](portfolio-1-database-design/owolabi_daniel_301922770_P1_Schema.sql) | Table definitions, keys and constraints. |
| [Sample records](portfolio-1-database-design/owolabi_daniel_301922770_P1_SampleData.sql) | Fictional customer,employee,account,transaction,withdrawal,deposit and loans. |
| [Constraint tests](portfolio-1-database-design/owolabi_daniel_301922770_P1_ConstraintTests.sql) | eight Invalid inserts and the final count query. |
| [Evidence](portfolio-1-database-design/owolabi_daniel_301922770_P1_Evidence.md) | Links to the screenshots stored in screenshots/. |


## Implementation
The database runs on PostgreSQL in pgAdmin 4. Its schema creates seven core entities: customer, employee, account, transaction, deposit, withdrawal, and loan. Each table utilizes an automatically generated primary key (SERIAL).

## Test results
All invalid data insertion tests were successfully rejected by their corresponding database constraints and rules: missing required fields (such as full_name), duplicate unique entries (such as email_address or account_number), foreign key violations referencing nonexistent parents, and check constraint violations (such as negative or zero amounts). The screenshots document the resulting error messages.

After executing the validation tests, the database correctly maintained referential integrity, with failed inserts adding zero rows. The final state contains the valid set of customer, employee, account, transaction, deposit, withdrawal, and loan records.

These tests thoroughly cover the defined table constraints, unique keys, check constraints, and partial indexes. More complex cross-table business logic workflows will be addressed and tested in subsequent portfolio modules.
