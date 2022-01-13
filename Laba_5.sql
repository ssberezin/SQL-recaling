--��� ���� ������ ������������ �������� ��������� �������:
--1. �������, ������� ���������� ���������� ���������, ������� �� �������
--�� ����� ����� ������������.

use Publishing



go
CREATE FUNCTION ShopCount()
RETURNS Int 
BEGIN
	DECLARE @CountShops INT
	SELECT @CountShops=Count(Shops.Id_Shop)
	From Shops join Sales on Sales.Id_Shop=Shops.Id_Shop
	Where Sales.Quantity=0

	RETURN @CountShops
END;
go

print dbo.ShopCount()


go
CREATE FUNCTION CountZeroMags()
RETURNS INT
BEGIN
DECLARE @iCount int 
SELECT @iCount = Count(S.Id_Sale)
FROM Shops SH LEFT JOIN Sales S 
ON SH.Id_Shop = S.Id_Shop
WHERE S.Id_Sale is null
RETURN @iCount
END
go

Print dbo.CountZeroMags()
--2. �������, ������� ���������� ����������� �� ���� ����������.
go
Create Function OneOfThree (@p1 int,@p2 int, @p3 int )
Returns int
Begin
declare @max int
if (@p1>@p2 and @p1>@p3) Set @max=@p1
if (@p2>@p1 and @p2>@p3) Set @max=@p2
if (@p3>@p1 and @p3>@p2) Set @max=@p3
Return @max
end
go

Print dbo.OneOfThree(1,2,3)

--3. �������, ������� �� ���������� ���� ���������� �������� ������ (����,
--�����, ����, �����).
go
Create Function GetTineOfYear (@SetDate date )
Returns nvarchar (30)
Begin
declare @result nvarchar (30)
declare @MonthNumber int
Set @MonthNumber = MONTH(@SetDate)

if (@MonthNumber=12 or @MonthNumber<=2) Set @result='Winter'
else
	if (@MonthNumber>=3 and @MonthNumber<=5) Set @result='Spring'
	else
		if (@MonthNumber>=6 and @MonthNumber<=8) Set @result='Summer'
		else
			Set @result='Autumn'

Return @result
end
go

Print dbo.GetTineOfYear('02-06-2021')

--4. � �������������� ������� �� �.3 ����������, � ����� ����� ����
--���������� ���������� ���������� ����.

Select Sum(Quantity) Quantity, dbo.GetTineOfYear(Sales.DateOfSale) MonthOfYear
From Sales 
Group by dbo.GetTineOfYear(Sales.DateOfSale)

--5. �������� �������, ������� ������� ���������� � ���� ������
--������������ �������� (�������� ���������� � �������� ���������).

go
Create Function BookThemeInfo (@ThemeName nvarchar(30) )
Returns Table 
as Return 
(Select Books.NameBook Book, Themes.NameTheme Theme  
 From Books join Themes on Books.Id_Theme=Themes.Id_Theme 
 where Themes.NameTheme=@ThemeName)
go

Select * From dbo.BookThemeInfo('��������')

--6. �������, ������� ���������� ������� �������������� ��� ���� ����,
--��������� �� ��������� ����. (���������� �� ���� ���� ������� ���� ��� �� �� ��� �� �������� � ��)

go
Create Function AVGPriceByDate(@SetDate date)
Returns money
Begin
Declare @Result money
Set @result=(Select AVG(Price) From Books Where dbo.GetTineOfYear(DateOfPublish)=dbo.GetTineOfYear(@SetDate))
Return @Result
End
go

Print dbo.AVGPriceByDate('12-12-18')
--7. �������, ������� ���������� ����� ������� ����� ��������� ��������.

go
Create function MostExpansiveBookByTheme(@Theme nvarchar (30))
Returns table 
as Return
(Select Books.NameBook Book, Themes.NameTheme Theme
From Books join Themes on Books.Id_Theme=Themes.Id_Theme
where Themes.NameTheme=@Theme and Price=
(Select Max(Books.Price)
From Books join Themes on Books.Id_Theme=Themes.Id_Theme
Where Themes.NameTheme=@Theme))
go

Select * from dbo.MostExpansiveBookByTheme('��������')

--8. �������, ������� ���������� ������ ����, ������� �������������
--������ ��������� (������� ������, ��������), � ������������� ��
--������� ������ � ��������� � 3-� ��������� ����������� (0 � ��
--�����������, 1 � �� ��������).
go
Create function BooksAndAuthors (@Authorname nvarchar(30) , @ThemeName nvarchar (30), @sort bit )
Returns table
as return
(Select top 1000  b.NameBook 
From Books b 
join Authors a on a.Id_Author=b.Id_Author
join Themes t on t.Id_Theme=b.Id_Theme 
Where a.LastName=@Authorname and t.NameTheme=@ThemeName
Order by
case when @sort=0 then b.NameBook end,
case when @sort=1 then b.NameBook  end desc
)
go

 SELECT* FROM dbo.BooksAndAuthors('������','�����', 1)

--9. �������, ������� �� ID �������� ���������� ���������� � ��� (ID,
--��������, ��������������, ������� ��������� ������ �� ��������� ���
--����) � ��������� ����.

go
Create function ShopInfoFunc (@InputId int, @InputYear int)
Returns table
As return
(Select Shops.Id_Shop Id, Shops.NameShop Shop, Country.NameCountry Country, Avg(Sales.Price) AVGPrice
From  Shops 
join Country on Shops.Id_Country=Country.Id_Country
join Sales on Shops.Id_Shop=Sales.Id_Shop
Where Year(Sales.DateOfSale)=@InputYear and Shops.Id_Shop=@InputId
Group by Shops.Id_Shop , Shops.NameShop, Country.NameCountry)
go


Select * From  dbo.ShopInfoFunc(2, 2018)
--10.���������������� �������, ������� ���������� ���������� ���������
--���� �� ������ �� ������� � ������� ������� ��������.
--11.�������, ������� �� ����������� �������� ������ �������
--���������� � ��������, ������������� � ���� ������ (��������,
--���������� ��������� ���� �� ��������� ���, ������������ �� �������
--���� �����).
--12.�������� �������, ������� ������� ���������� � ���������� �������,
--������� � ������ ������� (�������� ������ ���������� � ��������
--���������).