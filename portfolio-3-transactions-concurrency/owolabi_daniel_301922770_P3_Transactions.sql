-- Check initial loan statuses and linked transactions
SELECT 
    l.loan_id,
    a.account_number,
    l.loan_amount,
    l.loan_status,
    l.application_date
FROM public.loan l
JOIN public.transaction t ON l.transaction_id = t.transaction_id
JOIN public.account a ON t.account_id = a.account_id;

-- Begin transaction to update loan status
BEGIN;

UPDATE public.loan l
SET loan_status = 'Closed'
FROM public.transaction t
JOIN public.account a ON t.account_id = a.account_id
WHERE l.transaction_id = t.transaction_id
  AND a.account_number = 'ALAP-120'
  AND l.loan_status = 'Active';

COMMIT;

-- Repeat check to verify idempotency (affects 0 rows because status is already Closed)
UPDATE public.loan l
SET loan_status = 'Closed'
FROM public.transaction t
JOIN public.account a ON t.account_id = a.account_id
WHERE l.transaction_id = t.transaction_id
  AND a.account_number = 'ALAP-120'
  AND l.loan_status = 'Active';

-- Begin transaction with a valid insert followed by a deliberate unique constraint violation
BEGIN;

-- 1. Valid insert for account ALAP-140 (using an existing transaction_id or new valid reference)
INSERT INTO public.loan (transaction_id, loan_amount, interest_rate, loan_term, loan_status, application_date)
VALUES (
    (SELECT t.transaction_id FROM public.transaction t JOIN public.account a ON t.account_id = a.account_id WHERE a.account_number = 'ALAP-140' LIMIT 1),
    300.00, 2.50, 6, 'Open', '2026-10-23'
);

-- 2. Deliberate violation: Attempting to insert a second 'Open' loan for the exact same transaction_id (violates idx_open_loan_unique)
INSERT INTO public.loan (transaction_id, loan_amount, interest_rate, loan_term, loan_status, application_date)
VALUES (
    (SELECT t.transaction_id FROM public.transaction t JOIN public.account a ON t.account_id = a.account_id WHERE a.account_number = 'ALAP-140' LIMIT 1),
    150.00, 1.50, 3, 'Open', '2026-10-23'
);

ROLLBACK;

-- Verify final database state after commit and rollback
SELECT 
    l.loan_id,
    a.account_number,
    l.loan_amount,
    l.loan_status
FROM public.loan l
JOIN public.transaction t ON l.transaction_id = t.transaction_id
JOIN public.account a ON t.account_id = a.account_id;
