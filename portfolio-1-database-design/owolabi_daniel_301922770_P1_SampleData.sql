-- 1. Insert valid customers
INSERT INTO customer (full_name, date_of_birth, phone_number, email_address) 
VALUES ('Zita Sarah', '01-02-1999', '234-1103-0', 'zitasarah@example.com'),
	  ('Mary olabisi', '03-10-1998', '234-1104-01', 'Maryolabisi@example.com'),
	  ('Rose Peace', '04-11-1995', '234-1105-02', 'RosePeace@example.com'),
	 ('Peter chidi', '04-11-1995', '234-1106-03', 'Peterchidi@example.com');

-- 2. Insert valid employees
INSERT INTO employee (full_name, job_title, email) 
VALUES ('sodiq Pascal', 'Account Officer', 'sodiqpascal@example.com'),
	('Alex rex', 'Loan Manager', 'Alexrex@example.com'),
	('king Kenny', 'Account Officer', 'kingKenny@example.com'),
		('Bolaji Tom', 'Loan Manager', 'bolajitom@example.com');


-- 3. Insert valid accounts (looking up parent customer and employee IDs)

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
-- 4. Insert valid transactions (looking up parent account IDs)
INSERT INTO transaction (account_id, transaction_type, amount, transaction_date) 
VALUES (
    (SELECT account_id FROM account WHERE account_number = 'ALAP-110'),
    'Deposit',1250.00,'2026-10-02'
),

(
    (SELECT account_id FROM account WHERE account_number = 'ALAP-120'),
    'Loan',550.00,'2026-10-12'
),
(
    (SELECT account_id FROM account WHERE account_number = 'ALAP-130'),
    'Withdrawal',10000.00,'2026-10-01'
),
(
    (SELECT account_id FROM account WHERE account_number = 'ALAP-140'),
    'Loan',200.00,'2026-10-22'
);
-- 5. Insert valid deposit records (linking to deposit transaction)
INSERT INTO deposit (transaction_id, deposit_amount, deposit_date, deposit_method, deposit_status) 
VALUES (
    (SELECT t.transaction_id FROM transaction t JOIN account a ON t.account_id = a.account_id WHERE a.account_number = 'ALAP-110' AND t.transaction_type = 'Deposit'),
    50000.00,
    '2026-03-01',
    'Bank Transfer',
    'Completed'
);

-- 6. Insert valid withdrawal records (linking to withdrawal transaction)
INSERT INTO withdrawal (transaction_id, withdrawal_amount, withdrawal_date) 
VALUES (
    (SELECT t.transaction_id FROM transaction t JOIN account a ON t.account_id = a.account_id WHERE a.account_number = 'ALAP-130' AND t.transaction_type = 'Withdrawal'),
    15000.00,
    '2026-10-01'
);
-- 7. Insert valid loan records
INSERT INTO loan (transaction_id, loan_amount, interest_rate, loan_term, loan_status, application_date) 
VALUES 
(
    (SELECT t.transaction_id FROM transaction t JOIN account a ON t.account_id = a.account_id WHERE a.account_number = 'ALAP-120' AND t.transaction_type = 'Loan Disbursement'),
    550.00, 3.00, 12, 'Active', '2026-10-12'
),
(
    (SELECT t.transaction_id FROM transaction t JOIN account a ON t.account_id = a.account_id WHERE a.account_number = 'ALAP-140' AND t.transaction_type = 'Loan Disbursement'),
    200.00, 2.00, 6, 'Active', '2026-10-22'
);



