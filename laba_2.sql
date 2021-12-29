--Для базы данных издательства написать следующие запросы:
--1. Вывести информацию обо всех книгах, в имени которых больше 4-х слов.
use Publishing
With tmpTable as 
(
SELECT *
FROM BOOKs b
WHERE b.NameBook like '% % %'
)

select * from tmpTable

--2. Показать количество авторов в базе данных. Результат сохранить в другую
--таблицу.

create table ##AuthorsCount (AuthorsCount INT)

insert into ##AuthorsCount
Select Count(a.Id_Author)
From Authors a

Select * from ##AuthorsCount
--3. Показать среднеарифметическую цену продажи всех книг. Результат
--сохранить в локальную временную таблицу.
create table #AveragePrise (AvCoast money)

insert into #AveragePrise
Select AVG(b.Price)
From Books b

Select * From #AveragePrise
--4. Вывести информацию о книгах по «Computer Science» с наибольшим
--количеством страниц.

With tmpTable as 
(
Select b.NameBook as 'Название книги', b.Pages as 'Наибольшее количество странитц', t.NameTheme
From Books b
join  Themes t  on b.Id_Theme = t.Id_Theme
where t.NameTheme='Детектив' and b.Pages = 
(SELECT MAX(b.Pages)
FROM Books b
join  Themes t  on b.Id_Theme = t.Id_Theme
where t.NameTheme='Детектив'
)
Group by b.NameBook,b.Pages, t.NameTheme
)

select * from tmpTable

-- тут найдены книги с максималбным кол-волм страниц по каждому жанру 

With tmpTable  as 
(
Select b.NameBook as 'Название книги', b.Pages as 'Наибольшее количество странитц', t.NameTheme
From Books b
join  Themes t  on b.Id_Theme = t.Id_Theme
join
(SELECT MAX(b.Pages) as pages, t.NameTheme
FROM Books b
join  Themes t  on b.Id_Theme = t.Id_Theme
Group by t.NameTheme) groupedb
on b.Pages=groupedb.pages and t.NameTheme=groupedb.NameTheme

Group by   b.Pages  , t.NameTheme, b.NameBook
)

select * from tmpTable

--5. Показать авторов и самую старую книгу по каждому из них. Результат
--сохранить в глобальную временную таблицу.

create table ##AuthorBooks (BookName nvarchar(30),Author nvarchar (30), DateOfPublishing date )

insert into ##AuthorBooks
Select b.NameBook as 'Книга',a.FirstName+' ' +a.LastName  as 'Автор',  b.DateOfPublish as 'Дата публикации'
From Books b
join Authors a on b.Id_Author=a.Id_Author
join (Select a.FirstName+' ' +a.LastName  as 'Author',  MIN (b.DateOfPublish) as 'DateOfPublishing'
From Books b
join Authors a on b.Id_Author=a.Id_Author
Group by a.FirstName+' ' +a.LastName 
) groupeda
on b.DateOfPublish=groupeda.DateOfPublishing
and a.FirstName+' '+a.LastName=groupeda.Author
Group by  b.NameBook,a.FirstName+' ' +a.LastName,b.DateOfPublish 

Select * from ##AuthorBooks

--6. Показать на экран сумму страниц по каждой из тематик, при этом
--учитывать только книги одной из следующих тематик: «Computer
--Science», «Science Fiction», «Web Technologies» и с количеством страниц
--более 300.
With tmpTable  as 
(
SELECT SUM(b.Pages) SumPages,t.NameTheme Theme
FROM Themes t 
join Books b on b.Id_Theme=t.Id_Theme
Where t.NameTheme in ('Детектив' ,'Проза')
Group by t.NameTheme
having sum(b.Pages)>300
)
select * from tmpTable

--7. Найти авторов, живущих в тех странах, где есть хотя бы один из
--магазинов по распространению книг, занесенных в БД. Результат запроса
--поместить в отдельное представление.
CREATE VIEW AuthorsCountriesShops (AuthorName, Country,Shop) as
Select a.FirstName+' '+a.LastName Author, c.NameCountry Country, sh.NameShop
From Authors a
join Country c on c.Id_Country=a.Id_Country
join Shops sh on sh.Id_Country=c.Id_Country
Group by a.FirstName+' '+a.LastName, c.NameCountry, sh.NameShop

Select * From AuthorsCountriesShops

--8. Написать представление, содержащее самую дорогую книгу тематики,
--например, «Web Technologies».

CREATE VIEW AuthorMostExpansiveBooks (BookName ,Author ,Price ) as
Select b.NameBook as 'Книга',a.FirstName+' ' +a.LastName  as 'Автор',  b.Price as 'Цена'
From Books b
join Authors a on b.Id_Author=a.Id_Author
join (Select a.FirstName+' ' +a.LastName  as 'Author',  Max (b.Price) as 'Price'
From Books b
join Authors a on b.Id_Author=a.Id_Author
Group by a.FirstName+' ' +a.LastName 
) groupeda
on b.Price=groupeda.Price
and a.FirstName+' '+a.LastName=groupeda.Author
Group by  b.NameBook,a.FirstName+' ' +a.LastName,b.Price 

Select * from AuthorMostExpansiveBooks
Order by Price desc

--9. Написать представление, которое позволяет вывести всю информацию о
--работе магазинов. Отсортировать выборку по странам в возрастающем и
--по названиям магазинов в убывающем порядке.


create view ShopsTotalInfo as 
select Sh.NameShop, C.NameCountry, SUM(S.Quantity) as TotalBooksSold, SUM(S.Quantity * S.Price) as TotalMoney
FROM Sales S JOIN Shops Sh ON s.Id_Shop = Sh.Id_Shop 
join Country C on Sh.Id_Country = C.Id_Country
GROUP BY Sh.NameShop, C.NameCountry

SELECT * FROM ShopsTotalInfo
ORDER BY NameCountry, NameShop DESC
--10.Написать зашифрованное представление, показывающее самую
--популярную книгу.

create view EncryptView WITH ENCRYPTION AS 
Select b.NameBook Book, s.Quantity TotalBookSold
From Books b join Sales s on b.Id_Book=s.Id_Book
where s.Quantity=(Select Max(s.Quantity) From Sales s)
group by b.NameBook , s.Quantity 

select * from EncryptView 

--11. Написать модифицированное представление, в котором предоставляется
--информация об авторах, имена которых начинаются с А или В.

create view ABAuthorsInfo as
SELECT a.FirstName+' '+a.LastName Author
FROM  Authors a 
Where a.FirstName like 'А%' or a.FirstName like 'Г%' 

select * from ABAuthorsInfo
Order by Author


--12.Написать представление, в котором с помощью подзапросов вывести
--названия магазинов, которые еще не продают книги вашего издательства.

Select sh.NameShop Shop
From Shops sh join Sales s on s.Id_Shop=sh.Id_Shop
Where s.Quantity=0