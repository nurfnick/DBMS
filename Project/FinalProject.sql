-- While working on the database design, it's useful to start from scratch every time
-- Hence, we drop tables in reverse order they are created (so the foreign keyconstraints are not violated)
DROP TABLE IF EXISTS Cut_Job;
DROP TABLE IF EXISTS Paint_Job;
DROP TABLE IF EXISTS Fit_Job;
DROP TABLE IF EXISTS Costs;
DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS Assign;
DROP TABLE IF EXISTS Job;
DROP TABLE IF EXISTS Maintain;
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
DROP TABLE IF EXISTS Process;
-- Create tables
CREATE TABLE Process(
process_id INT PRIMARY KEY,
process_data VARCHAR(64) NOT NULL
);
CREATE TABLE Assemblies(
assembly_id INT PRIMARY KEY,
date_ordered DATE,
assembly_details VARCHAR(64) NOT NULL
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
CONSTRAINT FK_maintain_assembly FOREIGN KEY(assembly_id) REFERENCES Assembly
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
CONSTRAINT FK_assign_assembly FOREIGN KEY(assembly_id) REFERENCES Assembly
);
CREATE TABLE Transaction(
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
CONSTRAINT FK_cost_assembly FOREIGN KEY(assembly_id) REFERENCES Assembly,
CONSTRAINT FK_cost_transation FOREIGN KEY(tran_num) REFERENCES Transaction,
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
