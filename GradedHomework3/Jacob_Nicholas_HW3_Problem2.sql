
-- While working on the database design, it's useful to start from scratch every time
-- Hence, we drop tables in reverse order they are created (so the foreign keyconstraints are not violated)
DROP TABLE IF EXISTS Director;
DROP TABLE IF EXISTS Acted;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Performer;
-- Create tables
CREATE TABLE Performer(
pid INT PRIMARY KEY,
pname VARCHAR(64) NOT NULL,
years_of_experience INT,
age INT
);
CREATE TABLE Movie (
mname VARCHAR(64) PRIMARY KEY,
genre VARCHAR(64),
minutes INT,
release_year INT,
did INT
);
CREATE TABLE Acted (
pid INT,
mname VARCHAR(64),
CONSTRAINT PK_acted PRIMARY KEY (pid, mname),
CONSTRAINT FK_pid FOREIGN KEY(pid) REFERENCES Performer,
CONSTRAINT FK_mname FOREIGN KEY(mname) REFERENCES Movie
);
CREATE TABLE Director(
did int PRIMARY KEY,
dname VARCHAR(64),
earnings REAL
);

INSERT INTO Performer
	(pid,pname,years_of_experience,age)
VALUES
	(1,'Morgan',48,67),
	(2,'Cruz',14,28),
	(3,'Adams',1,16),
	(4,'Perry',18,32),
	(5,'Hanks',36,55),
	(6,'Hanks',15,24),
	(7,'Lewis',13,32)
Insert INTO Director
	(did,dname,earnings)
VALUES
	(1,'Parker',580000),
	(2,'Black',2500000),
	(3,'Black',30000),
	(4,'Stone',820000)

Insert INTO Movie
	(mname,genre,minutes,release_year,did)
VALUES
	('Jurassic Park','Action',125,1984,2),
	('Shawshank Redemption','Drama',105,2001,2),
	('Fight Club','Drama',	144,	2015,	2),
	('The Departed','Drama',	130,	1969,	3),
	('Back to the Future','Comedy',	89,	2008,	3),
	('The Lion King','Animation',	97,	1990,	1),
	('Alien','Sci-Fi',	115,	2006,	3),
	('Toy Story','Animation',	104,	1978,	1),
	('Scarface','Drama',	124,	2003,	1),
	('Up',	'Animation',111,1999,4)

Insert INTO Acted
	(pid,mname)
Values
	(4,'Fight Club'),
	(5,'Fight Club'),
	(6,'Shawshank Redemption'),
	(4,'Up'),
	(5,'Shawshank Redemption'),
	(1,'The Departed'),
	(2,'Fight Club'),
	(3,'Fight Club'),
	(4,'Alien')


DROP PROCEDURE IF EXISTS experienceWithAge --get rid of the procedure if you built it before

GO
CREATE PROCEDURE experienceWithAge --this is the first.  Need three inputs
	@pid INT,
	@pname VARCHAR(64),
	@age INT
AS
BEGIN
	DECLARE @avg_years INT;
	SET @avg_years = (SELECT AVG(years_of_experience) FROM Performer WHERE age-10<=@age AND age+10>=@age)--find the average of those in a ME of 10
	IF @avg_years IS NULL SET @avg_years = @age -18 --if @age NULL, set it to age -18
	IF @avg_years<0 SET @avg_years =0 --for the youngins, make it just zero
	IF @avg_years >@age SET @avg_years = @age --incase average got above age, make it just the age
	INSERT INTO Performer VALUES (@pid, @pname, @avg_years, @age) --insert me now
END
GO
--EXEC experienceWithAge @age = 55, @pid = 42, @pname = 'Nick'; --testing
--SELECT * FROM Performer WHERE pid = 42 --showing test works

DROP PROCEDURE IF EXISTS experienceFromDirector --second question getting average from director

GO
CREATE PROCEDURE experienceFromDirector --same variables as before just need director.
	@pid INT,
	@pname VARCHAR(64),
	@age INT,
	@did INT
AS
BEGIN
	DECLARE @avg_years INT;
	SET @avg_years = (SELECT avg(years_of_experience) FROM performer WHERE pid in (SELECT pid FROM Acted, Movie WHERE Acted.mname = Movie.mname and Movie.did = @did)) --longer call.  Find all actors who have been in a movie with the director then average their YoE
	IF @avg_years IS NULL SET @avg_years = @age -18 --watch out for null values
	IF @avg_years<0 SET @avg_years =0 --watch out for youngins
	IF @avg_years >@age SET @avg_years = @age --watch out for too much experience
	INSERT INTO Performer VALUES (@pid, @pname, @avg_years, @age) --insert into table
END
GO
--EXEC experienceFromDirector @age = 55, @pid = 42, @pname = 'Nick', @did = 2; --testing
--SELECT * FROM Performer --WHERE pid = 42 --showing test works