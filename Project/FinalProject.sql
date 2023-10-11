-- While working on the database design, it's useful to start from scratch every time
-- Hence, we drop tables in reverse order they are created (so the foreign keyconstraints are not violated)
DROP TABLE IF EXISTS Enrollment
DROP TABLE IF EXISTS Student
DROP TABLE IF EXISTS Class
DROP TABLE IF EXISTS Cut_Job;
DROP TABLE IF EXISTS Paint_Job;
DROP TABLE IF EXISTS Fit_Job;
DROP TABLE IF EXISTS Costs;
DROP TABLE IF EXISTS Transact;
DROP TABLE IF EXISTS Assign;
DROP TABLE IF EXISTS Jobs;
DROP TABLE IF EXISTS Maintains;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Cut;
DROP TABLE IF EXISTS Paint;
DROP TABLE IF EXISTS Fit;
DROP TABLE IF EXISTS Supervise;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Manufacture;
DROP TABLE IF EXISTS Assemblies;
DROP TABLE IF EXISTS Processes;
-- Create tables
CREATE TABLE Processes(
process_id INT PRIMARY KEY,
process_data VARCHAR(64)
);
CREATE TABLE Assemblies(
assembly_id INT PRIMARY KEY,
date_ordered DATE,
assembly_details VARCHAR(64)
);
CREATE TABLE Manufacture (
process_id INT,
assembly_id INT,
CONSTRAINT FK_processid FOREIGN KEY(process_id) REFERENCES Processes,
CONSTRAINT FK_aid FOREIGN KEY(assembly_id) REFERENCES Assemblies
);
CREATE TABLE Customer(
name VARCHAR(64) PRIMARY KEY,
address VARCHAR(64),
category NUMERIC(2,0) NOT NULL,
CHECK(category>0 and category<11)
);
CREATE TABLE Orders (
name VARCHAR(64),
assembly_id INT,
CONSTRAINT PK_orders PRIMARY KEY (name, assembly_id),
CONSTRAINT FK_cname FOREIGN KEY(name) REFERENCES Customer,
CONSTRAINT FK_aidOrders FOREIGN KEY(assembly_id) REFERENCES Assemblies
);
CREATE TABLE Department (
dept_num INT PRIMARY KEY,
dept_data VARCHAR(128)
);
CREATE TABLE Supervise (
dept_num INT,
process_id INT,
CONSTRAINT PK_Supervises PRIMARY KEY(dept_num, process_id),
CONSTRAINT FK_deptnum FOREIGN KEY (dept_num) REFERENCES Department,
CONSTRAINT FK_proccessid FOREIGN KEY (process_id) REFERENCES Processes
);
CREATE TABLE Fit(
process_id INT PRIMARY KEY,
fit_type VARCHAR(64),
CONSTRAINT FK_fit_process FOREIGN KEY(process_id) REFERENCES Processes
);
CREATE TABLE Paint(
process_id INT PRIMARY KEY,
paint_type VARCHAR(64),
paint_method VARCHAR(64),
CONSTRAINT FK_paint_process FOREIGN KEY(process_id) REFERENCES Processes
);
CREATE TABLE Cut(
process_id INT PRIMARY KEY,
cutting_type VARCHAR(64),
machine_type VARCHAR(64),
CONSTRAINT FK_cut_process FOREIGN KEY(process_id) REFERENCES Processes
);
CREATE TABLE Account(
acct_id INT PRIMARY KEY,
type_acct VARCHAR(10) check (type_acct in ('Process','Assembly','Department')),
date_established DATE,
type_acct_id INT, --I should be a FK to Process, Assembly or department but could not figure how to make keys conditional to value of type_acct
costs INT
);
/*
CREATE TABLE Maintains(
acct_id INT,
type_acct VARCHAR(10) check (type_acct in ('Process','Assembly','Department')),
--num INT,
CONSTRAINT PK_maintain PRIMARY KEY(acct_id,type_acct),
CONSTRAINT FK_maintain_acct FOREIGN KEY(acct_id) REFERENCES Account--should have FKey on the num but couldn't figure out how to make that work
);
*/
CREATE TABLE Jobs(
job_num INT PRIMARY KEY,
job_date_commenced DATE,
job_date_completed DATE
);
CREATE TABLE Assign(
job_num INT,
assembly_id INT,
process_id INT,--this gets the job started but not all of them?
CONSTRAINT PK_assign PRIMARY KEY(job_num,process_id,assembly_id),
CONSTRAINT FK_assign_process FOREIGN KEY(process_id) REFERENCES Processes,
CONSTRAINT FK_assign_job FOREIGN KEY(job_num) REFERENCES Jobs,
CONSTRAINT FK_assign_assembly FOREIGN KEY(assembly_id) REFERENCES Assemblies
);
CREATE TABLE Transact(
tran_num INT PRIMARY KEY,
sup_cost INT
);
CREATE TABLE Costs(--either transact or cost will need a process_id otherwise we won't know where to bill it.
job_num INT,
tran_num INT,
process_id INT,
--CONSTRAINT PK_Costs PRIMARY KEY(job_num, tran_num),
CONSTRAINT FK_cost_process FOREIGN KEY(process_id) REFERENCES Processes,
--CONSTRAINT FK_cost_acct FOREIGN KEY(acct_id) REFERENCES Account,
--CONSTRAINT FK_cost_department FOREIGN KEY(dept_num) REFERENCES Department,
--CONSTRAINT FK_cost_assembly FOREIGN KEY(assembly_id) REFERENCES Assemblies,
CONSTRAINT FK_cost_transact FOREIGN KEY(tran_num) REFERENCES Transact,
CONSTRAINT FK_cost_job FOREIGN KEY(job_num) REFERENCES Jobs
);
CREATE TABLE Fit_Job(
job_num INT PRIMARY KEY,
labor NUMERIC(3,0),
CONSTRAINT FK_fit_job FOREIGN KEY(job_num) REFERENCES Jobs
);
CREATE TABLE Paint_Job(
job_num INT PRIMARY KEY,
color VARCHAR(10),
volume NUMERIC(3,2),
labor NUMERIC(3,0),
CONSTRAINT FK_paint_job FOREIGN KEY(job_num) REFERENCES Jobs
);
CREATE TABLE Cut_Job(
job_num INT PRIMARY KEY,
machine_type VARCHAR(10),
time NUMERIC(2,2),
material NUMERIC(2,2),
labor NUMERIC(3,0),
CONSTRAINT FK_cut_job FOREIGN KEY(job_num) REFERENCES Jobs
);
go
CREATE INDEX customer_name ON Customer(name)--query 1 insertion of customers
GO
CREATE INDEX dept_num ON Department(dept_num ASC) --query 2 insert of departments
GO
CREATE INDEX process ON Processes(process_id ASC) --query 3 making sequential indexes
CREATE INDEX process_cut ON Cut(process_id ASC)
CREATE INDEX process_paint ON Paint(process_id ASC)
CREATE INDEX process_fit ON Fit(process_id ASC)
GO
CREATE INDEX supervies ON Supervise(process_id, dept_num) --query 3 getting the supervise table indexed
GO
CREATE INDEX orders_index ON Orders(name, assembly_id) --query 4 keeping the name and assembly_id together

CREATE INDEX Manufacture_index ON Manufacture(assembly_id)--query4 
GO
CREATE INDEX account_index ON Account(type_acct ASC, type_acct_id) --query5 this will be accessed a bunch to join other tables. 
--No need to create 6 and 7 as B tree is created on Primary Key automatically
GO
CREATE INDEX transaction_index ON Transact(tran_num)
CREATE INDEX cost_index ON Costs(tran_num, process_id)--query8 
GO
CREATE INDEX account_assembly ON Account(type_acct, type_acct_id)--query9
GO 
CREATE INDEX job_date_index ON Jobs(job_date_commenced ASC, job_date_completed ASC)--query10 make sure to order them for quicker discovery
GO
--CREATE INDEX manufacture_index ON Manufacture(assembly_id ASC)--query11
CREATE INDEX customer_index ON Customer(name ASC, category)--query 12.  Joining the name and category and keeping name in order.
GO
CREATE INDEX cutjob_index ON Cut_Job(job_num)--query 13
GO
CREATE INDEX paintjob_index ON Paint_Job(job_num)--query 14
GO

GO
DROP PROCEDURE IF EXISTS query1 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query1 --this is the first.  Need three inputs
	@name VARCHAR(64),
    @address VARCHAR(64),
    @category NUMERIC(2,0)
AS
BEGIN
	INSERT INTO Customer VALUES (@name, @address, @category) --insert me now
END
GO
--EXEC query1 @name = 'Nick', @address = NULL, @category = 10
GO

GO
DROP PROCEDURE IF EXISTS query2 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query2 
	@dept_num INT,
    @dept_data VARCHAR(128)
AS
BEGIN
	INSERT INTO Department VALUES (@dept_num, @dept_data) --insert me now
END
GO
--EXEC query2 @dept_num = 1, @dept_data = NULL
GO
DROP PROCEDURE IF EXISTS query3 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query3 --this is the first.  Need three inputs
	@process_id INT,
    @process_data VARCHAR(64),
    @type VARCHAR(5),
    @type_type VARCHAR(64),
    @type_method VARCHAR(64)
AS
BEGIN
	INSERT INTO Processes VALUES (@process_id, @process_data) --insert into process
	IF @type = 'Fit' INSERT INTO Fit VALUES (@process_id, @type_type)
	IF @type = 'Paint' INSERT INTO Paint VALUES (@process_id, @type_type, @type_method)
	IF @type = 'Cut' INSERT INTO Cut VALUES(@process_id, @type_type, @type_method)
END
GO
--EXEC query3 1,'','Fit',NULL,NULL
GO
DROP PROCEDURE IF EXISTS query4 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query4 --create assembly with all associated processes for customer
	@assembly_id INT,
    @date_ordered DATE,
    @assembly_details VARCHAR(64),
    @name VARCHAR(64),
    @process_ids VARCHAR(64)--take this as a string seperated by commas and we'll slice it up
AS
BEGIN
	INSERT INTO Assemblies VALUES (@assembly_id, @date_ordered, @assembly_details) --insert into assemblies
	INSERT INTO Orders VALUES (@name,@assembly_id) --record what customer made the order
	INSERT INTO Manufacture SELECT *,@assembly_id FROM STRING_SPLIT(@process_ids,',')--record all the processes needed to complete this assembly
END
GO
--EXEC query4 1,'10/01/23',NULL,'Nick','1,1,1'
GO
DROP PROCEDURE IF EXISTS query5 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query5 
    @acct_id INT,
    @type VARCHAR(10),
    @date_established DATE,
	@num INT
AS
BEGIN
	INSERT INTO Account VALUES (@acct_id,@type,@date_established,@num,0) --insert into account
	--INSERT INTO Maintains VALUES (@acct_id,@type)--,@num) --pass this info into maintains table
END
GO
--EXEC query5 1,'Process','10/10/20',1

GO



DROP PROCEDURE IF EXISTS query6 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query6 
    @job_num INT,
    @job_date_commenced DATE,
    @assembly_id INT,
	@process_id INT
AS
BEGIN
	INSERT INTO Jobs (job_num,job_date_commenced) VALUES (@job_num,@job_date_commenced) --insert into jobs
	INSERT INTO Assign VALUES (@job_num,@assembly_id,@process_id) --pass this info to assign the job to an assembly and initial process
END

GO
--EXEC query6 50,NULL,1,1
GO

DROP PROCEDURE IF EXISTS query7 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query7 
    @job_num INT,
    @job_date_completed DATE,
    @job_type VARCHAR(10),
	@labor NUMERIC(3,0),
	@machine_type VARCHAR(10),
	@time NUMERIC(2,2),
	@material NUMERIC(2,2),
	@color VARCHAR(10),
	@volume NUMERIC(3,2)

AS
BEGIN
	Update Jobs set job_date_completed = @job_date_completed where job_num = @job_num
	IF @job_type = 'Fit' INSERT INTO Fit_Job VALUES (@job_num, @labor)
	IF @job_type = 'Paint' INSERT INTO Paint_Job VALUES (@job_num, @color, @volume,@labor)
	IF @job_type = 'Cut' INSERT INTO Cut_Job VALUES(@job_num, @machine_type, @time,@material,@labor)
END
GO

--EXEC query7 @job_num = 50, @job_date_completed = '10/01/23', @job_type = 'Fit', @labor = 4.32, @machine_type = NULL, @time = NULL,@color = NULL, @volume = NULL, @material = NULL;  
GO  
