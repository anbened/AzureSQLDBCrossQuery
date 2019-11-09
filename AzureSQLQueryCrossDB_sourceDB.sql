
/* sourceDB */

/* 
STEP 1 
Create a SQL Login in the logical server's master database 
*/
--> ESEGUIRE IN MASTER DATABASE
CREATE LOGIN RemoteLogger WITH PASSWORD='123!#StrongPassword';

/*
STEP 3
Create a Master Key in the Origin Database (Use OriginDB)
We now need to create a new Master Key in our sourceDB.
*/
--> ESEGUIRE IN sourceDB DATABASE
CREATE MASTER KEY ENCRYPTION BY PASSWORD='Credentials123!'

/*
STEP 4
Create a Database Scoped Credential in the source database
We need to create a database scoped credential 
that has the user and password for the login we created in RemoteDB

IDENTITY: It's the user that we created in destinationDB from the RemoteLogger SQL Login.
SECRET: It's the password you assigned the SQL Login when you created it.
*/
CREATE DATABASE SCOPED CREDENTIAL AppCredential 
WITH IDENTITY = 'RemoteLogger', SECRET='123!#StrongPassword';

/*
STEP 5
Creating the external data source for sourceDB database
Now we will be creating the remote data source reference. 
This reference will define where to look for the remote database, 
being it in the same server as OriginDB or in another server. 
The remote data source for this example will be called "RemoteDatabase".


TYPE: for this example and for any Azure SQL Database, 
	we will need to specify that it is a RDBMS engine, 
	being RDBMS a Relational Database Management System.
LOCATION: the location will let the external data source to know where to look. 
	In location we will put our logical server's FQDN or servername. 
	For example server.database.windows.net.
DATABASE_NAME: we need to specify which database we will 
	be pointing to in the external data source.
CREDENTIAL: we need to map the correct Credential, 
	which in this case is the one we previously 
	created as a DATABASE SCOPE CREDENTIAL in step 4.
*/
CREATE EXTERNAL DATA SOURCE dataSource_destinationDB
WITH
(
	TYPE=RDBMS,
	LOCATION='anbened.database.windows.net', -- Change the servername for your server name.
	DATABASE_NAME='destinationDB',
	CREDENTIAL= AppCredential
);

/*
STEP 6
Create the external table in the sourceDB database
Create a mapping table in sourceDB that references 
the fields in destinationDB for table TestTable

DATA_SOURCE: here we are referencing the data source 
	that we created in step 0
	This data source will let the database know 
	where to go and look for data. 
	Also we referenced a CREDENTIAL, this credential was created 
	and there we reference the IDENTITY and SECRET, which are the user 
	and the password that the remote call will be using 
	to authenticate to destinationDB and obtain the requested 
	data in the external table (remote table)
*/
CREATE EXTERNAL TABLE TestTable
(
	ID INT,
	NAME VARCHAR(20) NOT NULL,
	LASTNAME VARCHAR(30) NOT NULL,
	CEL VARCHAR(12) NOT NULL,
	EMAIL VARCHAR(60) NOT NULL,
	USERID INT
)
WITH
(
	DATA_SOURCE = dataSource_destinationDB
);

/*
STEP 9
Querying the remote table from sourceDB

We will proceed to SELECT COUNT() from ExternalTable_TestTable 
to verify we are viewing the same amount of records that destinationDB has. 
*/
SELECT COUNT(*) FROM dbo.TestTable;
SELECT * FROM dbo.TestTable;



