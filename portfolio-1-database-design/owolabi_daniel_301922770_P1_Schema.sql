-- Create customer table
BEGIN;
CREATE TABLE public.customer (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    phone_number VARCHAR(50),
    email_address VARCHAR(255) UNIQUE NOT NULL
);
-- Create employee table
CREATE TABLE public.employee (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    job_title VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Create account table
CREATE TABLE public.account (
    account_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES public.customer(customer_id),
    employee_id INTEGER REFERENCES public.employee(employee_id),
    account_number VARCHAR(50) UNIQUE NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    date_opened DATE NOT NULL
);

-- Create transaction table
CREATE TABLE public.transaction (
    transaction_id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES public.account(account_id),
    transaction_type VARCHAR(50) NOT NULL,
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
    transaction_date DATE NOT NULL
);

-- Create withdrawal table
CREATE TABLE public.withdrawal (
    withdrawal_id SERIAL PRIMARY KEY,
    transaction_id INTEGER NOT NULL REFERENCES public.transaction(transaction_id),
    withdrawal_amount NUMERIC(18,2) NOT NULL CHECK (withdrawal_amount > 0),
    withdrawal_date DATE NOT NULL
);

-- Create deposit table
CREATE TABLE public.deposit (
    deposit_id SERIAL PRIMARY KEY,
    transaction_id INTEGER NOT NULL REFERENCES public.transaction(transaction_id),
    deposit_amount NUMERIC(18,2) NOT NULL CHECK (deposit_amount > 0),
    deposit_date DATE NOT NULL,
    deposit_method VARCHAR(50),
    deposit_status VARCHAR(50) NOT NULL
);

-- Create loan table
-- Note: Complex business logic and cross-table validation rules requiring transaction logic are not fully enforced by table constraints alone.
CREATE TABLE public.loan (
    loan_id SERIAL PRIMARY KEY,
    transaction_id INTEGER NOT NULL REFERENCES public.transaction(transaction_id),
    loan_amount NUMERIC(18,2) NOT NULL CHECK (loan_amount > 0),
    interest_rate NUMERIC(5,2) NOT NULL CHECK (interest_rate >= 0),
    loan_term INTEGER NOT NULL CHECK (loan_term > 0),
    loan_status VARCHAR(50) NOT NULL,
    application_date DATE NOT NULL
);

-- Partial unique index example for open loans as required by business rules
CREATE UNIQUE INDEX idx_open_loan_unique ON public.loan (transaction_id) WHERE loan_status = 'Open';

COMMIT;
