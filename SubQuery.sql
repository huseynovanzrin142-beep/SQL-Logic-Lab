USE master
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SubqueryDB')
BEGIN
ALTER DATABASE SubqueryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE SubqueryDB
END
GO
CREATE DATABASE SubqueryDB
GO
USE SubqueryDB
GO

CREATE TABLE Curators (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(MAX) NOT NULL DEFAULT 'No Name',
[Surname] NVARCHAR(MAX) NOT NULL DEFAULT 'No Surname'
)

GO
CREATE TABLE Faculties (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(100) UNIQUE NOT NULL DEFAULT 'No Name'
)

GO
CREATE TABLE Departments (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Building] INT NOT NULL,
[Financing] MONEY NOT NULL DEFAULT (0),
[Name] NVARCHAR(100) UNIQUE NOT NULL DEFAULT 'No Name',
[FacultyId] INT NOT NULL FOREIGN KEY REFERENCES Faculties(Id),
CONSTRAINT CK_Building CHECK ([Building] BETWEEN 1 AND 5),
CONSTRAINT CK_Financing CHECK ([Financing] >= 0)
)

GO
CREATE TABLE Groups (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(10) UNIQUE NOT NULL DEFAULT 'No Name',
[Year] INT NOT NULL,
[DepartmentId] INT NOT NULL FOREIGN KEY REFERENCES Departments(Id),
CONSTRAINT CK_Year CHECK([Year] BETWEEN 1 AND 5)
)

GO
CREATE TABLE Subjects (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(100) UNIQUE NOT NULL DEFAULT 'No Name'
)

GO
CREATE TABLE Teachers (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[IsProfessor] BIT NOT NULL DEFAULT(0),
[Name] NVARCHAR(MAX) NOT NULL DEFAULT 'No Name',
[Salary] MONEY NOT NULL,
[Surname] NVARCHAR(MAX) NOT NULL DEFAULT 'No Surname',
CONSTRAINT CK_Salary CHECK([Salary] > 0)
)

GO 
CREATE TABLE Lectures (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Date] DATE NOT NULL,
[SubjectId] INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
[TeacherId] INT NOT NULL FOREIGN KEY REFERENCES Teachers(Id),
CONSTRAINT CK_Date CHECK([Date] <= GETDATE()) 
)


GO 
CREATE TABLE Students (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(MAX) NOT NULL DEFAULT 'No Name',
[Rating] INT NOT NULL,
[Surnme] NVARCHAR(MAX) NOT NULL DEFAULT 'No Surname',
CONSTRAINT CK_Rating CHECK ([Rating] BETWEEN 0 AND 5)
)

GO
CREATE TABLE GroupsCurators(
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[GroupId] INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
[CuratorId] INT NOT NULL FOREIGN KEY REFERENCES Curators(Id)
)

GO
CREATE TABLE GroupsLectures(
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[GroupId] INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
[LectureId] INT NOT NULL FOREIGN KEY REFERENCES Lectures(Id)
)

GO
CREATE TABLE GroupsStudents(
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[GroupId] INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
[StudentId] INT NOT NULL FOREIGN KEY REFERENCES Students(Id)
)

INSERT INTO [Curators] ([Name], [Surname])
VALUES
('Ali', 'Aliyev'),
('Veli', 'Memmedov'),
('Leyla', 'Huseynova');
GO

INSERT INTO [Faculties] ([Name])
VALUES 
('Programming'),
('Engineering'),
('Business');
GO

INSERT INTO [Departments] ([Building], [Financing], [Name], [FacultyId])
VALUES
(1, 150000, 'Software Development', 1),
(2, 80000, 'Cyber Security', 1),
(3, 120000, 'Mechanical Engineering', 2),
(4, 50000, 'Marketing', 3),
(5, 150000, 'Computer Science', 1);

GO
INSERT INTO [Groups] ([Name], [Year], [DepartmentId])
VALUES
('D221', 5, 1),
('D222', 5, 1),
('CS101', 3, 2),
('ME301', 5, 3);
GO

INSERT INTO [Subjects] ([Name])
VALUES
('Database'),
('Algorithms'),
('Programming'),
('Physics');
GO

INSERT INTO [Teachers] ([IsProfessor], [Name], [Salary], [Surname])
VALUES
(1, 'Aydin', 5000, 'Kerimov'),
(0, 'Rashad', 3000, 'Aliyev'),
(1, 'Sabir', 5500, 'Memmedov'),
(0, 'Nigar', 2500, 'Hasanova');
GO

INSERT INTO [Lectures] ([Date], [SubjectId], [TeacherId])
VALUES
('2024-01-10', 1, 1),
('2024-01-11', 1, 1),
('2024-01-12', 2, 2),
('2024-01-13', 3, 3),
('2024-01-14', 3, 3),
('2024-01-15', 3, 3),
('2024-01-16', 4, 4);
GO

INSERT INTO [Students] ([Name], [Rating], [Surnme])
VALUES
('Kamran', 5, 'Aliyev'),
('Murad', 4, 'Hasanov'),
('Aysel', 5, 'Kerimova'),
('Lale', 3, 'Memmedova'),
('Tural', 2, 'Huseynov');
GO

INSERT INTO [GroupsCurators] ([GroupId], [CuratorId])
VALUES
(1,1),
(1,2),
(2,3);
GO

INSERT INTO [GroupsLectures] ([GroupId], [LectureId])
VALUES
(1,1),
(1,2),
(1,4),
(1,5),
(1,6),
(2,3),
(3,7);
GO

INSERT INTO [GroupsStudents] ([GroupId], [StudentId])
VALUES
(1,1),
(1,2),
(1,3),
(2,4),
(3,5);
GO

--Print numbers of buildings if the total financing fund of the departments located in them exceeds 100,000.
GO 
SELECT D.[Name] AS [Departmet's Names], D.[Building] AS [Building No] 
FROM Departments AS D, Faculties AS F
WHERE D.[FacultyId] = F.[Id]
AND D.[Financing] > 100000

--  Print names of the 5th year groups of the Software Development department that have more than 10 double periods in
--the first week
GO
SELECT G.[Name] AS [Group's Names]
FROM Departments AS D, Lectures AS L, GroupsLectures AS GL, Groups AS G, (SELECT TOP 7 L.[Date] AS [Lecture Dates]
FROM Lectures AS L
ORDER BY L.[Date] ASC) AS [Choosen Year]
WHERE L.[Date] = [Choosen Year].[Lecture Dates]
AND L.[Id] = GL.LectureId
AND GL.[GroupId] = G.[Id] 
AND G.[DepartmentId] = D.[Id]
AND G.[Year] = 5
AND D.[Name] = 'Software Development'
GROUP BY G.[Name], G.[Id]
HAVING COUNT(GL.[LectureId]) > 10

-- Print names of the groups whose rating (average rating of all students in the group) is greater than the rating of the "D221" group
GO
SELECT G.[Name] AS [Group's Names]
FROM Groups AS G, Students AS S, GroupsStudents AS GS
WHERE S.[Id] = GS.[StudentId]
AND GS.[GroupId] = G.[Id]
GROUP BY G.[Id], G.[Name]
HAVING AVG(S.[Rating]) > (SELECT AVG(S.[Rating])
FROM Groups AS G, Students AS S, GroupsStudents AS GS
WHERE S.[Id] = GS.[StudentId]
AND GS.[GroupId] = G.[Id]
AND G.[Name] = 'D221')


--Print full names of teachers whose wage rate is higher than the average wage rate of professors.
GO
SELECT T.[Name] + ' ' + T.[Surname] AS [Teacher's Full Names], T.[Salary]
From Teachers AS T
WHERE T.[Salary] > (SELECT AVG(T.[Salary])
FROM Teachers AS T
WHERE T.[IsProfessor] = 1)


--Print names of groups with more than one curator
GO
SELECT G.[Name] AS [Group's Names] , COUNT(C.[Id]) AS [Curator's Counts]
FROM Groups AS G, GroupsCurators AS GC, Curators AS C
WHERE C.[Id] = GC.[CuratorId]
AND GC.[GroupId] = G.[Id]
GROUP BY G.[Id], G.[Name]
HAVING COUNT(C.[Id]) > 1


--Print names of the groups whose rating (the average rating of all students of the group) is less than the minimum rating 
--of the 5th year groups.
GO
SELECT G.[Name] AS [Group's Names]
FROM Groups AS G, Students AS S, GroupsStudents AS GS
WHERE S.[Id] = GS.[StudentId]
AND GS.[GroupId] = G.[Id]
AND S.[Rating] < (SELECT AVG(S.[Rating])
FROM Groups AS G, Students AS S, GroupsStudents AS GS
WHERE S.[Id] = GS.[StudentId]
AND GS.[GroupId] = G.[Id]
AND G.[Year] = 5)
ORDER BY S.[Rating] ASC


-- Print names of the faculties with total financing fund of the departments greater than the total financing fund of the Computer
--Science department.
GO
SELECT F.[Name] AS [Faculties Names]
FROM Departments AS D, Faculties AS F
WHERE F.[Id] = D.[FacultyId]
GROUP BY F.[Id], F.[Name]
HAVING SUM(D.[Financing])>
(SELECT SUM( D.[Financing] ) AS [Financing]
FROM Departments AS D
WHERE D.[Name] = 'Computer Science')


-- Print names of the subjects and full names of the teachers who deliver the greates number of lectures in them.
SELECT S.[Name] AS [Most thought Subject's Names], T.[Name] + ' ' +T.[Surname] AS [Teacher's Full Names] 
FROM Lectures AS L, Teachers AS T, Subjects AS S
WHERE L.[TeacherId] = T.[Id]
AND L.[SubjectId] = S.[Id] 
AND L.SubjectId = (
SELECT TOP 1 L.[SubjectId]
FROM Lectures AS L,Subjects AS S
WHERE L.[SubjectId] = S.[Id]
GROUP BY L.[SubjectId]
ORDER BY COUNT(L.[SubjectId]) DESC
)
GROUP BY  S.[Name],  T.[Name] + ' ' +T.[Surname] 


-- Print name of the subject in which the least number of lectures are delivered.
GO
SELECT TOP 1 COUNT(L.[SubjectId]) AS [Lecture Count], S.[Name] as [Subject's Names] 
FROM Subjects AS S, Lectures AS L
WHERE L.[SubjectId] = S.[Id]
GROUP BY S.[Name]
ORDER BY [Lecture Count] DESC


-- Print number of students and subjects taught at the Software Development department.
GO
SELECT COUNT(St.[Name]) AS [Student's Counts],  COUNT(S.[Name]) AS [Subjects's Counts]
FROM Subjects AS S, Students AS St, Departments AS D, GroupsStudents GS, Groups AS G, GroupsLectures GL, Lectures AS L
WHERE S.[Id] = L.[SubjectId]
AND L.[Id] = GL.[LectureId]
AND GL.[GroupId] = G.[Id]
AND G.[Id] = GS.[GroupId]
AND GS.[StudentId] = St.[Id]
AND D.[Name] = 'Software Development' 




