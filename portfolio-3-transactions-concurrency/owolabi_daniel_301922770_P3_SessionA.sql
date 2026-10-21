-- Check existing transaction and loan status for account ALAP-120
SELECT 
    t.transaction_id,
    a.account_number,
    t.transaction_type,
    l.loan_status
FROM public.transaction t
JOIN public.account a ON t.account_id = a.account_id
LEFT JOIN public.loan l ON t.transaction_id = l.transaction_id
WHERE a.account_number = 'ALAP-120';

-- Session A: Begin transaction and insert an Open loan
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;

INSERT INTO public.loan (transaction_id, loan_amount, interest_rate, loan_term, loan_status, application_date)
VALUES (
    (SELECT t.transaction_id FROM public.transaction t JOIN public.account a ON t.account_id = a.account_id WHERE a.account_number = 'ALAP-120' LIMIT 1),
    450.00, 3.50, 12, 'Open', CURRENT_DATE
);

