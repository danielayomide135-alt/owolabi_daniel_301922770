// Switch to your NoSQL database
use bank_fintech_nosql;

// Clear existing test documents if re-running
db.customers.deleteMany({});

// Insert all 4 customer and account records
db.customers.insertMany([
  {
    customer_id: 1,
    full_name: "Zita Sarah",
    email_address: "zitasarah@example.com",
    accounts: [
      { account_number: "ALAP-110", account_type: "Savings", status: "Active" }
    ]
  },
  {
    customer_id: 2,
    full_name: "Mary Olabisi",
    email_address: "maryolabisi@example.com",
    accounts: [
      { account_number: "ALAP-120", account_type: "Checking", status: "Active" }
    ]
  },
  {
    customer_id: 3,
    full_name: "Rose Peace",
    email_address: "rosepeace@example.com",
    accounts: [
      { account_number: "ALAP-130", account_type: "Savings", status: "Active" }
    ]
  },
  {
    customer_id: 4,
    full_name: "Peter Chidi",
    email_address: "peterchidi@example.com",
    accounts: [
      { account_number: "ALAP-140", account_type: "Savings", status: "Active" }
    ]
  }
]);

// Verify all 4 documents are successfully inserted
db.customers.find().pretty();
