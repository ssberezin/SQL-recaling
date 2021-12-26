--Для базы данных издательства написать следующие запросы:
--1. Вывести информацию обо всех книгах, в имени которых больше 4-х слов.
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
--https://stackoverflow.com/questions/612231/how-can-i-select-rows-with-maxcolumn-value-partition-by-another-column-in-mys
With tmpTable2 (BookName , Theme, Pages ) as 
(
SELECT b.*, t.NameTheme
FROM BOOKs b
join Themes t on t.Id_Theme=b.Id_Theme
join 
(Select b.NameBook,  MAX(b.Pages) as Maxpages
from books b
join Themes t on b.Id_Theme=t.Id_Theme 
Group by b.NameBook
) groupedb
on b.NameBook = groupedb.NameBook
 and b.Pages=groupedb.Maxpages




--Group by b.NameBook,t.NameTheme, b.Pages
)



select * from tmpTable2

--5. Показать авторов и самую старую книгу по каждому из них. Результат
--сохранить в глобальную временную таблицу.
--6. Показать на экран сумму страниц по каждой из тематик, при этом
--учитывать только книги одной из следующих тематик: «Computer
--Science», «Science Fiction», «Web Technologies» и с количеством страниц
--более 300.
--7. Найти авторов, живущих в тех странах, где есть хотя бы один из
--магазинов по распространению книг, занесенных в БД. Результат запроса
--поместить в отдельное представление.
--8. Написать представление, содержащее самую дорогую книгу тематики,
--например, «Web Technologies».
--9. Написать представление, которое позволяет вывести всю информацию о
--работе магазинов. Отсортировать выборку по странам в возрастающем и
--по названиям магазинов в убывающем порядке.
--10.Написать зашифрованное представление, показывающее самую
--популярную книгу.
--11. Написать модифицированное представление, в котором предоставляется
--информация об авторах, имена которых начинаются с А или В.
--12.Написать представление, в котором с помощью подзапросов вывести
--названия магазинов, которые еще не продают книги вашего издательства.