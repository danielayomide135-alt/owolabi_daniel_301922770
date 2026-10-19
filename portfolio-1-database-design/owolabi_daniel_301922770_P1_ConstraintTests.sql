-- Test 1: Required Field Constraint (NOT NULL) on customer name
-- Expected Error: ERROR: null value in column "name" of relation "customer" violates not-null constraint

INSERT INTO customer (full_name, date_of_birth, phone_number, email_address) 
VALUES (NULL, '01-02-1999', '234-1103-0', 'zitasarah@example.com'),
	  ('Mary olabisi', '03-10-1998', '234-1104-01', 'Maryolabisi@example.com'),
	  (NULL, '04-11-1995', '234-1105-02', 'RosePeace@example.com'),
	 ('Peter chidi', '04-11-1995', '234-1106-03', 'Peterchidi@example.com');

-- Test 2: Unique Constraint violation on customer email address
-- Expected Error: ERROR: duplicate key value violates unique constraint ...

INSERT INTO customer (full_name, date_of_birth, phone_number, email_address) 
VALUES ('Zita Sarah', '01-02-1999', '234-1103-0', 'zitasarah@example.com'),
	  ('Mary olabisi', '03-10-1998', '234-1104-01', 'Maryolabisi@example.com'),
	  ('Rose Peace', '04-11-1995', '234-1105-02', 'RosePeace@example.com'),
	 ('Peter chidi', '04-11-1995', '234-1106-03', 'Peterchidi@example.com');

-- Test 3: Required Field Constraint (NOT NULL) on employee email
-- Expected Error: ERROR: null value in column "email" of relation "employee" violates not-null constraint

INSERT INTO employee (full_name, job_title, email) 
VALUES ('sodiq Pascal', 'Account Officer', NULL),
	('Alex rex', 'Loan Manager', 'Alexrex@example.com'),
	('king Kenny', 'Account Officer', NULL),
		('Bolaji Tom', 'Loan Manager', 'bolajitom@example.com');

-- Test 4: Foreign Key Constraint violation on account (invalid customer_id)
-- Expected Error: ERROR: insert or update on table "account" violates foreign key constraint ...

INSERT INTO account (customer_id, employee_id, account_number, account_type, date_opened) 
VALUES (
	10000,
    (SELECT employee_id FROM employee WHERE email = 'sodiqpascal@example.com'),
    'ALAP-110f','Savings','2026-02-10'),
(
	200000,
	(SELECT employee_id FROM employee WHERE email = 'Alexrex@example.com'),
	'ALAP-120s','Checking','2026-03-2'
),
(
	30000,
	(SELECT employee_id FROM employee WHERE email = 'KingKenny@example.com'),
	'ALAP-130a','Savings','2026-03-22'
),
(
	25000,
	(SELECT employee_id FROM employee WHERE email = 'bolajiTom@example.com'),
  	'ALAP-140s','Savings','2026-05-19'
)

-- Test 5: Unique Constraint violation on account number
-- Expected Error: ERROR: duplicate key value violates unique constraint ...

INSERT INTO account (customer_id, employee_id, account_number, account_type, date_opened) 
VALUES (
    (SELECT customer_id FROM customer WHERE email_address = 'zitasarah@example.com'),
    (SELECT employee_id FROM employee WHERE email = 'sodiqpascal@example.com'),
    'ALAP-110','Savings','2026-02-10'),
(
    (SELECT customer_id FROM customer WHERE email_address = 'Maryolabisi@example.com'),
    (SELECT employee_id FROM employee WHERE email = 'Alexrex@example.com'),
	'ALAP-120','Checking','2026-03-2'
),
(
    (SELECT customer_id FROM customer WHERE email_address = 'RosePeace@example.com'),
    (SELECT employee_id FROM employee WHERE email = 'KingKenny@example.com'),
	'ALAP-130','Savings','2026-03-22'
),
(
    (SELECT customer_id FROM customer WHERE email_address = 'Peterchidi@example.com'),
    (SELECT employee_id FROM employee WHERE email = 'bolajiTom@example.com'),
  	'ALAP-140','Savings','2026-05-19'
)
-- Test 6: Foreign Key Constraint violation on transaction (invalid account_id)
-- Expected Error: ERROR: insert or update on table "transaction" violates foreign key constraint ...

INSERT INTO transaction (account_id, transaction_type, amount, transaction_date) 
VALUES (
		 10000 ,'Deposit',1250.00,'2026-10-02'
),

(
 	  20000, 'Loan',550.00,'2026-10-12'
),
(
    23000,'Withdrawal',10000.00,'2026-10-01'
),
(
    21000,'Loan',200.00,'2026-10-22'
);

-- Test 7: Foreign Key Constraint violation on deposit (invalid transaction_id)
-- Expected Error: ERROR: insert or update on table "deposit" violates foreign key constraint ...

INSERT INTO deposit (transaction_id, deposit_amount, deposit_date, deposit_method, deposit_status) 
VALUES (
	10000,
	50000.00,
    '2026-03-01',
    'Bank Transfer',
    'Completed'
);
-- Test 8: Foreign Key Constraint violation on withdrawal (invalid transaction_id)
-- Expected Error: ERROR: insert or update on table "withdrawal" violates foreign key constraint ...

INSERT INTO withdrawal (transaction_id, withdrawal_amount, withdrawal_date) 
VALUES (
	90000,
	15000.00,
    '2026-10-01'
);



SELECT 'customer' AS table_name, count(*) AS row_count FROM public.customer
UNION ALL 
SELECT 'employee', count(*) FROM public.employee
UNION ALL 
SELECT 'account', count(*) FROM public.account
UNION ALL 
SELECT 'transaction', count(*) FROM public.transaction
UNION ALL 
SELECT 'deposit', count(*) FROM public.deposit
UNION ALL 
SELECT 'withdrawal', count(*) FROM public.withdrawal
UNION ALL 
SELECT 'loan', count(*) FROM public.loan;
