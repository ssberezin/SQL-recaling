--Для базы данных издательства написать следующие запросы:
--1. Показать тематики книг и сумму страниц по каждой из них.
use publishing
Select t.NameTheme Theme , SUM(b.Pages) Pages
from Books b 
join Themes t on b.Id_Theme=t.Id_Theme
Group by t.NameTheme

--2. Вывести количество книг и сумму страниц этих книг по каждому из
--первых трех авторов в базе данных.
select a.FirstName+' '+a.LastName Author, Sum(b.Pages)  
From Books b 
join Authors a on b.Id_Author=a.Id_Author
and a.Id_Author in (Select top 3 a.Id_Author Id_Author from Authors a) 
Group by a.FirstName+' '+a.LastName

--3. Написать представление, которое будет отображать информацию о книгах,
--которые имели тираж более 10 экземпляров.
Create view BooksDrawing as 
Select b.NameBook Book, b.DrawingOfBook DrawingOfBook
From Books b 
Where b.DrawingOfBook>1000000

Select * from BooksDrawing
Order by DrawingOfBook 

--4. Показать на экран среднее количество страниц по каждой из тематик, при
--этом показать только тематики, в которых среднее количество более 400.

Select b.NameBook Book, t.NameTheme Theme,b.Pages AVGPages
From Books b 
join Themes t on b.Id_Theme=t.Id_Theme
join  (Select b.Id_Book Id_Book, AVG(b.Pages) AvPages from Books b group by b.Id_Book) grupped on  b.Id_Book=grupped.Id_Book
and grupped.AvPages>400
Group by b.NameBook , t.NameTheme ,b.Pages

--5. Показать количество проданных книг по каждому магазину, в промежутке
--от 01/01/2017 до сегодняшней даты.
Select sh.NameShop Shop, SUM(s.Quantity) SoldBooks
From Books b
join Sales s on s.Id_Book=b.Id_Book
join Shops sh on sh.Id_Shop=s.Id_Shop
Where s.DateOfSale>='2017-01-01' and s.DateOfSale<=GETDATE()
Group by sh.NameShop

--6. Вывести всю информацию о работе магазинов: что, когда, сколько было
--продано, а также указать страну, где находится магазин. Результат
--сохранить в другую таблицу.

select C.NameCountry Country,Sh.NameShop Shop, b.NameBook Book, s.DateOfSale DateOfSale, SUM(S.Quantity) as TotalBooksSold, SUM(S.Quantity * S.Price) as TotalMoney
FROM Sales S JOIN Shops Sh ON s.Id_Shop = Sh.Id_Shop 
join Country C on Sh.Id_Country = C.Id_Country
join Books b on s.Id_Book=b.Id_Book
GROUP BY  C.NameCountry, Sh.NameShop,b.NameBook, s.DateOfSale


--7. Написать представление, которое содержит информацию о суммах, на
--которые были проданы книги каждым магазином за последний месяц.
Create view ShopSales as 
select Sh.NameShop Shop,  SUM(S.Quantity * S.Price) as TotalMoney
FROM Sales S JOIN Shops Sh ON s.Id_Shop = Sh.Id_Shop 
Where MONTH (s.DateOfSale)= MONTH (GETDATE())
GROUP BY  Sh.NameShop, s.DateOfSale

Select * from ShopSales

--8. Написать зашифрованное представление, показывающее всех авторов,
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


--------------------------------ДЗ из урока ШАГа ------------------------------------
--1. Вывести все книги, которые продаются более чем одним магазином.
Select b.NameBook Book, count (sh.NameShop) Shop
From Books b
join Sales s on s.Id_Book=b.Id_Book
join Shops sh on sh.Id_Shop=s.Id_Shop
Group by b.NameBook
having Count(sh.NameShop)>1


--2. Вывести только тех авторов, чьи книги продаются
--больше, чем книги авторов США.
Select a.FirstName+' '+ a.LastName Author,  sum (s.Quantity)
From Authors a 
join Books b on a.Id_Author=b.Id_Author
join Sales s on s.Id_Book=b.Id_Book
join Shops sh on sh.Id_Shop=s.Id_Shop
join Country c on c.Id_Country=sh.Id_Country
where s.Quantity> (Select Sum (s.Quantity)
From Authors a 
join Books b on a.Id_Author=b.Id_Author
join Sales s on s.Id_Book=b.Id_Book
join Shops sh on sh.Id_Shop=s.Id_Shop
join Country c on c.Id_Country=sh.Id_Country
where c.NameCountry='США' )
Group by a.FirstName+' '+ a.LastName
Order by 2
--3. Вывести всех авторов, которые существуют в базе
--данных с указанием (при наличии) их книг, которые
--издаются издательством.
--4. С помощью подзапросов найдите всех авторов, которые живут в странах, где есть магазин, который продает их книги. Отсортировать выборку по фамилии
--автора.
--5. Доказать, что книги тематики, например, "Computer
--Science" выпускаются самым большим тиражом. Примечание! Доказательством будет NULL значений, иначе – книги наиболее реализуемых тематик.
--6. Сформируйте объединения из трех запросов. Первое будет выводить список авторов, тематики книг
--которых, например, 'Science Fiction'; второе – список
--авторов, которые издавали свои книги в 2014 году;
--третья выводит список самых дорогих авторов. В
--двух последних запросах сохраните дубликаты. Отсортировать выборку по фамилии автора по убыванию.
--7. Составить отчет о том, какие магазины реализовали
--наибольшее и наименьшее количество книг издательства (воспользоваться оператором UNION).29
--5. Домашнее задание
--8. Вывести имена всех авторов, книг которых не издавало еще издательство, то есть которые не присутствуют в таблице Books. (Написать два варианта запроса: один с использованием подзапросов, второй
--с использованием операторов объединения запросов).
--9. Создайте таблицу ShopAuthors, которая содержит
--следующие поля: имя и фамилия автора, название
--магазина и страна. Напишите команду, которая
--вставляла в нее всех авторов, книги которых реализуются более чем одним магазином издательства.
--10.Удалить все книги, в которых количество страниц
--больше, чем среднее.
--11.Удалить все книги, в которых не указан автор, при
--этом по результату исключить повторения.
--12.В связи с закрытием магазинов в Англии, написать
--запрос, который уничтожает информацию обо всех
--магазинах, которые там размещались.
--13.Изменить информацию о продаже книг, которые
--осуществлялись одним из магазинов в Украине, например, магазином "Hash Tag" следующим образом:
--цены на книги, которые продавались 01/07/2010 года
--увеличить на 5%, а количество увеличить на 10 ед.
--14.Уменьшить количество книг в магазинах, которые за
--последний год продали наименьшее количество книг,
--на 15