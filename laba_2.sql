--��� ���� ������ ������������ �������� ��������� �������:
--1. ������� ���������� ��� ���� ������, � ����� ������� ������ 4-� ����.
use Publishing
With tmpTable as 
(
SELECT *
FROM BOOKs b
WHERE b.NameBook like '% % %'
)

select * from tmpTable

--2. �������� ���������� ������� � ���� ������. ��������� ��������� � ������
--�������.

create table ##AuthorsCount (AuthorsCount INT)

insert into ##AuthorsCount
Select Count(a.Id_Author)
From Authors a

Select * from ##AuthorsCount
--3. �������� �������������������� ���� ������� ���� ����. ���������
--��������� � ��������� ��������� �������.
create table #AveragePrise (AvCoast money)

insert into #AveragePrise
Select AVG(b.Price)
From Books b

Select * From #AveragePrise
--4. ������� ���������� � ������ �� �Computer Science� � ����������
--����������� �������.

With tmpTable as 
(
Select b.NameBook as '�������� �����', b.Pages as '���������� ���������� ��������', t.NameTheme
From Books b
join  Themes t  on b.Id_Theme = t.Id_Theme
where t.NameTheme='��������' and b.Pages = 
(SELECT MAX(b.Pages)
FROM Books b
join  Themes t  on b.Id_Theme = t.Id_Theme
where t.NameTheme='��������'
)
Group by b.NameBook,b.Pages, t.NameTheme
)

select * from tmpTable

-- ��� ������� ����� � ������������ ���-���� ������� �� ������� ����� 

With tmpTable  as 
(
Select b.NameBook as '�������� �����', b.Pages as '���������� ���������� ��������', t.NameTheme
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

--5. �������� ������� � ����� ������ ����� �� ������� �� ���. ���������
--��������� � ���������� ��������� �������.

create table ##AuthorBooks (BookName nvarchar(30),Author nvarchar (30), DateOfPublishing date )

insert into ##AuthorBooks
Select b.NameBook as '�����',a.FirstName+' ' +a.LastName  as '�����',  b.DateOfPublish as '���� ����������'
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

--6. �������� �� ����� ����� ������� �� ������ �� �������, ��� ����
--��������� ������ ����� ����� �� ��������� �������: �Computer
--Science�, �Science Fiction�, �Web Technologies� � � ����������� �������
--����� 300.
With tmpTable  as 
(
SELECT SUM(b.Pages) SumPages,t.NameTheme Theme
FROM Themes t 
join Books b on b.Id_Theme=t.Id_Theme
Where t.NameTheme in ('��������' ,'�����')
Group by t.NameTheme
having sum(b.Pages)>300
)
select * from tmpTable

--7. ����� �������, ������� � ��� �������, ��� ���� ���� �� ���� ��
--��������� �� ��������������� ����, ���������� � ��. ��������� �������
--��������� � ��������� �������������.
CREATE VIEW AuthorsCountriesShops (AuthorName, Country,Shop) as
Select a.FirstName+' '+a.LastName Author, c.NameCountry Country, sh.NameShop
From Authors a
join Country c on c.Id_Country=a.Id_Country
join Shops sh on sh.Id_Country=c.Id_Country
Group by a.FirstName+' '+a.LastName, c.NameCountry, sh.NameShop

Select * From AuthorsCountriesShops

--8. �������� �������������, ���������� ����� ������� ����� ��������,
--��������, �Web Technologies�.

CREATE VIEW AuthorMostExpansiveBooks (BookName ,Author ,Price ) as
Select b.NameBook as '�����',a.FirstName+' ' +a.LastName  as '�����',  b.Price as '����'
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

--9. �������� �������������, ������� ��������� ������� ��� ���������� �
--������ ���������. ������������� ������� �� ������� � ������������ �
--�� ��������� ��������� � ��������� �������.


--10.�������� ������������� �������������, ������������ �����
--���������� �����.
--11. �������� ���������������� �������������, � ������� ���������������
--���������� �� �������, ����� ������� ���������� � � ��� �.
--12.�������� �������������, � ������� � ������� ����������� �������
--�������� ���������, ������� ��� �� ������� ����� ������ ������������.