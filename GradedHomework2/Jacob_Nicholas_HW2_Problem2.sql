
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
VALUES
	(1,'Parker',580000),
	(2,'Black',2500000),
	(3,'Black',30000),
	(4,'Stone',820000)

Insert INTO Movie
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



SELECT *
From Movie

SELECT *
FROM Director

SELECT *
FROM Acted

SELECT *
FROM Preformer

SELECT mname
FROM Movie
WHERE genre = 'Action'


Select genre,AVG(minutes) as avg_length_in_min
FROM Movie
Group BY genre

SELECT pname
FROM Performer
WHERE years_of_experience>20 and pid in(Select pid 
					From Acted 
					Where mname in (SELECT mname 
							FROM Movie 
							Where did in (SELECT did FROM Director Where dname = 'Black' )))

SELECT MAX(age) as max_age_Hanks_or_Departed
FROM Performer
WHERE pname = 'Hanks' or pid in (SELECT pid FROM Movie WHERE mname = 'The Departed')


(Select mname  FROM Movie Where genre = 'Comedy' )
union
(SELECT mname FROM Acted GROUP BY mname HAVING count(pid)>1) 

SELECT  Acted.pid, pname
FROM Acted, Performer, Movie
Where Acted.pid in (SELECT pid FROM Acted GROUP BY pid HAVING COUNT(*)>1) and Performer.pid = Acted.pid and Movie.mname = Acted.mname
GROUP BY pname, genre, Acted.pid
HAVING count(*)>1

UPDATE Director SET earnings = .9*earnings
Where did in ( SELECT did
		From Movie
		Where mname = 'Up')


DELETE FROM Movie
WHERE release_year <=1989 and release_year>=1970

