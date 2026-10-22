## MIT 8103 Advanced Database Systems: Portfolio Summary

Case-Study Name: Bank and Fintech Platform 

Name: Daniel Owolabi

Student ID: 301922770

Repository: https://github.com/danielayomide135-alt/owolabi_daniel_301922770

## Case study
The core case study models a banking and fintech platform supporting customer registration, employee account management, deposits, withdrawals, loan disbursements, and loan tracking across four primary test records (ALAP-110, ALAP-120, ALAP-130, ALAP-140). This scenario bridges relational structured data integrity with flexible NoSQL document storage and distributed system concepts across five comprehensive portfolio modules.

## Portfolio 1: Database Design and Modelling
- **Summary of Work:** Designed and implemented a normalized relational schema comprising seven core tables (customer, employee, account, transaction, deposit, withdrawal, and loan) in PostgreSQL via pgAdmin 4. Enforced business rules through primary keys, foreign key constraints, check constraints, and a partial unique index (idx_open_loan_unique) for active loans.
- **Verified Result & Meaning:** All eight invalid data insertion tests were successfully rejected by the database engine (e.g., duplicate unique keys, negative amounts, missing required attributes). Referential integrity was fully preserved, confirming that schema-level constraints robustly protect foundational financial data before application-level validation occurs.

## Portfolio 2: Query Processing and Optimisation
- **Summary of Work:** Examined query execution plans (EXPLAIN ANALYZE) and performance optimization strategies using synthetic transactional workloads. Implemented B-tree indexing on date and identifier attributes to transition the query optimizer from costly sequential scans to efficient index scans.
*-*Verified Result & Meaning:** Indexing high-cardinality search columns dramatically reduced query execution time and buffer reads on large datasets.

## Portfolio 3: Transactions and Concurrency
- **Summary of Work:** Demonstrated ACID transaction management, explicit locking, and concurrency control using PostgreSQL transaction blocks (BEGIN, COMMIT, ROLLBACK). Tested concurrent updates against targeted accounts (ALAP-120 and ALAP-140) to evaluate isolation levels and constraint violation handling.
- **Verified Result & Meaning:** Transactions executed successfully when adhering to business logic constraints, while conflicting operations or constraint violations (such as duplicate open loans) triggered automatic rollbacks, ensuring zero database corruption or partial state persistence.

## Portfolio 4: NoSQL and Advanced Data Models
- **Summary of Work:** Implemented a document-oriented database model in MongoDB 8.0.34 (bank_fintech_nosql database, customer_events collection) representing banking activities and customer snapshots for the four core test entities.
- **Verified Result & Meaning:** Inserted four distinct event documents and verified structure via mongosh. Queries successfully retrieved total document counts, sorted account event histories (e.g., for ALAP-120), and filtered nested fields (activity_details.loan_status). This demonstrated how document models support flexible, self-contained event logging without rigid table joins.

## Portfolio 5: Distributed and Cloud Database Exercise
- **Summary of Work:** Formulated a distributed database architecture for the banking platform, outlining a proposed 3-node MongoDB replica set topology, failure/consistency models, and sharding/cloud deployment strategies
- **Verified Result & Meaning:** Design-only exercise (no multi-node cluster deployed locally). Outlined how primary/secondary election protocols, majority write concern (w: "majority"), and network partitioning safeguards ensure high availability, while distinguishing distributed replication from SQL database synchronization.

## Evidence
All source files, SQL scripts, MongoDB migration files, and execution screenshots are permanently archived in the official repository:
- **Repository URL:** https://github.com/danielayomide135-alt/owolabi_daniel_301922770

## Individual reflection
- **Design choice:** Choosing a partial unique index (idx_open_loan_unique WHERE loan_status = 'Open') rather than a full table unique constraint ensured that customers could successfully hold multiple historical loans over time while strictly preventing concurrent overlapping open loans on the same account.
- **Difficulty:** Balancing strict referential relational constraints in PostgreSQL with the flexible schema-less nesting of MongoDB required careful adjustment when mapping financial entities across different data paradigms.
- **Action:** Reviewed official documentation for both database engines and mapped entity relationships explicitly before writing DDL and document insertion scripts.
- **Lesson:** Database selection must be driven by workload requirements; relational databases excel at enforcing strict financial consistency, whereas document stores provide excellent flexibility for event-driven logging and audit trails.

## AI-use declaration
- **Tools:** AI collaborator (Gemini) utilized for structural guidance, markdown formatting assistance, and technical troubleshooting support.
