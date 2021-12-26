--��� ���� ������ ������������ �������� ��������� �������:
--1. ������� ���������� ��� ���� ������, � ����� ������� ������ 4-� ����.
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

--5. �������� ������� � ����� ������ ����� �� ������� �� ���. ���������
--��������� � ���������� ��������� �������.
--6. �������� �� ����� ����� ������� �� ������ �� �������, ��� ����
--��������� ������ ����� ����� �� ��������� �������: �Computer
--Science�, �Science Fiction�, �Web Technologies� � � ����������� �������
--����� 300.
--7. ����� �������, ������� � ��� �������, ��� ���� ���� �� ���� ��
--��������� �� ��������������� ����, ���������� � ��. ��������� �������
--��������� � ��������� �������������.
--8. �������� �������������, ���������� ����� ������� ����� ��������,
--��������, �Web Technologies�.
--9. �������� �������������, ������� ��������� ������� ��� ���������� �
--������ ���������. ������������� ������� �� ������� � ������������ �
--�� ��������� ��������� � ��������� �������.
--10.�������� ������������� �������������, ������������ �����
--���������� �����.
--11. �������� ���������������� �������������, � ������� ���������������
--���������� �� �������, ����� ������� ���������� � � ��� �.
--12.�������� �������������, � ������� � ������� ����������� �������
--�������� ���������, ������� ��� �� ������� ����� ������ ������������.