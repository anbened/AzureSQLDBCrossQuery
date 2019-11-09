# AzureSQLDBCrossQuery

An Azure SQL Database as no way to access immediately to another database, even if created on the same virtual server. 
While the databases on a server share a MASTER database, with associated logins, there was no way to access one db from another.

In the scripts you can see how to set up an external table in one db that can be used to query data in another db.

For this guide to work, you need two Azure SQL Databases in the same virtual server

In short what the scripts do:

- Create a login and on the destination server/database
- Create a master key in the source database
- Create a database scoped credential in the source database
- Create an external data source in the source database
- Create an external table in the source database
- Querying
