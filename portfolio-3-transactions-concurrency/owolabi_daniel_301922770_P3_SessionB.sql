-- Session B: Try to insert a conflicting Open loan for the same transaction
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;

INSERT INTO public.loan (transaction_id, loan_amount, interest_rate, loan_term, loan_status, application_date)
VALUES (
    (SELECT t.transaction_id FROM public.transaction t JOIN public.account a ON t.account_id = a.account_id WHERE a.account_number = 'ALAP-120' LIMIT 1),
    200.00, 2.00, 6, 'Open', CURRENT_DATE
);

-- Verify final open loan count and details for account ALAP-120
SELECT 
    l.loan_id,
    a.account_number,
    l.loan_amount,
    l.loan_status
FROM public.loan l
JOIN public.transaction t ON l.transaction_id = t.transaction_id
JOIN public.account a ON t.account_id = a.account_id
WHERE a.account_number = 'ALAP-120'
  AND l.loan_status = 'Open';
