# Bank transaction System Normalisation

**Unnormalized Form (UNF)**
In an unnormalized state, a single row contains repeating groups, multiple values per cell, and attributes mixed across domains

|customer_id| customer_name| customer_email| account_number|account_type|employee_name|transactions |
|---|---|---|---|---|---|---|
| 101 | Zita Sarah |zitasarah@example.com |ALAP-110 |Saving |  sodiq Pascal | transaction_id: 5001, Deposit: 1250.00, initiated:02:10:2026 |
| 102 | Mary olabisi | Maryolabisi@example.com |ALAP-120|Checking | Alex rex |transaction_id: 5002, Loan: 550.00 , initiated: 12-10-2026, due: 25-10-2026 |
| 103 | Rose Peace	 | RosePeace@example.com |ALAP-130|Saving | king Kenny | transaction_id:5003, Withdrawal: 10000.00,	Cash, initiated: 01-10-2026 |
| 104 | Peter chidi  | Peterchidi@example.com |ALAP-140 |Saving | bolaji Tom| transaction_id: 5004, Loan: 200.00 , borrowed: 22-10-2026, due: 30-10-2026|

The customer row contains multiple transaction details packed into one cell. Finding one transaction or updating its status is awkward. Customer 101's deposit occurs before any subsequent withdrawals or loans.

## 1NF: One value per cell
Each transaction has its own row. The repeated list is removed.
| account_id | name  | customer_id | email | transaction_id| transaction_type| amount | initiated | 
| --- | --- | --- | --- | --- | ---|--- | --- |
| 101 | Zita Sarah | 20 |zitasarah@example.com| 5001| Deposit| 1250.00|  02:10:2026 | 
| 102	| Mary olabisi | 15 | Maryolabisi@example.com | 5002 | Loan | 550.00 | 12-10-2026| 
| 103 | Rose Peace	 | 30| RosePeace@example.com | 5003| Withdrawal| 10000.00| 01-10-2026 |
| 104 | Peter chidi  | 34| Peterchidi@example.com| 5004| Loan | 200.00 | 22-10-2026|


**2NF includes 1NF. A non-key field must not depend on only part of a combined key.**

|account_id |account_number| customer_id| customer_name|email_address| account_type | employee_id | employee_name | transaction_id | transaction_type | amount  | transaction_date|deposit_method 
|---|---|---|---|---|---|---|---|---|---|---|---|---|
  |101 |ALAP-110 |101 |Zita Sarah |zitasarah@example.com| Saving  |20 |sodiq Pascal	|5001	|Deposit | 1250.00 | 02-10-2026|Cash |       
  |102 |ALAP-120 |102 |Mary olabisi| Maryolabisi@example.com| Checking |	15 | Alex rex	|5002	| Loan | 550.00  |	12-10-2026|NULL |      
  |103 |ALAP-130 |103 | Rose Peace |  RosePeace@example.com| Savings |30 |king Kenny |5003	|Withdrawal	| 10000.00|	 01-10-2026|Cash	     |    
  |104 |ALAP-140 |104 |Peter chidi  | Peterchidi@example.com| Saving |34 |bolaji Tom |5004  |Loan |200.00  | 22-10-2026 |NULL |      

**3. Second Normal Form (2NF):** Remove Partial Dependencies
**To reach 2NF:**
Eliminate partial functional dependencies on the composite key (account_id, transaction_id).
account_number, customer_id, customer_name, email_address, account_type, employee_id, and employee_name depend only on account_id, not on transaction_id.
Extract account-level details into a dedicated table.
**Account Details Table**
Key: account_id
|customer_name|	email_address|account_type|employee_id|	employee_name|
|----|----|----|----|----|
  | Zita Sarah | zitasarah@example.com| Saving|20|sodiq Pascal|
  |Mary olabisi| Maryolabisi@example.com| checking|15| Alex rex|
  | Rose Peace |RosePeace@example.com| Saving|30| king Kenny|
  |Peter chidi  | Peterchidi@example.com|Saving|34| bolaji Tom|

**Transaction Details Table**
**Key:** transaction_id (Foreign Key: account_id)
|transaction_date |	deposit_method |	deposit_status |	interest_rate |	loan_term |	loan_status |
|---|---|---|---|---|---|
| 02-10-2026| Deposit| NULL | 5% | 5| Not-Active
| 12-10-2026| Loan | completed |3% | 12|Active
| 01-10-2026 | Withdrawal|  NULL | 6% |7 |Not Active
| 22-10-2026| Loan | completed |2% | 6 |Active


**4. Third Normal Form (3NF): Remove Transitive Dependencies & Partition Sub-Types**
To reach 3NF: 
**1. Eliminate Transitive Dependencies:** Non-key fields must not depend on other non-key fields.
customer_id determines customer_name and email_address.
employee_id determines employee_name, job_title, and email.

**2. Partition Sub-Types:** Remove sparse NULL fields from the transaction table by creating specialized child tables for withdrawal, deposit, and loan. 

**Final 7 Normalized Entities (3NF)**

**1. customer**
Key: customer_id
|customer_id |name |date_of_birth |phone_number|email_address|
|---|---|---|---|---|
| 101 | Zita Sarah | 01-02-1999 |234-1103-0	|zitasarah@example.com |
| 102 | Mary olabisi | 03-10-1998| 234-1104-01	| Maryolabisi@example.com |
| 103 | Rose Peace	 | 04-11-1995 |234-1105-02	|RosePeace@example.com |
| 104 | Peter chidi  | 05-06-1994 |234-1106-03	| Peter chidi@example.com |

## 2. employee ##
Key: employee_id
|employee_id |name |job_title |email |
| --- | --- |---|---|
| 20 | sodiq Pascal | Account Officer | sodiqPascal@example.com|
| 15 | Alex rex	 | Loan Manager | Alexrex@example.com	
| 30 | king Kenny | Account Officer |kingKenny@example.com
| 34 | bolaji Tom | Loan Manager | bolajiTom@example.com

## 3. account ##
Key: account_id (Foreign Keys: customer_id, employee_id)
|account_id |customer_id |employee_id |account_number |account_type |date_opened|
|---|---|---|---|---|---|
| 101 |220 |20 |ALAP-110 |Saving |10-02-2026 |
| 102	|215 |15 |ALAP-120 |Checking |20-03-2026|
| 103	|230 |30 |ALAP-130 |Saving |22-03-2026|
| 104 |234 |34 |ALAP-140 |Saving |19-05-2026|



## 4. transaction ##
Key: transaction_id (Foreign Key: account_id)
|transaction_id |account_id |transaction_type |amount |transaction_date|
|---|---|---|---|---|
|5001 |101 |Deposit| 1250.00| 02-10-2026|
|5002 |102 |Loan | 550.00 | 12-10-2026| 
|5003|103 | Withdrawal| 10000.00| 01-10-2026 |
|5004 |104 |Loan | 200.00 | 22-10-2026|


## 5. withdrawal ##
   Key: withdrawal_id (Foreign Key: transaction_id)
|withdrawal_id |transaction_id |withdrawal_amount |withdrawal_date|
|---|---|---|---|
|32| 5003| 1000.00| 01-10-2026|

## 6. deposit ##
Key: deposit_id (Foreign Key: transaction_id)
|deposit_id |transaction_id | deposit_amount | deposit_date | deposit_method| deposit_status|
|---|---|---|---|---|---|
  |12 |5001 |1250.00 | 02:10:2026 | cash| completed|

## 7. loan ##
Key: loan_id (Foreign Key: transaction_id)
|loan_id | transaction_id |loan_amount | interest_rate | loan_term | loan_status| application_date|
|---|---|---|---|---|---|---|
| 25 | 5002| 550.00| 3% | 12 |Active | 12-10-2026
| 54 |5004| 200.00 | 2% | 6  | Active| 22-10-2026


