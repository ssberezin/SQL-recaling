CREATE DATABASE Academy
use Academy
CREATE TABLE Departments(
IDDepartment INT IDENTITY PRIMARY KEY NOT NULL,
DepartmentName NVARCHAR(10) NOT NULL)
INSERT INTO Departments
VALUES ('РПО'), ('КГиД'), ('СиКБ'), ('МКА')
CREATE TABLE Forms(
IDForm INT IDENTITY PRIMARY KEY NOT NULL,
Form NVARCHAR(2) NOT NULL)
INSERT INTO Forms
VALUES ('ПС'), ('С')
CREATE TABLE Groups(
IDGroup INT IDENTITY PRIMARY KEY NOT NULL,
Form INT NOT NULL FOREIGN KEY REFERENCES Forms (IDForm)
ON DELETE NO ACTION ON UPDATE CASCADE,
Department INT NOT NULL FOREIGN KEY REFERENCES Departments (IDDepartment)
ON DELETE NO ACTION ON UPDATE CASCADE,
[Year] INT NOT NULL,
Number INT NOT NULL)
INSERT INTO Groups
VALUES (1, 1, 2016, 1), (1, 1, 2016, 2), (1, 1, 2016, 3),
(2, 1, 2016, 1), (2, 2, 2016, 1), (2, 3, 2016, 1)
CREATE TABLE Students(
IDStudent INT NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(15) NOT NULL,
Surname nvarchar(20) NOT NULL,
[Group] INT FOREIGN KEY REFERENCES Groups (IDGroup),
Phone nvarchar(12)
)
INSERT INTO Students
VALUES('Иван', 'Иванов', 1, '0970000000'),
('Петр', 'Петров', 1, '0971111111'),
('Сидор', 'Сидоров', 1, '0972222222'),
('Василий', 'Васильев', 1, '0973333333'),
('Федор', 'Федоров', 1, '0974444444'),
('Яков', 'Яковлев', 1, '0975555555'),
('Дмитрий', 'Дмитриев', 2, '0670000000'),
('Сергей', 'Сергеев', 2, '0671111111'),
('Андрей', 'Андреев', 3, '0502222222'),
('Алексей', 'Алексеев', 4, '0687777777'),
('Николай', 'Николаев', 4, '0976666666'),
('Богдан', 'Богданов', 4, '0958888888'),
('Никита', 'Никитин', 4, '0673333333'),
('Иван', 'Петров', 5, NULL),
('Иван', 'Андреев', 6, '0970000000')

USE Academy
GO
CREATE PROC StudentsBriefInfo AS
Begin
SELECT Students.Name + ' ' + Students.Surname AS StudentFullName,
Forms.Form + '/' + Departments.DepartmentName + '/' + CAST(Groups.[Year]
AS nvarchar(4)) + '/' + CAST(Groups.Number AS nvarchar(1)) AS
GroupFullName
FROM Students
JOIN Groups ON Students.[Group] = Groups.IDGroup
JOIN Forms ON Groups.Form = Forms.IDForm
JOIN Departments ON Groups.Department = Departments.IDDepartment
End

CREATE PROC GroupsSummary AS
BEGIN
WITH StudentsInfo AS
(
SELECT Students.Name + ' ' + Students.Surname AS StudentFullName,
Forms.Form + '/' + Departments.DepartmentName + '/' + CAST(Groups.[Year]
AS nvarchar(4)) + '/' + CAST(Groups.Number AS nvarchar(1)) AS
GroupFullName
FROM Students
JOIN Groups ON Students.[Group] = Groups.IDGroup
JOIN Forms ON Groups.Form = Forms.IDForm
JOIN Departments ON Groups.Department = Departments.IDDepartment
)
SELECT GroupFullName AS 'Название группы', COUNT(StudentFullName) AS
'Количество студентов'
FROM StudentsInfo
GROUP BY GroupFullName
END

EXEC GroupsSummary

DROP PROCEDURE GroupsSummary

USE Academy;
GO
CREATE PROC AddStudent
@Name nvarchar(12),
@Surname nvarchar(20),
@Group INT,
@Phone nvarchar(12)
AS
INSERT INTO Students
(Name, Surname, [Group], Phone)
VALUES (@Name, @Surname, @Group, @Phone)

DECLARE @StudentName nvarchar(14);
DECLARE @StudentSurname nvarchar(20);
DECLARE @Group int, @Phone nvarchar(12);
SET @StudentName = 'Игорь'
SET @StudentSurname = 'Дмитриев'
SET @Group = 2;
SET @Phone = '0687777777'

EXEC AddStudent @StudentName, @StudentSurname, @Group, @Phone

SELECT * FROM Students

USE Academy;
GO
CREATE PROCEDURE CountInfo
@MinCount int OUTPUT,
@MaxCount int OUTPUT
AS
BEGIN
WITH StudentsInfo AS
(
SELECT Students.Name + ' ' + Students.Surname AS StudentFullName,
Forms.Form + '/' + Departments.DepartmentName + '/' + CAST(Groups.[Year] AS nvarchar(4))
+ '/' + CAST(Groups.Number AS nvarchar(1)) AS GroupFullName
FROM Students
JOIN Groups ON Students.[Group] = Groups.IDGroup
JOIN Forms ON Groups.Form = Forms.IDForm
JOIN Departments ON Groups.Department = Departments.IDDepartment
)
SELECT GroupFullName AS 'Название группы', COUNT(StudentFullName) AS 'Количество студентов'
INTO #PersonsInGroups
FROM StudentsInfo
GROUP BY GroupFullName
SELECT @MinCount = MIN([Количество студентов]), @MaxCount = MAX([Количество студентов])
FROM #PersonsInGroups
END



USE Academy;
DECLARE @Min int, @Max int
EXEC CountInfo @Min OUTPUT, @Max OUTPUT
PRINT 'Минимальное количество студентов = ' + CONVERT(NVARCHAR(1), @Min)
PRINT 'Максимальное количество студентов = ' + CONVERT(NVARCHAR(1), @Max)

USE Academy;
GO
CREATE PROC CreateStudent
@Name nvarchar(12),
@Surname nvarchar(20),
@Group INT,
@Phone nvarchar(12),
@Id int OUTPUT
AS
INSERT INTO Students
(Name, Surname, [Group], Phone)
VALUES (@Name, @Surname, @Group, @Phone)
SET @Id = @@IDENTITY

CREATE PROC AverageStudents AS
DECLARE @AvgStudents INT
BEGIN
WITH GroupsInfo AS
(
SELECT COUNT(Students.IDStudent) AS StudentsInGroup
FROM Students JOIN Groups
ON Students.[Group] = Groups.IDGroup
GROUP BY Groups.IDGroup
)
SELECT @AvgStudents = AVG(StudentsInGroup)
FROM GroupsInfo
RETURN @AvgStudents
END

USE Academy;
DECLARE @Result INT
EXEC @Result = AverageStudents
PRINT @Result