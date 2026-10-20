-- 1. Create a dedicated isolated schema to keep Portfolio 1 records unchanged
CREATE SCHEMA IF NOT EXISTS p2_benchmark;

-- 2. Create synthetic transaction history table for volume testing
CREATE TABLE p2_benchmark.synthetic_transaction_history (
    history_id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES public.account(account_id),
    transaction_type VARCHAR(50) NOT NULL,
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    transaction_date DATE NOT NULL
);

-- 3. Populate 100,000 plausible records spread over a 2-year range using actual account_ids
INSERT INTO p2_benchmark.synthetic_transaction_history (account_id, transaction_type, amount, transaction_date)
SELECT 
    a.account_id,
    (ARRAY['Deposit', 'Withdrawal', 'Loan Payment', 'Transfer'])[FLOOR(RANDOM() * 4 + 1)],
    ROUND((RANDOM() * 5000 + 10)::numeric, 2),
    '2025-01-01'::DATE + (RANDOM() * 730)::INT
FROM GENERATE_SERIES(1, 100000) g
CROSS JOIN LATERAL (
    SELECT account_id FROM public.account ORDER BY RANDOM() LIMIT 1
) a;

-- 4. Update table statistics so PostgreSQL query planner has accurate row estimations
ANALYZE p2_benchmark.synthetic_transaction_history;

-- 5. Verify the total generated row count
SELECT COUNT(*) AS total_synthetic_rows 
FROM p2_benchmark.synthetic_transaction_history;

-- Execute baseline execution plan analysis before creating custom indexes
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    history_id,
    account_id,
    transaction_type,
    amount,
    transaction_date
FROM p2_benchmark.synthetic_transaction_history
WHERE transaction_date BETWEEN '2026-03-01' AND '2026-03-07'
ORDER BY transaction_date ASC;

-- Create a targeted B-Tree index on the transaction_date column to optimize range scans
CREATE INDEX idx_synth_trans_date 
ON p2_benchmark.synthetic_transaction_history (transaction_date);

-- Execute identical benchmark query to evaluate performance improvement with the B-Tree index
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    history_id,
    account_id,
    transaction_type,
    amount,
    transaction_date
FROM p2_benchmark.synthetic_transaction_history
WHERE transaction_date BETWEEN '2026-03-01' AND '2026-03-07'
ORDER BY transaction_date ASC;
