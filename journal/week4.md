# Week 4 — Postgres and RDS


## Architectural Focus for the Week

![](assets/week4/architecural-focus-for-the-week.png)

## Required Homework

### Create RDS Postgres Instance

![](assets/week4/postgres-rds-instance-provisioned-in-console.png)

### Bash Scripting for Common Database Actions

Created several bash scripts to perform various database operations on both our local and prod PostgreSQL servers; scripts by default targeted the local postgres database unless the 'prod' parameter was entered. These operations included the following:
    
    - Connect - connects to prod or local database
	  - Create - creates cruddur database
	  - Drop -  drops cruddur database if there are no active connections
	  - Schema_load - creates 2 tables and respective schemas in cruddur database: users and activities 
	      * Calls upon the schema.sql file to create tables
    - Seed - loads mock data to cruddur database
		    * Calls upon the seed.sql file to load data
	  - Sessions - returns table of active, idle and closed connections
	  - Setup - utility script that automates the creation of the cruddur databases and loading of data. The script run through the following bash scripts in this order:
	      * drop
        * create
        * schema_load
        * seed
        
### Install Postgres Driver in Backend Application 

Psycopg is the driver needed to allow python to interact with postgres. Leveraging the psycopg documentation, we were able to create a db.py file that houses our db class which was composed of various attributes and methods to make connections to our database(s), run queries, and format the output into json.    


### Connect Gitpod to RDS Instance

Updated SG for RDS instance to allow inbound traffic from the IP address of our gitpod environment. When the Gitpod workspace is restarted, it's assigned a new IP address. In order to automatically update the SG with each restart of our workspace, we created the `rds-update-sg-rule bash script`. This script ran a command that returned the IP of the gitpod workspace and stored it in the $GITPOD_IP variable, and then ran AWS CLI commands to update the security group using hardcoded security group ID and the specific security rule ID. I configured the script to be ran as part of the initialization of the workspace by updating he gitpod.yml file. Now each time a workspace is started, the security group rule is updated accordingly and our db-ops bash scripts function normally. 


### Cognito Lambda Trigger



### Create new Activities with Database Insert

Purpose: Implement a `create_activity` function that will allow us to create a 'crud', insert it into the database, and retrieve it on our homepage.
