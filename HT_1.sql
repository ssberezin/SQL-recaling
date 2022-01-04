--1.	�������� ��� ����� ���� ������������ �������.
use Publishing


SELECT b.NameBook as 'Book', a.LastName+' '+a.FirstName as '�����' 
FROM
Books b join Authors a on b.Id_Author=a.Id_Author
WHERE a.Id_Author in
(SELECT top 3 
a.Id_Author 
FROM Authors a 
ORDER BY RAND()
)
Order by '�����','Book'


--2.	�������� ��� �����, � ������� ���������� ������� ������ 500, �� ������ 650. 

Select Books.NameBook , Books.Pages
from Books
where Books.Pages>500 and Books.Pages<=650

--3.	���������� ������� ��� �������� ����, � ������� ������ ����� ��� �, ��� �. 
SELECT b.NameBook as 'Book' 
FROM Books b
where b.NameBook like '�%' or b.NameBook like '�%'
Group by b.NameBook

--4.	�������� �������� ����, �������� ������� �� "Science Fiction" � ����� ������� >=20 �����������.
Select b.NameBook, t.NameTheme, b.DrawingOfBook
From Books b join Themes t on b.Id_Theme = t.Id_Theme
where t.NameTheme!='��������' and b.DrawingOfBook >=100000
Group by t.NameTheme, b.NameBook, b.DrawingOfBook

--5.	�������� ��� �����-�������, ���� ������� ���� $30. (�������� ����� ��������� �����, ������� ���� ������ �� ���������� ��������� ������).
select b.NameBook, b.DateOfPublish, b.Price
from Books b
where b.Price <250 and   DATEDIFF(day,b.DateOfPublish, getdate() )<=7
Group by  b.NameBook, b.DateOfPublish, b.Price

--6.	�������� �����, � ��������� ������� ���� ����� "Microsoft", �� ��� ����� "Windows".
select b.NameBook
from Books b
where b.NameBook like '������' and b.NameBook NOT LIKE '%2'

--7.	������� �������� ����, ��������, ������ (������ ���), ���� ����� �������� ������� ����� 10 ������.
Select b.NameBook Book, a.FirstName+' '+a.LastName Author, t.NameTheme Theme, b.Price/b.Pages 'Price per page'
From Books b 
join Authors a on b.Id_Author=a.Id_Author 
join Themes t on b.Id_Theme=t.Id_Theme
Where b.Price/b.Pages <0.4


--8.	������� �� ����� ��� �����, �� ������� � ���� �� ������� � �.�., ���� ������� ������� ��������� � ��������� 01/01/2017 �� ����������� ����.
Select a.FirstName+' '+a.LastName Author,b.NameBook Book, b.Price Price, s.DateOfSale DateOfSale
From Books b 
join Authors a on b.Id_Author=a.Id_Author
join Sales s on s.Id_Book=b.Id_Book
Where s.DateOfSale >='2017-01-01' and s.DateOfSale<=GETDATE()
Group by a.FirstName+' '+a.LastName,b.NameBook, b.Price , s.DateOfSale 


--9.	�������� ��� ���������� �� �������� ���� �������� �Computer Science� ����������, ������� ��������� �� � ������� � �� � ������. ���������� ����������� � ��������� ����: 
--�	�������� �����;
--�	����� ����� (������ ���);
--�	���������� ������ ������ �����;
--�	�������� ��������.
Select b.NameBook Book,t.NameTheme Theme, a.FirstName+' '+a.LastName Author, s.Quantity SaleQuantity, sh.NameShop Shop, c.NameCountry Country
From Books b 
join Authors a on a.Id_Author=b.Id_Author
join Themes t on b.Id_Theme = t.Id_Theme
join Sales s on s.Id_Book=b.Id_Book
join Shops sh on sh.Id_Shop=s.Id_Shop
join Country c on c.Id_Country=sh.Id_Country
where t.NameTheme = '��������' and c.NameCountry!='�������' and c.NameCountry!='������'
Group by b.NameBook, t.NameTheme , a.FirstName+' '+a.LastName, s.Quantity , sh.NameShop , c.NameCountry

--10.	�������� ��� �������� �� �������.

Select sh.NameShop Shop, c.NameCountry Country
From Shops sh 
join Country c on sh.Id_Country=c.Id_Country
Where c.NameCountry='�������'
 
