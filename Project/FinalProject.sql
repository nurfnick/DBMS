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
DROP TABLE IF EXISTS Job;
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
CONSTRAINT PK_manufacture PRIMARY KEY (process_id, assembly_id),
CONSTRAINT FK_processid FOREIGN KEY(process_id) REFERENCES Process,
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
CONSTRAINT FK_proccessid FOREIGN KEY (process_id) REFERENCES Process
);
CREATE TABLE Fit(
process_id INT PRIMARY KEY,
fit_type VARCHAR(64),
CONSTRAINT FK_fit_process FOREIGN KEY(process_id) REFERENCES Process
);
CREATE TABLE Paint(
process_id INT PRIMARY KEY,
paint_type VARCHAR(64),
paint_method VARCHAR(64),
CONSTRAINT FK_paint_process FOREIGN KEY(process_id) REFERENCES Process
);
CREATE TABLE Cut(
process_id INT PRIMARY KEY,
cutting_type VARCHAR(64),
machine_type VARCHAR(64),
CONSTRAINT FK_cut_process FOREIGN KEY(process_id) REFERENCES Process
);
CREATE TABLE Account(
acct_id INT PRIMARY KEY,
type VARCHAR(10) check (type in ('Process','Assembly','Department')),
date_established DATE,
costs INT
);
CREATE TABLE Maintains(
acct_id INT,
dept_num INT,
process_id INT,
assembly_id INT,
CONSTRAINT PK_maintain PRIMARY KEY(acct_id,dept_num,process_id,assembly_id),
CONSTRAINT FK_maintain_process FOREIGN KEY(process_id) REFERENCES Process,
CONSTRAINT FK_maintain_acct FOREIGN KEY(acct_id) REFERENCES Account,
CONSTRAINT FK_maintain_department FOREIGN KEY(dept_num) REFERENCES Department,
CONSTRAINT FK_maintain_assembly FOREIGN KEY(assembly_id) REFERENCES Assemblies
);
CREATE TABLE Job(
job_num INT PRIMARY KEY,
job_date_commenced DATE,
job_date_completed DATE
);
CREATE TABLE Assign(
job_num INT,
assembly_id INT,
process_id INT,
CONSTRAINT PK_assign PRIMARY KEY(job_num,process_id,assembly_id),
CONSTRAINT FK_assign_process FOREIGN KEY(process_id) REFERENCES Process,
CONSTRAINT FK_assign_job FOREIGN KEY(job_num) REFERENCES Job,
CONSTRAINT FK_assign_assembly FOREIGN KEY(assembly_id) REFERENCES Assemblies
);
CREATE TABLE Transact(
tran_num INT PRIMARY KEY,
sup_cost INT
);
CREATE TABLE Costs(
job_num INT,
acct_id INT,
dept_num INT,
process_id INT,
assembly_id INT,
tran_num INT,
CONSTRAINT PK_Costs PRIMARY KEY(job_num,acct_id,dept_num,process_id,assembly_id, tran_num),
CONSTRAINT FK_cost_process FOREIGN KEY(process_id) REFERENCES Process,
CONSTRAINT FK_cost_acct FOREIGN KEY(acct_id) REFERENCES Account,
CONSTRAINT FK_cost_department FOREIGN KEY(dept_num) REFERENCES Department,
CONSTRAINT FK_cost_assembly FOREIGN KEY(assembly_id) REFERENCES Assemblies,
CONSTRAINT FK_cost_transact FOREIGN KEY(tran_num) REFERENCES Transact,
CONSTRAINT FK_cost_job FOREIGN KEY(job_num) REFERENCES Job
);
CREATE TABLE Fit_Job(
job_num INT PRIMARY KEY,
labor NUMERIC(3,0),
CONSTRAINT FK_fit_job FOREIGN KEY(job_num) REFERENCES Job
);
CREATE TABLE Paint_Job(
job_num INT PRIMARY KEY,
color VARCHAR(10),
volume NUMERIC(3,2),
labor NUMERIC(3,0),
CONSTRAINT FK_paint_job FOREIGN KEY(job_num) REFERENCES Job
);
CREATE TABLE Cut_Job(
job_num INT PRIMARY KEY,
machine_type VARCHAR(10),
time NUMERIC(2,2),
material NUMERIC(2,2),
labor NUMERIC(3,0),
CONSTRAINT FK_cut_job FOREIGN KEY(job_num) REFERENCES Job
);

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
	INSERT INTO Process VALUES (@process_id, @process_data) --insert into process
	IF @type = 'Fit' INSERT INTO Fit VALUES (@process_id, @type_type)
	IF @type = 'Paint' INSERT INTO Paint VALUES (@process_id, @type_type, @type_method)
	IF @type = 'Cut' INSERT INTO Cut VALUES(@process_id, @type_type, @type_method)
END
GO
DROP PROCEDURE IF EXISTS query4 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query4 --this is the first.  Need three inputs
	@assembly_id INT,
    @date_ordered DATE,
    @assembly_details VARCHAR(64),
    @name VARCHAR(64),
    @process_ids VARCHAR(64)--take this as a string seperated by commas and we'll slice it up
AS
BEGIN
	INSERT INTO Assemblies VALUES (@assembly_id, @date_ordered, @assembly_details) --insert into assemblies
	INSERT INTO Orders VALUES (@name,@assembly_id) --record what customer made the order
	--INSERT INTO Manufactures (process_id,assembly_id) SELECT *,@assembly_id FROM (SELECT value FROM STRING_SPLIT(@process_ids,','))
END
GO
