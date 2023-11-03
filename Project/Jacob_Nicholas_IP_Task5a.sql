GO
DROP PROCEDURE IF EXISTS query1 --get rid of the procedure if you built it before

GO
CREATE PROCEDURE query1 --this is the first.  Need three inputs
	@name1 VARCHAR(64),
    @address VARCHAR(64),
    @category NUMERIC(2,0)
AS
BEGIN
	INSERT INTO Customer VALUES (@name1, @address, @category) --insert me now
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
    SET XACT_ABORT ON
    BEGIN TRANSACTION
	INSERT INTO Processes VALUES (@process_id, @process_data) --insert into process
	IF @type = 'Fit' INSERT INTO Fit VALUES (@process_id, @type_type)
	IF @type = 'Paint' INSERT INTO Paint VALUES (@process_id, @type_type, @type_method)
	IF @type = 'Cut' INSERT INTO Cut VALUES(@process_id, @type_type, @type_method)
    COMMIT TRANSACTION
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
    @name1 VARCHAR(64),
    @process_ids VARCHAR(64)--take this as a string seperated by commas and we'll slice it up
AS
BEGIN
    SET XACT_ABORT ON--this will demand all are run correctly.  It will undo anything if one fails.
    BEGIN TRANSACTION
	INSERT INTO Assemblies VALUES (@assembly_id, @date_ordered, @assembly_details) --insert into assemblies
	INSERT INTO Orders VALUES (@name1,@assembly_id) --record what customer made the order 
	INSERT INTO Manufacture SELECT *,@assembly_id FROM STRING_SPLIT(@process_ids,',')--record all the processes needed to complete this assembly
    COMMIT TRANSACTION--got to run the transaction...
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
    IF @type = 'Process' INSERT INTO Account (acct_id, type_acct, date_established, process_id) VALUES (@acct_id,@type,@date_established,@num) --insert into account
	IF @type = 'Assembly' INSERT INTO Account (acct_id, type_acct, date_established, assembly_id) VALUES (@acct_id,@type,@date_established,@num) --insert into account
	IF @type = 'Department' INSERT INTO Account (acct_id, type_acct, date_established, department_id) VALUES (@acct_id,@type,@date_established,@num) --insert into account
	
    --INSERT INTO Maintains VALUES (@acct_id,@type)--,@num) --pass this info into maintains table changed my shema and did not need this table.
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
    SET XACT_ABORT ON--this will demand all are run correctly.  It will undo anything if one fails.
    BEGIN TRANSACTION
	INSERT INTO Jobs (job_num,job_date_commenced) VALUES (@job_num,@job_date_commenced) --insert into jobs
	INSERT INTO Assign VALUES (@job_num,@assembly_id,@process_id) --pass this info to assign the job to an assembly and initial process
    COMMIT TRANSACTION
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
	@time NUMERIC(4,2),
	@material NUMERIC(4,2),
	@color VARCHAR(10),
	@volume NUMERIC(4,2)

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


GO

DROP PROCEDURE IF EXISTS query8 --get rid of the procedure if you built it before
GO
CREATE PROCEDURE query8 
    @tran_num INT,
	@sup_cost INT,
	@job_num INT,
	@process_id INT 
AS
BEGIN
    SET XACT_ABORT ON--this will demand all are run correctly.  It will undo anything if one fails.
    BEGIN TRANSACTION
	INSERT INTO Transact VALUES (@tran_num,@sup_cost)
	INSERT INTO Costs VALUES (@job_num, @tran_num, @process_id)
	UPDATE Account SET costs = costs + @sup_cost Where type_acct = 'Process' and process_id = @process_id 
	UPDATE Account SET costs = costs + @sup_cost Where type_acct = 'Assembly' and assembly_id = (SELECT assembly_id FROM Assign WHERE job_num = @job_num)
	UPDATE Account SET costs = costs + @sup_cost Where type_acct = 'Department' and department_id = (SELECT dept_num FROM Supervise WHERE process_id=@process_id)
    COMMIT TRANSACTION--you have to commit your transaction
END
GO

--EXEC query8 @tran_num = 50, @sup_cost = 100, @job_num = 50, @process_id =1;

GO

DROP PROCEDURE IF EXISTS query9 --get rid of the procedure if you built it before
GO
CREATE PROCEDURE query9 
    @assembly_id INT

AS
BEGIN
	Select costs FROM Account WHERE assembly_id = @assembly_id and type_acct = 'Assembly'
END
GO

GO
DROP PROCEDURE IF EXISTS query10
GO
CREATE PROCEDURE query10
    @date DATE,
    @department VARCHAR(10)
AS
BEGIN
    IF @department = 'Fit' SELECT sum(labor) as ThisDaysLabor FROM Fit_Job, Jobs WHERE Jobs.job_num = Fit_Job.job_num AND Jobs.job_date_completed = @date 
    IF @department = 'Paint' SELECT sum(labor) as ThisDaysLabor FROM Paint_Job, Jobs WHERE Jobs.job_num = Paint_Job.job_num AND Jobs.job_date_completed = @date 
    IF @department = 'Cut' SELECT sum(labor) as ThisDaysLabor FROM Cut_Job, Jobs WHERE Jobs.job_num = Cut_Job.job_num AND Jobs.job_date_completed = @date 
END
GO
--EXEC query10 @date =?, @department = ?;

GO
DROP PROCEDURE IF EXISTS query11
GO
CREATE PROCEDURE query11
    @assembly_id INT
AS
BEGIN
    SELECT Manufacture.process_id, Supervise.dept_num FROM Manufacture, Supervise WHERE Manufacture.assembly_id = @assembly_id and Manufacture.process_id = Supervise.process_id
END
GO 







GO

DROP PROCEDURE IF EXISTS query12 --get rid of the procedure if you built it before
GO
CREATE PROCEDURE query12 
    @category NUMERIC(2,0)

AS
BEGIN
	Select name1 FROM Customer WHERE category = @category ORDER BY name1 ASC
END
GO



GO

DROP PROCEDURE IF EXISTS query13 --get rid of the procedure if you built it before
GO
CREATE PROCEDURE query13 
    @job_num_start INT,
	@job_num_end INT

AS
BEGIN
	Delete FROM Jobs Where job_num in (SELECT Jobs.job_num FROM Jobs, Cut_Job Where (Cut_Job.job_num >=@job_num_start) and (Cut_Job.job_num<=@job_num_end) and (Jobs.job_num = Cut_Job.job_num))--find the entries that are in both tables and delete them from Jobs this delete will cascade and delete any fk references to these jobs and also delete them  This will remove it from the cut jobs table.
	
END
GO


--EXEC query13 @job_num_start = 50, @job_num_end = 60; 

GO

DROP PROCEDURE IF EXISTS query14 --get rid of the procedure if you built it before
GO
CREATE PROCEDURE query14 
    @job_num INT,
	@color VARCHAR(10)

AS
BEGIN
	Update Paint_Job set color = @color where job_num = @job_num
END
GO