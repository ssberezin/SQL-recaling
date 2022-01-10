CREATE DATABASE Academy
use Academy
CREATE TABLE Departments(
IDDepartment INT IDENTITY PRIMARY KEY NOT NULL,
DepartmentName NVARCHAR(10) NOT NULL)
INSERT INTO Departments
VALUES ('���'), ('����'), ('����'), ('���')
CREATE TABLE Forms(
IDForm INT IDENTITY PRIMARY KEY NOT NULL,
Form NVARCHAR(2) NOT NULL)
INSERT INTO Forms
VALUES ('��'), ('�')
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
VALUES('����', '������', 1, '0970000000'),
('����', '������', 1, '0971111111'),
('�����', '�������', 1, '0972222222'),
('�������', '��������', 1, '0973333333'),
('�����', '�������', 1, '0974444444'),
('����', '�������', 1, '0975555555'),
('�������', '��������', 2, '0670000000'),
('������', '�������', 2, '0671111111'),
('������', '�������', 3, '0502222222'),
('�������', '��������', 4, '0687777777'),
('�������', '��������', 4, '0976666666'),
('������', '��������', 4, '0958888888'),
('������', '�������', 4, '0673333333'),
('����', '������', 5, NULL),
('����', '�������', 6, '0970000000')

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
SELECT GroupFullName AS '�������� ������', COUNT(StudentFullName) AS
'���������� ���������'
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
SET @StudentName = '�����'
SET @StudentSurname = '��������'
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
SELECT GroupFullName AS '�������� ������', COUNT(StudentFullName) AS '���������� ���������'
INTO #PersonsInGroups
FROM StudentsInfo
GROUP BY GroupFullName
SELECT @MinCount = MIN([���������� ���������]), @MaxCount = MAX([���������� ���������])
FROM #PersonsInGroups
END



USE Academy;
DECLARE @Min int, @Max int
EXEC CountInfo @Min OUTPUT, @Max OUTPUT
PRINT '����������� ���������� ��������� = ' + CONVERT(NVARCHAR(1), @Min)
PRINT '������������ ���������� ��������� = ' + CONVERT(NVARCHAR(1), @Max)

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