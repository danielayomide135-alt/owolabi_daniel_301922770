- Retrieve active account details along with their corresponding transaction types and amounts, ordered by transaction date
SELECT 
    c.full_name AS customer_name,
    a.account_number,
    t.transaction_type,
    t.amount,
    t.transaction_date
FROM public.customer c
JOIN public.account a ON c.customer_id = a.customer_id
JOIN public.transaction t ON a.account_id = t.account_id
ORDER BY t.transaction_date ASC, a.account_number;

-- Identify accounts that do not currently have any associated loan transaction records
SELECT 
    a.account_number,
    a.account_type,
    c.full_name
FROM public.account a
JOIN public.customer c ON a.customer_id = c.customer_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM public.transaction t 
    WHERE t.account_id = a.account_id 
      AND t.transaction_type ILIKE '%loan%'
);

-- Count the total number of accounts managed by each employee, including employees with zero accounts using a left join
SELECT 
    e.full_name AS employee_name,
    e.job_title,
    COUNT(a.account_id) AS total_accounts_managed
FROM public.employee e
LEFT JOIN public.account a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.full_name, e.job_title
ORDER BY total_accounts_managed DESC, e.full_name;
