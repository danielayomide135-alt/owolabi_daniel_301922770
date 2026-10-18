## Identify your entities 

- **Entity:** something the database keeps records of. Example: a Bank customer.
- **Attribute:** a detail about it. Example: the customer's name or email.
- **Primary key (PK):** the ID for one record. Example: customer_id  identifies one member.
- **Foreign key (FK):** an ID linking two tables. Example: customer_id in a loan tells me who borrowed money.
- **Relationship:** how records connect. Example: one customer can have several loans.


| Entity | Information stored |
| --- | --- |
| Employee Data| refers to the details about the bank's employees |
| Customer Data| refers to the information about a person or businesses that use the bank's services |
| Loan Data| Information about loans provided or applied for by customers |
|Withdrawal Data| Records of money withdrawn from bank accounts |
|Deposit Data| Records of money paid into bank accounts |
|Account Data| Information about a customer's registered bank account, including account balance, account type, status, and associated details.|

Account Data and Customer Data are two different things. For example, If a transaction is made the person that make the transaction is a customer and where the transaction happen is on the account

#### Attributes and keys

I use an automatically generated ID for each record. In the tables below, **unique** means no repeated values. **Required** means the value cannot be `NULL` (missing); checking for blank text is a separate rule.

| Entity | Attributes and proposed PostgreSQL types | Keys and required values |
| --- | --- | --- |
| customer | customer_id Serial; name VARCHAR(255); date_of_birth DATE; phone_number VARCHAR(50); email_address VARCHAR(255) | PK: customer_id. Unique: phone_number and email_address, separately. All required. |
| employee | employee_id Serial; name VARCHAR(255); date_of_birth DATE; job_title VARCHAR(50); email_address VARCHAR(255) | PK: employee_id. Unique:  email_address, separately. All required. |
| account | account_id Serial; customer_id INT; employee_id INT;  account_number VARCHAR(50);  account_type VARCHAR(50); date_opened date | PK: customer_id. Unique: phone_number and email_address, separately. All required. |
| transaction | transaction_id Serial; account_id INT; transaction_type VARCHAR(50) ;amount VARCHAR(50); transaction_date date | PK: transaction_id. Unique: account_id, separately. All required. |
|deposit| deposit_id SERIAL; transaction_id INTEGER; deposit_amount NUMERIC; deposit_date DATE; deposit_method VARCHAR(50); deposit_status VARCHAR(50)| PK: deposit_id. Unique: deposit_id, separately .  All required. |     
| Withdrawal | withdrawal_id Serial; tranasaction_id INT; withdrawal_amount VARCHAR(50); withdrawal_date date | PK: withdrawal_id. Unique: tranasaction_id, separately. All required. |
| loan| |loan_id serial; transaction_id INT; loan_amount NUMERIC; interest_rate NUMERIC; loan_term NUMERIC; loan_status VARCHAR(50); application_date DATE |PK: loan_id. Unique: transaction_id, separately. All required. |

`SERIAL` holds auto-incrementing whole numbers. `BIGINT` holds whole numbers, such as IDs. `VARCHAR(225)` holds text up to 120 characters. `DATE`  holds calendar dates.
I leave the account closure date empty until the account is closed. For example, a newly opened account has an opening date and account type, but no closure date yet.

**Design assumption:** Each customer has a unique email address, and each email address appears once in customer.

#### Relationships

| Tables linked | Relationship | Meaning |
| --- | --- | --- |
| customer → account | One to many | A customer record can have zero or more accounts; each account belongs to exactly one customer record. |
|employee → account| One to many |  An employee record can be associated with zero or more accounts; each account is linked to exactly one employee record.|
|account → transaction| One to many over time|   An account can have zero or more historical transactions over time; each transaction refers to exactly one account. |
|transaction → withdrawal| One to one / One to many|   A transaction can be linked to a withdrawal record; each withdrawal record refers to exactly one transaction.| 
|transaction → deposit| One to one / One to many|   A transaction can be linked to a deposit record; each deposit record refers to exactly one transaction. |
|transaction → loan| One to one / One to many|   A transaction can be linked to a loan record; each loan record refers to exactly one transaction. |  

For example: account 105 can have a deposit transaction in May and another laon transaction in June. The system keeps both individual transaction records, but each transaction refers to exactly one account.

### Business rules and constraints
- **Rules 1 and 2:** Customer email addresses and account numbers are unique.   
- **Rules 2 and 3:** Required foreign keys link each account to an existing customer and employee, each transaction to an account, and each withdrawal, deposit, or loan record to a transaction.   
- **Rule 4:** Each transaction record maps cleanly to its respective operational sub-type (withdrawal, deposit, or loan).  
- **Rule 5:** customer_id and account_id can repeat across multiple rows, allowing a customer to maintain multiple accounts and perform various transactions over time.   
- **Rules 6 and 7:** Date checks ensure that transaction dates, deposit dates, and loan application dates follow valid chronological timelines.   
- **Rule 8:** Recording a financial operation requires transaction logic to maintain consistency between the master transaction ledger and the specific sub-type record (withdrawal, deposit, or loan).   

I leave the account closure date empty until the account is closed. For example, a newly opened account has an opening date and account type, but no closure date yet.


