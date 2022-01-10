--ƒл€ базы данных издательства написать следующие запросы:
--1. Ќаписать процедуру дл€ расчета факториала числа.
--чисел.
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

--2. Ќаписать хранимую процедуру, котора€ позвол€ет увеличить дату
--издательства каждой книги, котора€ соответствует шаблону на 2 года.
--Ўаблон передаетс€ в качестве параметра в процедуру.

Create proc UpdByPattern
@Pattern nvarchar (6)
as
begin
Update Books
Set DateOfPublish=DATEADD(year,2,DateOfPublish)
where NameBook like @Pattern
end

exec UpdByPattern '%Ўа%'
Select * from Books
--3. Ќаписать хранимую процедуру, которое будет отображать информацию
--обо всех авторах из определенной страны, название которой передаетс€ в
--процедуру при вызове.

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
exec AuthorsCountry '—Ўј'

--4. Ќаписать хранимую процедуру дл€ расчета среднего количества страниц
--во всех книгах, изданных издательством за определенный период
--(начальна€ и конечна€ дата передаютс€ в процедуру при вызове).
go
Create Proc AVGBookPagesByDate 
@Startdate1 date,
@EndDate1 date,
@Result int Output
as
begin
if (@Startdate1>GETDATE())
		RAISERROR ('—тартова€ дата больше текущей. непор€док',15, 3)
else
	if (@Startdate1>@EndDate1)
		RAISERROR ('—тартова€ дата больше начальной',15, 1)
	else
		if (@Startdate1=@EndDate1)
			RAISERROR ('стартова€ и конечна€ даты равны,непор€док',15, 2)
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

--5. Ќаписать хранимую процедуру, котора€ позвол€ет получить информацию
--о книгах, изданных в указанном году (год передаетс€ в процедуру как
--параметр).

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


