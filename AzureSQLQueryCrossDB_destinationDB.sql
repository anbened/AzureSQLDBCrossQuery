
/* destinationDB */

/*
STEP 0
Create the table in destinationDB

We need to have an existing physical table in our destinationDB, 
which will be the one that we will be referencing from sourceDB further 
*/
USE [destinationDB]
CREATE TABLE TestTable
(
	ID INT IDENTITY PRIMARY KEY,
	NAME VARCHAR(20) NOT NULL,
	LASTNAME VARCHAR(30) NOT NULL,
	CEL VARCHAR(12) NOT NULL,
	EMAIL VARCHAR(60) NOT NULL,
	USERID INT
);


/* 
STEP 2 
Create a SQL User in the remote database (Use RemoteDB) 

We now need to create a new user for the RemoteLogger login 
we previously created in master database. 
This is the SQL login created in step 1.
*/
USE [destinationDB]
CREATE USER RemoteLogger FOR LOGIN RemoteLogger;

/*
STEP 7
Granting the user SELECT permissions on TestTable

Here we will grant our destinationDB user the rights 
to SELECT on the table. 
This will allow the sourceDB query to authenticate against 
destinationDB with the correct credentials and avoid bumping into permission issues later on.
*/
GRANT SELECT ON [TestTable] TO RemoteLogger;

/*
STEP 8
Inserting data in TestTable

Now all is left is to populate the TestTable 
*/
INSERT INTO TestTable (Name, LastName, Cel, Email, UserId) 
VALUES
('Vlad', 'Borvski', '91551234567', 'email3@contoso.com', 5),
('Juan', 'Galvin', '95551234568', 'email2@contoso.com', 5),
('Julio', 'Calderon', '95551234569', 'email1@contoso.net',1),
('Fernando', 'Cobo', '86168999', 'email0@email.com', 5);

/*
STEP 10
Check if the data is the same
*/
SELECT * FROM TestTable;

