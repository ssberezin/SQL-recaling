
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
filegrowth = 1MB)
COLLATE Latin1_General_CI_AI;

Use PublishingHouse

CREATE TABLE Books
(
Id_Book INT PRIMARY KEY IDENTITY,
NameBook NVARCHAR(20) NOT NULL,
Price MONEY NOT NULL DEFAULT 0,
DrawingOfBook NVARCHAR(20) NOT NULL,
DateOfPublish Date Not null,
Pages INT DEFAULT 0,
Id_Theme INT,
Id_Author INT
);

CREATE TABLE Themes
(
Id_Theme INT PRIMARY KEY IDENTITY,
NameTheme NVARCHAR(20) NOT NULL
);

CREATE TABLE Authors
(
Id_Author INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
Id_Country INT
);

CREATE TABLE Sales
(
Id_Sale INT PRIMARY KEY IDENTITY,
DateOfSale Date Not null,
Price MONEY NOT NULL DEFAULT 0,
Quantity INT DEFAULT 0,
Id_Shop INT,
Id_Book INT

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
NameCountry NVARCHAR(20) NOT NULL
);

ALTER TABLE Authors
ADD FOREIGN KEY (Id_Country) REFERENCES Country (ID_Country) ON DELETE CASCADE
      ON UPDATE CASCADE ;

ALTER TABLE Shops
ADD FOREIGN KEY (Id_Country) REFERENCES Country (ID_Country) ON DELETE CASCADE
      ON UPDATE CASCADE ;

ALTER TABLE Books
ADD FOREIGN KEY (Id_Author) REFERENCES Authors (ID_Author) ON DELETE CASCADE
      ON UPDATE CASCADE;


ALTER TABLE Books
ADD FOREIGN KEY (Id_Theme) REFERENCES Themes (ID_Theme) ON DELETE CASCADE
      ON UPDATE CASCADE;

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