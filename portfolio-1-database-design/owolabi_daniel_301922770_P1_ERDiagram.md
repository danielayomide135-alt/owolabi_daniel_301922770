# Library Banking System ER Diagram

This diagram shows the seven tables, their fields and how they connect.
```mermaid
erDiagram
    direction LR
    customer ||--o{ account : opens
    employee ||--o{ account : manages
    account ||--o{ transaction : has
    transaction ||--o{ deposit : includes
    transaction ||--o{ withdrawal : includes
    transaction ||--o{ loan : includes

    customer {
        serial customer_id PK
        varchar full_name
        date date_of_birth
        varchar phone_number
        varchar email_address UK
    }
    employee {
        serial employee_id PK
        varchar full_name
        varchar job_title
        varchar email UK
    }
    account {
        serial account_id PK
        integer customer_id FK
        integer employee_id FK
        varchar account_number UK
        varchar account_type
        date date_opened
    }
    transaction {
        serial transaction_id PK
        integer account_id FK
        varchar transaction_type
        numeric amount
        date transaction_date
    }
    deposit {
        serial deposit_id PK
        integer transaction_id FK
        numeric deposit_amount
        date deposit_date
        varchar deposit_method
        varchar deposit_status
    }
    withdrawal {
        serial withdrawal_id PK
        integer transaction_id FK
        numeric withdrawal_amount
        date withdrawal_date
    }
    loan {
        serial loan_id PK
        integer transaction_id FK
        numeric loan_amount
        numeric interest_rate
        integer loan_term
        varchar loan_status
        date application_date
    }
