# Portfolio 4 NoSQL and Advanced Data Models

## Document model

The library_events database contains a borrowing_events collection. Each document records one borrowing or return event. Member and copy details are embedded in the event rather than fetched through a SQL join.

| Field Path | Type |Description
| --- | --- |----|
| id | String  |Unique event identifier (e.g., "EVT-ALAP-110-01")|
| event_type |String |Type of banking activity ("Deposit" or "Loan Disbursement") |
| event_time  | ISODate |Timestamp of the transaction/activity |
|account_number |String |Core test account identifier (ALAP-110, ALAP-120, etc.)|
|customer_details |Object |Embedded document containing customer name and email |
|activity_details  |Object|		Variant sub-document varying by event type (deposit vs. loan specifics) |

## Implementation and results
Four fictional documents are inserted through mongosh into the local MongoDB 8.0.34 server (/workspaces/mongodb-data). The insert operation is acknowledged with four distinct document IDs, and countDocuments({}) successfully returns 4. Querying the event history filtered by account number (account_number: "ALAP-120") and sorted by time returns the specific activity record for Mary Olabisi. Running a nested-field filter ("activity_details.loan_status": "Active") successfully retrieves all active loan disbursement events (ALAP-120 and ALAP-140). These are sample event documents entered separately via script, not an automatic import or live sync from PostgreSQL. The relational PostgreSQL database remains completely unchanged by this NoSQL exercise.

 		

		
		
		
