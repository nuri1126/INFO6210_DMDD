
create database PackageManufacturingDatabaseSystem;
use PackageManufacturingDatabaseSystem;



Create Table dbo.Customer
(
	CustomerID INT Not Null Primary Key identity(200,1),
	CompanyName Varchar Not null,
	ContactNumber int Not null,
	EmailID Varchar Not Null ,
	Country Varchar Not Null ,
	State Varchar Not Null,
	City Varchar Not Null,
	Address1 Varchar Not Null,
	Address2 Varchar,
	ZipCode Int Not Null
);
Alter table dbo.Customer alter column ContactNumber bigint;

Alter table dbo.Customer add constraint checkForEmail check (EmailID like '%_@__%.__%')
ALTER TABLE dbo.Customer ADD CONSTRAINT uniqueEmail UNIQUE(EmailID);

ALTER TABLE dbo.Customer ALTER COLUMN CompanyName VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN EmailID VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN Country VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN State VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN City VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN Address1 VARCHAR (50)
ALTER TABLE dbo.Customer ALTER COLUMN Address2 VARCHAR (50)

ALTER TABLE Customer ALTER COLUMN Address1 VARCHAR (50) NULL
ALTER TABLE Customer ALTER COLUMN Address2 VARCHAR (50) NULL


Create Table RawMaterials
   (
	MaterialID int not null primary key,
	MaterialName varchar(255) not null,
	QuantityOnHand int not null
   )

CREATE FUNCTION CheckQtyAvailable(@MatID int)
RETURNS int
AS
BEGIN
	DECLARE @Quantity int;
	SELECT @Quantity=QuantityOnHand
	FROM dbo.RawMaterials
	WHERE MaterialID=@MatID
	RETURN @Quantity;
END;


ALTER TABLE dbo.RawMaterials ADD CONSTRAINT QtyCk CHECK (dbo.CheckQtyAvailable(MaterialID)> 10 );

CREATE TABLE dbo.Products
	(
	ProductID int NOT NULL PRIMARY KEY,
	MaterialID int NOT NULL
		REFERENCES dbo.RawMaterials(MaterialID),
	Size_Length int NOT NULL,
	Size_Height int NOT NULL,
	Size_Width int NOT NULL,
	Image_url varchar(100) NOT NULL,
	);


Create Table dbo.Subscriptions
(
	SubscriptionID Int PRIMARY KEY IDENTITY(501,1),
	CustomerID Int Not Null References dbo.Customer(CustomerID),
	ProductID Int Not Null References dbo.Products(ProductID),
	Quantity Int Not Null,
	RepeatOrderIn_Months Int Not Null,
	ExpiryDate date
)

--- To have unique subscriptions for product 1 customer can subscribe for many products
ALTER TABLE Subscriptions  ADD CONSTRAINT uniqueSubscriptions UNIQUE(CustomerID,productID);

Create Table CustomerCredentials
(
	CustomerID Int References dbo.Customer(CustomerID) unique,
	EmailID Varchar(50) ,
	PasswordValue VARBINARY(250)
)


CREATE TABLE dbo.ProcessType
	(
	ProcessID int NOT NULL PRIMARY KEY,
	ProcessName varchar(10) NOT NULL
	);

CREATE TABLE dbo.SalesOpportunities
	(
	SaleID int NOT NULL PRIMARY KEY,
	CustomerID int NOT NULL
			REFERENCES dbo.Customer(CustomerID),
	Requirement_Specifications varchar(100)
	);

CREATE TABLE dbo.Orders
    (
	OrderID int IDENTITY NOT NULL PRIMARY KEY,
	CustomerID int NOT NULL
	REFERENCES dbo.Customer(CustomerID),
	[Status] varchar(50) NOT NULL,
	OrderDate Date NOT NULL
    );



 CREATE TABLE dbo.Returns(
	ReturnID  int IDENTITY NOT NULL PRIMARY KEY,
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	Reason varchar(max) NOT NULL
 );

CREATE TABLE dbo.Refunds
	(
	RefundID int NOT NULL PRIMARY KEY,
	ReturnID int NOT NULL
		REFERENCES dbo.[Returns](ReturnID),
	ModeOfRefund varchar(20) NOT NULL,
	Status varchar(10) NOT NULL
	);

CREATE TABLE dbo.PaymentDetails
	(
	CustomerID int NOT NULL
			REFERENCES dbo.Customer(CustomerID),
	OrderID int NOT NULL
			REFERENCES dbo.Orders(OrderID),
	ModeOfPayment varchar(20) NOT NULL,
	Amount int NOT NULL,
	Note varchar,
	CONSTRAINT PKOrderPayment PRIMARY KEY CLUSTERED(CustomerID,OrderID)
	);

create FUNCTION checkAmountEuality (
    @orderid INT
    ,@amount int
)
RETURNS VARCHAR(10)
AS
BEGIN
    IF (SELECT TotalAmount FROM Orders WHERE OrderID = @orderid) = @amount
        return 'True'
    return (SELECT TotalAmount FROM Orders WHERE OrderID = @orderid)
END
;

ALTER TABLE dbo.PaymentDetails ADD CONSTRAINT amountcheck
	check (Amount > 0 and (dbo.checkAmountEuality(OrderID,Amount) = 'True'));

ALTER TABLE dbo.PaymentDetails ADD CONSTRAINT uniquePaymentDetails UNIQUE(CustomerID, OrderID);

CREATE TABLE dbo.OrderProducts(
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	Quantity int NOT NULL
	CONSTRAINT PKOrderItem PRIMARY KEY CLUSTERED(OrderID, ProductID)
 );

 CREATE TABLE dbo.Reprocess(
	ReprocessID int IDENTITY NOT NULL PRIMARY KEY,
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	[Status] varchar(50) NOT NULL
 );



CREATE TABLE dbo.Reviews(
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	Rating int NOT NULL,
	Review varchar(max) NOT NULL
	CONSTRAINT PKOrderProduct PRIMARY KEY CLUSTERED(OrderID, ProductID)
 );

CREATE TABLE dbo.Process(
    ProcessID  int NOT NULL
	REFERENCES dbo.ProcessType(ProcessID),
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	MaterialUsage int NOT NULL,
	StartDate Date NOT NULL,
	EndDate Date
	CONSTRAINT PKProductProcess PRIMARY KEY CLUSTERED(ProcessID,OrderID, ProductID)
 );

ALTER TABLE Products
ADD Price Money;

ALTER TABLE Orders
ADD TotalAmount Money;

alter table ProcessType alter column ProcessName varchar(20)
alter table Process alter column StartDate datetime
alter table Process alter column EndDate datetime
alter table Products alter column Image_url varchar(max)


Create table RawMaterialPurchase(
PurchaseID int not null primary key,
PurchaseDate DATE not null,
ModeofPayment varchar(255) not null,
Note varchar(255),
TotalPrice int)

Create Table Vendors(
VendorID int not null primary key,
VendorName varchar(255) not null,
PhoneNumber varchar(10) not null)

alter table Vendors
add constraint PhoneNumber check (PhoneNumber not like '%[^0-9]%')



Create Table RawMaterialsVendors(
MaterialID int not null,
VendorID int not null,
LeadTime int not null,
UnitPrice float not null,
MaterialVendorID as concat(VendorID,MaterialID) persisted primary key)

Create table RawMaterial_VendorPurchase(
MaterialVendorID varchar(24) not null,
PurchaseID int not null,
quantity int not null,
DeliveryStatus varchar(255) not null,
primary key (MaterialVendorID,PurchaseID))

GO
-- this needs to be run first before PredictedArrivalDate Calculation
create function estimatearrivaldate (@materialVendorID varchar(100), @purchaseid int)
returns date
as
begin
	declare @days int
	select @days=LeadTime from RawMaterialsVendors where MaterialVendorID=@materialVendorID
	declare @purchasedate date
	select @purchasedate=Purchasedate From RawMaterialPurchase where PurchaseID=@purchaseid
	return(dateadd(day,@days,@purchasedate))
end

alter table RawMaterial_VendorPurchase
add PredictedArrivalDate as dbo.estimatearrivaldate(MaterialVendorID,PurchaseID)

alter table RawMaterialsVendors
add foreign key(MaterialID) references RawMaterials(MaterialID)

alter table RawMaterialsVendors
add foreign key(VendorID) references Vendors(VendorID)

alter table RawMaterial_VendorPurchase
add foreign key(MaterialVendorID) references RawMaterialsVendors(MaterialVendorID)

alter table RawMaterial_VendorPurchase
add foreign key(PurchaseID) references RawMaterialPurchase(PurchaseID)

