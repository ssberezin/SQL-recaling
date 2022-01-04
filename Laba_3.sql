---Lab 3---
use publishing
--1. Вывести максимальное из двух чисел, хранимых в переменных.
declare @var int, @var2 int
set @var=5
select @var2=6
if (@var>@var2)
	begin
	 Print 'var>var2'
	end
else if(@var=@var2)
		begin
			Print 'var=var2'
		end
	else
		begin
			Print 'var<var2'
		end

--2. Рассчитать факториал числа 7.
declare @i int set @i=1
declare @P int set @P=1
while @i<7
begin
	set @P=@P*@i;
	set @i=@i+1;
end
Print '7! = '+ RTRIM(CAST(@P AS NVARCHAR(10)))  

--3. Рассчитать сумму всех парных чисел до 30 включительно.
declare @S int set @S=0
declare @j int set @j=2
while @j<=30
begin
if @j%2=0	   
	set @S=@S+@j	 
  set @j=@j+1;
end
Print 'Сумма всех четных чисел до 30:  '+ RTRIM(CAST(@S AS NVARCHAR(5)))  	

--4. Написать представление, в котором необходимо вывести перечень
--магазинов с указанием их места расположения. При этом следует вывести
--название страны полное и в сокращенном виде (например, United States –
--US).

create view ShopShortCountryname as
Select 'Shop'=sh.NameShop , c.NameCountry Country, 'ShortCountryName'  = 
case c.NameCountry
	when 'Украина' then 'UA' 
	when 'Великобритания' then 'GB'
	when 'Германия' then 'GE'
	when 'Грузия' then 'GEO'
	when 'США' then 'US'
	when 'Франция' then 'FR'
	when 'Швейцария' then 'SWZLD'
	when 'Швеция' then 'SWLD'
end
From Country c 
join Shops sh on c.Id_Country=sh.Id_Country

Select * from ShopShortCountryname
--5. Создать табличную переменную, в которую записать общее количество
--продаж и дату последней реализации для каждого магазина.
declare @Total table
(Shop nvarchar(30), Amount int,[Date] date)
insert @Total

Select sh.NameShop Shop, sum(s.Quantity) Quantuty, s.DateOfSale DateOfSale
From Shops sh 
join Sales s on sh.Id_Shop=s.Id_Shop
join (Select sh.Id_Shop Id_Shop, max(s.DateOfSale) MaxDate
From Shops sh 
join Sales s on sh.Id_Shop=s.Id_Shop
Group by  sh.Id_Shop) Groupped on Groupped.MaxDate=s.DateOfSale
Group by sh.NameShop , s.DateOfSale

Select * from @Total


--6. Написать запрос, который изменяет данные в таблице Books следующим
--образом: если книги были изданы после 2008 года, тогда их тираж
--увеличить на 1000 экземпляров, иначе тираж увеличить на 100 ед.
--(воспользоваться инструкцией CASE).

SELECT B.NameBook BOOK, B.DateOfPublish  DateOfPublish, B.DrawingOfBook
FROM Books B


UPDATE Books SET DrawingOfBook=
CASE 
	WHEN year (DateOfPublish)>20018 then DrawingOfBook+1000
	else DrawingOfBook+100
end

--7. Создать представление, в котором отображается информация о книге
--(название, ФИО автора). В дополнительном поле отобразить следующую
--информацию:
--a. если количество проданных экземпляров данной книги больше 100,
--записать в поле «Бестселлер»;
--b. если с момента выхода книги прошло меньше месяца – записать
--«Новинка».

Select a.FirstName+' '+a.LastName Author, b.NameBook Book, 
'DateOfPublishing' = 
case  
	when b.DateOfPublish > DATEADD(day,-30, GetDate()) then 'New one!'
	else  Convert (nvarchar,b.DateOfPublish,23) 
end,
'DrawingOfBook' = 
case 
	when b.DrawingOfBook>100000 then 'Bestsaller'
	else Cast (b.DrawingOfBook as nvarchar (30))
end

From Books b
join Authors a on a.Id_Author=b.Id_Author
Order by  'Author', 'Book' ,'DateOfPublishing', 'DrawingOfBook'
