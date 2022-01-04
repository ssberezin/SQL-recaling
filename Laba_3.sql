---Lab 3---
use publishing
--1. ������� ������������ �� ���� �����, �������� � ����������.
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

--2. ���������� ��������� ����� 7.
declare @i int set @i=1
declare @P int set @P=1
while @i<7
begin
	set @P=@P*@i;
	set @i=@i+1;
end
Print '7! = '+ RTRIM(CAST(@P AS NVARCHAR(10)))  

--3. ���������� ����� ���� ������ ����� �� 30 ������������.
declare @S int set @S=0
declare @j int set @j=2
while @j<=30
begin
if @j%2=0	   
	set @S=@S+@j	 
  set @j=@j+1;
end
Print '����� ���� ������ ����� �� 30:  '+ RTRIM(CAST(@S AS NVARCHAR(5)))  	

--4. �������� �������������, � ������� ���������� ������� ��������
--��������� � ��������� �� ����� ������������. ��� ���� ������� �������
--�������� ������ ������ � � ����������� ���� (��������, United States �
--US).

create view ShopShortCountryname as
Select 'Shop'=sh.NameShop , c.NameCountry Country, 'ShortCountryName'  = 
case c.NameCountry
	when '�������' then 'UA' 
	when '��������������' then 'GB'
	when '��������' then 'GE'
	when '������' then 'GEO'
	when '���' then 'US'
	when '�������' then 'FR'
	when '���������' then 'SWZLD'
	when '������' then 'SWLD'
end
From Country c 
join Shops sh on c.Id_Country=sh.Id_Country

Select * from ShopShortCountryname
--5. ������� ��������� ����������, � ������� �������� ����� ����������
--������ � ���� ��������� ���������� ��� ������� ��������.
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


--6. �������� ������, ������� �������� ������ � ������� Books ���������
--�������: ���� ����� ���� ������ ����� 2008 ����, ����� �� �����
--��������� �� 1000 �����������, ����� ����� ��������� �� 100 ��.
--(��������������� ����������� CASE).

SELECT B.NameBook BOOK, B.DateOfPublish  DateOfPublish, B.DrawingOfBook
FROM Books B


UPDATE Books SET DrawingOfBook=
CASE 
	WHEN year (DateOfPublish)>20018 then DrawingOfBook+1000
	else DrawingOfBook+100
end

--7. ������� �������������, � ������� ������������ ���������� � �����
--(��������, ��� ������). � �������������� ���� ���������� ���������
--����������:
--a. ���� ���������� ��������� ����������� ������ ����� ������ 100,
--�������� � ���� �����������;
--b. ���� � ������� ������ ����� ������ ������ ������ � ��������
--��������.

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
