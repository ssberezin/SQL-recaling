--1.	Показать все книги трех произвольных авторов.
use Publishing


SELECT b.NameBook as 'Book', a.LastName+' '+a.FirstName as 'Автор' 
FROM
Books b join Authors a on b.Id_Author=a.Id_Author
WHERE a.Id_Author in
(SELECT top 3 
a.Id_Author 
FROM Authors a 
ORDER BY RAND()
)
Order by 'Автор','Book'


--2.	Показать все книги, в которых количество страниц больше 500, но меньше 650. 

Select Books.NameBook , Books.Pages
from Books
where Books.Pages>500 and Books.Pages<=650

--3.	Необходимо вывести все названия книг, в которых первая буква или А, или С. 
SELECT b.NameBook as 'Book' 
FROM Books b
where b.NameBook like 'А%' or b.NameBook like 'Л%'
Group by b.NameBook

--4.	Показать названия книг, тематика которых не "Science Fiction" и тираж которых >=20 экземпляров.
Select b.NameBook, t.NameTheme, b.DrawingOfBook
From Books b join Themes t on b.Id_Theme = t.Id_Theme
where t.NameTheme!='Детектив' and b.DrawingOfBook >=100000
Group by t.NameTheme, b.NameBook, b.DrawingOfBook

--5.	Показать все книги-новинки, цена которых ниже $30. (Новинкой будет считаться книга, которая была издана на протяжении последней недели).
select b.NameBook, b.DateOfPublish, b.Price
from Books b
where b.Price <250 and   DATEDIFF(day,b.DateOfPublish, getdate() )<=7
Group by  b.NameBook, b.DateOfPublish, b.Price

--6.	Показать книги, в названиях которых есть слово "Microsoft", но нет слова "Windows".
select b.NameBook
from Books b
where b.NameBook like 'Шашлык' and b.NameBook NOT LIKE '%2'

--7.	Вывести названия книг, тематику, автора (полное имя), цена одной страницы которых менее 10 центов.
Select b.NameBook Book, a.FirstName+' '+a.LastName Author, t.NameTheme Theme, b.Price/b.Pages 'Price per page'
From Books b 
join Authors a on b.Id_Author=a.Id_Author 
join Themes t on b.Id_Theme=t.Id_Theme
Where b.Price/b.Pages <0.4


--8.	Вывести на экран все книги, их авторов и цены их продажи в у.е., дата продажи которых находится в диапазоне 01/01/2017 по сегодняшнюю дату.
Select a.FirstName+' '+a.LastName Author,b.NameBook Book, b.Price Price, s.DateOfSale DateOfSale
From Books b 
join Authors a on b.Id_Author=a.Id_Author
join Sales s on s.Id_Book=b.Id_Book
Where s.DateOfSale >='2017-01-01' and s.DateOfSale<=GETDATE()
Group by a.FirstName+' '+a.LastName,b.NameBook, b.Price , s.DateOfSale 


--9.	Показать всю информацию по продажам книг тематики «Computer Science» магазинами, которые находятся не в Украине и не в Канаде. Информацию представить в следующем виде: 
--•	название книги;
--•	автор книги (полное имя);
--•	количество продаж данной книги;
--•	название магазина.
Select b.NameBook Book,t.NameTheme Theme, a.FirstName+' '+a.LastName Author, s.Quantity SaleQuantity, sh.NameShop Shop, c.NameCountry Country
From Books b 
join Authors a on a.Id_Author=b.Id_Author
join Themes t on b.Id_Theme = t.Id_Theme
join Sales s on s.Id_Book=b.Id_Book
join Shops sh on sh.Id_Shop=s.Id_Shop
join Country c on c.Id_Country=sh.Id_Country
where t.NameTheme = 'Детектив' and c.NameCountry!='Украина' and c.NameCountry!='Канада'
Group by b.NameBook, t.NameTheme , a.FirstName+' '+a.LastName, s.Quantity , sh.NameShop , c.NameCountry

--10.	Показать все магазины из Украины.

Select sh.NameShop Shop, c.NameCountry Country
From Shops sh 
join Country c on sh.Id_Country=c.Id_Country
Where c.NameCountry='Украина'
 
