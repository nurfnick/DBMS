
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


INSERT INTO Performer
	(pid,pname,years_of_experience,age)
VALUES
	(1,'Jacob',22,40) 
--the pid 1 has already been used so I cannot add myself as the greatest preformer.


INSERT INTO Performer
	(pname,years_of_experience,age)
VALUES
	('Jacob',22,40) 
--I do not give myself a pid and that is not allowed


Insert INTO Acted
Values
	(42,'Hitchhikers Guide to the Galaxy') 
--there is no actor 42


Insert INTO Acted
Values
	(2,'Hitchhikers Guide to the Galaxy') 
--there is no movie Hitchhikers Guide to the Galaxy

delete
from Performer
where pid = 4
--I cannot delete preformer 4 since they acted in Alien (and others)

update Acted
set mname = 'Hitchhikers Guide to the Galaxy'
where pid = 4
--I cannot update the acted table to a movie that does not exist in the movie table

SELECT *
FROM Movie
Where mname is NULL 
-- Since mname is the PRIMARY KEY, it can never be null.  This query does not throw an error but also returns no results (and will never return results!)

SELECT *
FROM Movie
Where release_year = 'ODowell Rules'

--Since release_year is an INT it can never be this string.  Again no issue running this query though...

create index genre_index on Movie(genre)
Select genre,AVG(minutes) as avg_length_in_min
FROM Movie
Group BY genre

--The above index is created on genre to improve the performance of the above query.  We see that if the table has been indexed on genre then the group by command will be faster.

(Select mname  FROM Movie Where genre = 'Comedy' )
union
(SELECT mname FROM Acted GROUP BY mname HAVING count(pid)>1) 
--This could also be improved with the above index.

SELECT mname
FROM Movie
WHERE genre = 'Action'
--This one will also be improved in speed with my indexing.