# Portfolio 2 Query Processing and Optimisation

## Queries and results
The portfolio exercises implement core relational queries and reporting logic for the bank and fintech platform case study:
- **Active Account Details:** Retrieves customer full names, account numbers, transaction types, amounts, and dates ordered by transaction date and account number.
- **Accounts Without Loans:** Uses a NOT EXISTS clause to accurately isolate accounts that do not have any associated loan transaction records.
- **Employee Portfolio Count:** Employs a LEFT JOIN combined with aggregation (GROUP BY) to list all employees and the total number of accounts managed, including staff members with zero assigned accounts.

## Index comparison
To evaluate query optimization without affecting core operational records, a dedicated isolated schema (p2_benchmark) and a synthetic table (synthetic_transaction_history) containing 100,000 generated records were established. A targeted date range query filtering records between '2026-03-01' and '2026-03-07' was benchmarked before and after applying a custom B-tree index on the transaction_date column (idx_synth_trans_date)

| Metric / Phase | Before Indexing | After indexing |
| --- | --- | --- |
| Scan type | Seq Scan/sort | ort / Index Optimization   |
| Run 1 Time |58.791 ms |5.959 ms |
| Run 2 Time | 58.850 ms |6.012 ms|
|Run 3 Time | 58.952 ms | 6.252 ms |
|Median Time | 58.850 ms | 6.012 ms |
|Top-Level Buffer Hits (Run 3) | 736 shared hits |520 shared hits, 3 read |

## Performance analysis
Before indexing, the query execution plan relied on a full sequential scan and sort operation, requiring PostgreSQL to inspect all data pages across the 100,000-row table and generating 736 shared buffer hits. After creating the B-tree index on transaction_date, the execution plan shifted to utilize the index, lowering median execution times and reducing shared buffer hits to 520 on the third measured run. However, while indexing accelerates selective range filtering and read performance, it does not guarantee universally faster execution for all queries (such as wide table scans) and introduces ongoing storage overhead and write latency during INSERT, UPDATE, and DELETE operations because index structures must be maintained concurrently. Measured timings are also subject to hardware caching limits and system load variations.

