
----------------------------------------Create database --------------------------

create database PublishingHouse on primary
(name = PublishingHouse, filename = 'C:\TMP\PublishingHouse.mdf',
size=20MB,
maxsize = 20MB,
filegrowth = 2MB )
LOG ON
(name = PublishingHouseB_Log,
filename = 'C:\Tmp\PublishingHouse_Log.ldf',
size = 8MB,
maxsize = 12MB,
filegrowth = 1MB);

Use PublishingHouse

CREATE TABLE Books
(

Id_Book INT PRIMARY KEY IDENTITY,
NameBook nvarchar(30) not null CHECK (NameBook != ''),
Id_Theme INT,
Id_Author INT,
Price money not null CHECK (Price >= 0 ),
DrawingOfBook int not null CHECK (DrawingOfBook > 0 ),
DateOfPublish Date Not null,
Pages int not null CHECK (Pages > 0)
);

CREATE TABLE Themes
(
Id_Theme INT PRIMARY KEY IDENTITY,
NameTheme nvarchar(30) not null CHECK(NameTheme !='') UNIQUE
);


CREATE TABLE Authors
(
Id_Author INT PRIMARY KEY IDENTITY,
FirstName nvarchar(30) not null CHECK(FirstName != '') UNIQUE,
LastName nvarchar(30) not null CHECK(LastName != '') UNIQUE,
Id_Country INT
);

CREATE TABLE Sales
(
Id_Sale INT PRIMARY KEY IDENTITY,
Id_Book INT,
DateOfSale Date Not null,
Price money not null, CHECK(PRICE > 0),
Quantity int not null, CHECK(Quantity >= 0),
Id_Shop INT

);

CREATE TABLE Shops
(
Id_Shop INT PRIMARY KEY IDENTITY,
NameShop NVARCHAR(20) NOT NULL,
Id_Country INT
);

CREATE TABLE Country
(
Id_Country INT PRIMARY KEY IDENTITY,
NameCountry nvarchar(30) not null CHECK (NameCountry != '') UNIQUE
);



ALTER TABLE Authors
ADD FOREIGN KEY (Id_Country) REFERENCES Country (ID_Country) ;

ALTER TABLE Shops
ADD FOREIGN KEY (Id_Country) REFERENCES Country (ID_Country) ;

ALTER TABLE Books
ADD FOREIGN KEY (Id_Author) REFERENCES Authors (ID_Author) ;


ALTER TABLE Books
ADD FOREIGN KEY (Id_Theme) REFERENCES Themes (ID_Theme);

ALTER TABLE Sales
ADD FOREIGN KEY (Id_Book) REFERENCES Books (ID_Book) ;

ALTER TABLE Sales
ADD FOREIGN KEY (Id_Shop) REFERENCES Shops (ID_Shop) ;

-------------------------------rename database---------------------------

USE master;  
GO  
ALTER DATABASE PublishingHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE PublishingHouse MODIFY NAME = Publishing;
GO  
ALTER DATABASE Publishing SET MULTI_USER;
GO

Use Publishing

INSERT INTO Themes
VALUES('Классика'),('Ужасы'),('Детектив'),('Комедия'),('Проза'),('Фантастика'), ('Кулинария'),('Научная литература');


INSERT INTO Country
VALUES('США'),('Великобритания'),('Германия'),('Швеция'),('Украина'),('Грузия'),('Швейцария'),('Франция');

INSERT INTO Authors
VALUES ('Анна', 'Йохман', 3), ('Питер', 'Сигман', 2), 
('Джон', 'Фельдман', 1), ('Годман', 'Гинлер', 4), 
('Васик', 'Телесык', 5), ('Рафик', 'Ар', 6),
('Альбер', 'Вайцман', 7), ('Джозеф', 'Сарман', 8),  
('Альтер', 'Генриж', 3), ('Джосеф', 'Гульман', 1) 


INSERT INTO Books
VALUES ('Левиафан', 1, 1, 300, 50000, '2016.04.21', 400),
('Патрисий', 2, 2, 400, 300000, '2014.03.11' , 300),
('Сыщик', 3, 3, 250, 150000, '2017.03.22' , 200),
( 'Успех', 4, 4, 500, 700000, '2017.06.15' , 450),
('Все о Шишках', 5, 5, 400, 890000, '2013.01.17' , 300),
('Шашлык', 7, 6, 100, 1050000, '2012.01.12' , 400),
('Боград', 8, 8, 250, 153000, '2018.12.12' , 200),
('Дерево Жизни', 2, 1, 300, 4350000, '2018.05.13' , 150),
('Альтер Эго', 3, 4, 400, 1350000, '2015.07.01', 700 ),
('Битнег', 5, 4, 500, 530000, '2017.03.11', 800),
('Иннер', 1, 1, 300, 503000, '2016.04.21', 500),
('Логнер', 2, 2, 400, 3030000, '2014.03.11', 400),
('Джонта', 3, 3, 250, 150000, '2017.03.22', 500),
( 'Херман', 4, 4, 500, 700000, '2017.06.15', 300),
('Аультер', 5, 5, 400, 894000, '2013.01.17', 600),
('Шашлык 2 ', 7, 6, 100, 150000, '2012.01.12', 400),
('Дореми', 8, 8, 250, 123000, '2018.12.12', 300),
('Жорен', 2, 1, 300, 3350000, '2018.05.13', 200),
('Щеки', 3, 4, 400, 1150000, '2015.07.01', 100),
('Бифитер', 5, 4, 500, 132000, '2017.03.11', 150)

INSERT INTO Shops
VALUES ('Букинист', '5'),('USACollab', '1'),('Sweden', '4'),('GermanBooks', '3'),('Sahvish', '6'),
('UKPublisher', '2'),('Jitzer', '7'),('Sevduple', '8')

INSERT INTO Sales
VALUES(7, '2018.09.11', 800, 5000, 1), 
(8, '2018.01.21', 600, 15000, 2), 
(9, '2018.09.30', 500, 10000, 3), 
(10, '2018.11.21', 400, 50000, 4), 
(11, '2018.12.11', 500, 100000, 5), 
(12, '2018.10.21', 400, 30000, 6), 
(13, '2018.11.15', 600, 40000, 7), 
(14, '2018.12.14', 700, 80000, 8), 
(15, '2018.11.21', 400, 90000, 1), 
(16, '2018.10.21', 500, 34000, 2) 

