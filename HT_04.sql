--��� ���� ������ ������������ �������� ��������� �������:
--1. �������� ��������� ��� ������� ���������� �����.
--�����.
go
CREATE PROC Factorial

@First int,
@Result int Output

AS
Begin
declare @i int set @i=1
declare @P int set @P=1

while @i<@First
begin
	set @P=@P*@i;
	set @i=@i+1;
end
Set @Result=@P
End

	

Declare @Res int
EXEC Factorial 7, @Res Output
Print @Res

USE Publishing;
GO

--2. �������� �������� ���������, ������� ��������� ��������� ����
--������������ ������ �����, ������� ������������� ������� �� 2 ����.
--������ ���������� � �������� ��������� � ���������.

Create proc UpdByPattern
@Pattern nvarchar (6)
as
begin
Update Books
Set DateOfPublish=DATEADD(year,2,DateOfPublish)
where NameBook like @Pattern
end

exec UpdByPattern '%��%'
Select * from Books
--3. �������� �������� ���������, ������� ����� ���������� ����������
--��� ���� ������� �� ������������ ������, �������� ������� ���������� �
--��������� ��� ������.

Go
Create Proc AuthorsCountry
@InputCountryName nvarchar(40)
 as
Begin
Select Authors.FirstName+' '+Authors.LastName Author, Country.NameCountry country
From Books 
join Authors on Books.Id_Author=Authors.Id_Author 
join Sales on Sales.Id_Book=Books.Id_Book 
join Shops on Shops.Id_Shop=Sales.Id_Shop 
join Country on Country.Id_Country=Shops.Id_Country
Where Country.NameCountry=@InputCountryName
Group by Country.NameCountry , Authors.FirstName+' '+Authors.LastName 
end

use Publishing
exec AuthorsCountry '���'

--4. �������� �������� ��������� ��� ������� �������� ���������� �������
--�� ���� ������, �������� ������������� �� ������������ ������
--(��������� � �������� ���� ���������� � ��������� ��� ������).
go
Create Proc AVGBookPagesByDate 
@Startdate1 date,
@EndDate1 date,
@Result int Output
as
begin
if (@Startdate1>GETDATE())
		RAISERROR ('��������� ���� ������ �������. ���������',15, 3)
else
	if (@Startdate1>@EndDate1)
		RAISERROR ('��������� ���� ������ ���������',15, 1)
	else
		if (@Startdate1=@EndDate1)
			RAISERROR ('��������� � �������� ���� �����,���������',15, 2)
		else
With Info as (
Select  AVG (books.Pages) AVGPages
From Books 
where Books.DateOfPublish>=@StartDate1 and Books.DateOfPublish<=@Enddate1)
Select @Result = Info.AVGPages
From Info
end

use Publishing
declare @Res3 int
exec AVGBookPagesByDate '2012.05.04', '2018.05.04', @Res3 output

print @Res3

--5. �������� �������� ���������, ������� ��������� �������� ����������
--� ������, �������� � ��������� ���� (��� ���������� � ��������� ���
--��������).

go
Create Proc BooksByYear
@Year int
as
begin
Select Books.NameBook Book, Books.DateOfPublish PublDate
From Books 
where Year(Books.DateOfPublish)=@Year
end

use Publishing
declare @Year1 int
exec BooksByYear 2018


