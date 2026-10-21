# Portfolio 3 Transactions and Concurrency

## Commit and rollback

The loan status update for account ALAP-120 is committed with a status of Closed. A repeated update affects zero rows because the conditional UPDATE restricts changes strictly to currently active loans. In the next transaction, a valid loan insert for account ALAP-140 is tested before an invalid constraint violation triggers a rollback. ROLLBACK removes that uncommitted insert; the earlier committed status change remains.

## Isolation and concurrency control
Two PostgreSQL sessions use READ COMMITTED isolation. Session A inserts an Open loan for account ALAP-120 without committing. Session B checks for open loans, attempts a conflicting insert, and blocks (wait_event_type = Lock). After Session A commits, Session B receives a unique constraint violation error (idx_open_loan_unique). Session B rolls back, and the final verification query confirms exactly one open loan record exists for ALAP-120, belonging to Session A.

## Conclusion

COMMIT saves transaction changes permanently, while ROLLBACK discards uncommitted modifications. READ COMMITTED isolation hides uncommitted records from concurrent connections. The partial unique index (idx_open_loan_unique) successfully prevents duplicate active loans even when initial availability checks find no conflicts. These transactions modify live bank records, while Portfolio 2 benchmark tables remain entirely isolated.

## Files

- [Commit and rollback SQL](owolabi_daniel_301922770_P3_Transactions.sql)
- [Session A SQL](owolabi_daniel_301922770_P3_SessionA.sql)
- [Session B SQL](owolabi_daniel_301922770_P3_SessionB.sql)
- [Screenshots](/screenshot): CommitRollback, Sessions A, Session B and ConcurrencyResult.
