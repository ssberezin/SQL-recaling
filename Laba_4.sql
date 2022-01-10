--Тема: Хранимые процедуры
--Для базы данных издательства написать следующие запросы:
--1. Создать хранимую процедуру, которая возвращает максимальное из двух
--чисел.
USE Publishing;
GO

CREATE PROC MaxOfTwo 
@First int,
@Second int,
@Result int Output

AS
Begin
if @First>@Second	
	Set @Result=@First
else
	if @First<=@Second
	   Set @Result=@Second
End

	

Declare @Max int
EXEC MaxOfTwo 3,3, @Max Output
Print @Max


--2. Создать хранимую процедуру, которая выводит на экран список
--магазинов, которые продали хотя бы одну книгу Вашего издательства.
--Указать также месторасположение (страну) магазина.

use Publishing
Go
Create Proc ShopInfo as
Begin
Select Shops.NameShop Shop, Country.NameCountry Country
From Books 
join Sales on Books.Id_Book=Sales.Id_Book
join Shops on Shops.Id_Shop=Sales.Id_Shop
Join Country on Country.Id_Country=Shops.Id_Country
Where Sales.Quantity>0
Group by Country.NameCountry, Shops.NameShop
End

Exec ShopInfo
--3. Написать процедуру, позволяющую просмотреть все книги определенного
--автора, при этом его имя передается при вызове.

Go
Create Proc AuthorsBooks
@InputName nvarchar(40)
 as
Begin
Select Authors.FirstName+' '+Authors.LastName Author, Books.NameBook book
From Books 
join Authors on Books.Id_Author=Authors.Id_Author
Where Authors.FirstName=@InputName or Authors.LastName=@InputName
Group by Authors.FirstName+' '+Authors.LastName , Books.NameBook
end

use Publishing
exec AuthorsBooks 'Годман'

--4. Написать процедуру, которая выводит на экран книги и цены по указанной
--тематике. При этом необходимо указывать направление сортировки: 0 – по
--цене, по росту, 1 – по убыванию, любое другое – без сортировки.
go
Create Proc BookThemePriceInfo
@InputTheme nvarchar (30),
@SortWay int
as
Begin
Select Books.NameBook Book, Books.Price Price
From Books 
join Themes on Themes.Id_Theme=Books.Id_Theme
Where Themes.NameTheme= @InputTheme
Order By 
case (@SortWay)
when 0 then Books.Price end,
case (@SortWay)
when 1 then Books.Price end desc
end

Exec BookThemePriceInfo 'Детектив',3

--5. Написать процедуру, которая возвращает полное имя автора, книг
--которого больше всех было издано.

go
Create proc GetMaxAuthorAndBooks
@MaxAuthor nvarchar (60) Output,
@MaxBooks Int Output
as
begin
with Info as
(Select  Authors.FirstName+ ' '+ Authors.LastName Author, Sum(Books.DrawingOfBook) BooksQuantity
From Authors join Books on Authors.Id_Author=Books.Id_Book 
Group by Authors.FirstName+ ' '+ Authors.LastName
Having Sum(Books.DrawingOfBook)=
(Select  max (Books.DrawingOfBook) MaxQuantity
From Books)) 
Select @MaxAuthor=Info.Author, @MaxBooks=Info.BooksQuantity
From Info
end


use Publishing
Declare @MaxAuthor2 nvarchar(60), @Max int
Exec  GetMaxAuthorAndBooks @MaxAuthor2 OutPut, @Max output

Print 'Самый пресамы автор: '+  CONVERT (NVARCHAR(60),@MaxAuthor2)
Print 'И вот стоко у него книг: '+  CONVERT (NVARCHAR(10), @Max)

--6. Написать хранимую процедуру с параметрами, определяющими диапазон
--дат выпуска книг. Процедура позволяет обновить данные о тираже
--выпуска книг по следующим условиям:
-- Если дата выпуска книги находится в определенном диапазоне,
--тогда тираж нужно увеличить в два раза, а цену за единицу
--увеличить на 20%;
-- Если дата выпуска книги не входит в диапазон, тогда тираж
--оставить без изменений.
--Предусмотреть вывод на экран соответствующих сообщений об
--ошибке, если передаваемые даты одинаковые, или конечная дата
--промежутка меньше начала, или же начальная больше текущей даты.
go
Create proc GetBooksByDate
@StartDate date, 
@EndDate date
as
begin
if (@StartDate>GETDATE())
		RAISERROR ('Стартовая дата больше текущей. непорядок',15, 3)
else
	if (@StartDate>@EndDate)
		RAISERROR ('Стартовая дата больше начальной',15, 1)
	else
		if (@StartDate=@EndDate)
			RAISERROR ('стартовая и конечная даты равны,непорядок',15, 2)
		else
	Update Books 
	Set DrawingOfBook=DrawingOfBook*2, Price=Price*1.2
	where DateOfPublish<=@Startdate and DateOfPublish>=@EndDate
end


exec GetBooksByDate  '2025.05.04', '2018.05.04'
SELECT * FROM Books