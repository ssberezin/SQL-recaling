--ƒл€ базы данных издательства написать следующие запросы:
--1. ѕоказать тематики книг и сумму страниц по каждой из них.
use publishing
Select t.NameTheme Theme , SUM(b.Pages) Pages
from Books b 
join Themes t on b.Id_Theme=t.Id_Theme
Group by t.NameTheme

--2. ¬ывести количество книг и сумму страниц этих книг по каждому из
--первых трех авторов в базе данных.
select a.FirstName+' '+a.LastName Author, Sum(b.Pages)  
From Books b 
join Authors a on b.Id_Author=a.Id_Author
and a.Id_Author in (Select top 3 a.Id_Author Id_Author from Authors a) 
Group by a.FirstName+' '+a.LastName

--3. Ќаписать представление, которое будет отображать информацию о книгах,
--которые имели тираж более 10 экземпл€ров.
Create view BooksDrawing as 
Select b.NameBook Book, b.DrawingOfBook DrawingOfBook
From Books b 
Where b.DrawingOfBook>1000000

Select * from BooksDrawing
Order by DrawingOfBook 

--4. ѕоказать на экран среднее количество страниц по каждой из тематик, при
--этом показать только тематики, в которых среднее количество более 400.

Select b.NameBook Book, t.NameTheme Theme,b.Pages AVGPages
From Books b 
join Themes t on b.Id_Theme=t.Id_Theme
join  (Select b.Id_Book Id_Book, AVG(b.Pages) AvPages from Books b group by b.Id_Book) grupped on  b.Id_Book=grupped.Id_Book
and grupped.AvPages>400
Group by b.NameBook , t.NameTheme ,b.Pages

--5. ѕоказать количество проданных книг по каждому магазину, в промежутке
--от 01/01/2017 до сегодн€шней даты.
Select sh.NameShop Shop, SUM(s.Quantity) SoldBooks
From Books b
join Sales s on s.Id_Book=b.Id_Book
join Shops sh on sh.Id_Shop=s.Id_Shop
Where s.DateOfSale>='2017-01-01' and s.DateOfSale<=GETDATE()
Group by sh.NameShop

--6. ¬ывести всю информацию о работе магазинов: что, когда, сколько было
--продано, а также указать страну, где находитс€ магазин. –езультат
--сохранить в другую таблицу.

select C.NameCountry Country,Sh.NameShop Shop, b.NameBook Book, s.DateOfSale DateOfSale, SUM(S.Quantity) as TotalBooksSold, SUM(S.Quantity * S.Price) as TotalMoney
FROM Sales S JOIN Shops Sh ON s.Id_Shop = Sh.Id_Shop 
join Country C on Sh.Id_Country = C.Id_Country
join Books b on s.Id_Book=b.Id_Book
GROUP BY  C.NameCountry, Sh.NameShop,b.NameBook, s.DateOfSale


--7. Ќаписать представление, которое содержит информацию о суммах, на
--которые были проданы книги каждым магазином за последний мес€ц.
Create view ShopSales as 
select Sh.NameShop Shop,  SUM(S.Quantity * S.Price) as TotalMoney
FROM Sales S JOIN Shops Sh ON s.Id_Shop = Sh.Id_Shop 
Where MONTH (s.DateOfSale)= MONTH (GETDATE())
GROUP BY  Sh.NameShop, s.DateOfSale

Select * from ShopSales

--8. Ќаписать зашифрованное представление, показывающее всех авторов,
--количество проданных книг которых больше 20.

create view TwentyAuthorsBooks WITH ENCRYPTION AS 
Select a.FirstName +' '+a.LastName Author, grupped.BooksCount BooksCount
From Authors a 
join Books b on b.Id_Author=a.Id_Author
join (Select a.Id_Author Id_Author, Count(b.Id_Book) BooksCount
From Authors a nm 
join Books b on b.Id_Author=a.Id_Author 
group by a.Id_Author) grupped on b.Id_Author=grupped.Id_Author
Where grupped.BooksCount>2
Group by a.FirstName +' '+a.LastName,grupped.BooksCount

Select * from TwentyAuthorsBooks
