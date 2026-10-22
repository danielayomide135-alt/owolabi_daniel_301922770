# Portfolio 5 Distributed and Cloud Database Exercise

## Current setup
The current setup consists of a single-node local MongoDB 8.0.34 instance running in an Ubuntu Codespace (/workspaces/mongodb-data) on 127.0.0.1:27017, alongside a PostgreSQL relational database. Multi-node replication, automatic failover, and cloud distribution are not implemented in this local development environment.

## Proposed replication
To provide high availability and fault tolerance for the banking event collection, a 3-member MongoDB replica set could be deployed across three separate cloud availability zones or virtual hosts.


| Member | Starting role | Location |
| --- | --- | --- |
|mongo-node-01  | Primary | Availability Zone A (Data & Writes) |
|mongo-node-02 | Secondary |Availability Zone B (Data & Failover Vote) |
|mongo-node-03  | Secondary | Availability Zone C (Data & Failover Vote) |

 ## Failure and consistency
If the primary node fails, the remaining secondary nodes detect the loss of heartbeat and initiate an automated election based on priority and term MongoDB Replica Set Elections. During the brief election window, write operations are temporarily interrupted until a new primary is elected. If fewer than a majority of voting members remain reachable, the replica set becomes read-only to prevent split-brain anomalies. Using write concern majority ensures client writes are acknowledged only after being committed to a majority of replica set members, balancing durability against potential secondary replication lag MongoDB Write Concern Reference. Operational transactional controls remain handled by the authoritative PostgreSQL database.

 ## Sharding and cloud deployment 
Sharding distributes data across multiple independent database instances by partitioning records using a shard key, which differs from replication that copies identical datasets across nodes. Given the small scale of this portfolio case study, sharding is unnecessary and would introduce unwarranted network overhead.

For a production cloud deployment, security must be enforced via SCRAM or x.509 authentication, Transport Layer Security (TLS/SSL) encryption in transit, encryption at rest, and Virtual Private Cloud (VPC) network access restrictions. Operational maintenance requires automated backup and point-in-time restore policies MongoDB Atlas Backup and Restore, which incur cloud infrastructure costs. Crucially, configuring MongoDB replication scales and secures only the NoSQL layer; it does not replicate PostgreSQL or automatically synchronize data between the two distinct database engines MongoDB Sharding Documentation.



