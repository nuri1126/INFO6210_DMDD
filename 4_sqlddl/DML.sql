use PackageManufacturingDatabaseSystem;

--Insert data in Customer
insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('Dominos',1234567890,'dominos@gmail.com','USA','washington','Bothell','20806 Bothell','Everett Hwy Suite 106',98121)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('walMart',2456754321,'walmart@gmail.com','USA','washington','Bellevue','986 Aloha','Downtown',98606)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('PizzHut',2345678910,'pizzhut@gmail.com','USA','washington','Bellevue','15210 SE 37th st','',98007)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('H&M',2345678911,'HM@gmail.com','USA','washington','Seattle','2604 NE','University village st',98101)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('Uhaul',2345678912,'uhaul@gmail.com','USA','washington','Redmond','18024','Redmond way',98008)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('GapCloths',2345678913,'Gap@gmail.com','USA','washington','Bellevue','4625 27th Ave','NE st #23',98007)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('TommyHilfigerPerfume',2345678914,'tho@gmail.com','USA','washington','Tacoma','macys','Tacoma mall',98008)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('SeattleProfessionalMovers',2345678915,'spm@gmail.com','USA','washington','Seattle','NW 61st St','',98101)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('PeopleMovers',2345678916,'peoplemovers@gmail.com','USA','washington','Renton','N 103rd ST','',98055)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('IKEA',2345678917,'ikea@gmail.com','USA','washington','Redmond','601 SW','41st ST',98008)

insert into dbo.Customer(CompanyName,ContactNumber,EmailID,Country,State,City, Address1,Address2,ZipCode)
values('DollarTree',2345678918,'dollartree@gmail.com','USA','washington','Seattle','','',98101)

update dbo.Customer set EmailId='dominos1@gmail.com',city='Bothell',
Address1='20806 Bothell', Address2='Everett Hwy Suite 106' 
where customerId=200


-- Insert into CustomerCredentials
create trigger CustomerIdUpdate
on dbo.CustomerCredentials
after insert,update,delete
as begin
	declare @CustId int;
	declare @CustEmailId varchar(50);
	declare @CustLoginId varchar(50);
	
	select @CustLoginId= coalesce(i.EmailId,d.EmailId) from inserted i full join deleted d
						 on i.EmailID=d.EmailID
	select @CustEmailId= c.EmailID from Customer c where @CustLoginId=c.EmailID

	select @CustId=c.CustomerID from Customer c where @CustEmailId=c.EmailID
	
	update CustomerCredentials set CustomerID=@CustId where EmailID=@CustEmailId
end


--____________________________________
--Encryption on password
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'AHJNP';

CREATE CERTIFICATE ProjectCertificate 
WITH SUBJECT = 'PackageManufacturingDatabaseSystem project Certificate',EXPIRY_DATE = '2022-03-31';

CREATE SYMMETRIC KEY ProjectSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE ProjectCertificate;

OPEN SYMMETRIC KEY ProjectSymmetricKey
DECRYPTION BY CERTIFICATE ProjectCertificate;

-- Insert into CustomerCredentials
INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('dominos@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'dominos')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('HM@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'H&M')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('uhaul@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'uhaul')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('Gap@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'gap')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('tho@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'tommyHilfiger')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('spm@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'SeattleProfMovers')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('peoplemovers@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'peopleMovers')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('ikea@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'ikea')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue )
VALUES('pizzhut@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'pizzhut')));

INSERT INTO CustomerCredentials(EmailID,PasswordValue)
VALUES('dollartree@gmail.com', EncryptByKey(Key_GUID(N'ProjectSymmetricKey'), convert(varbinary,'DollarTree')));



--Decrypt the password
select CustomerID,EmailID, convert(varchar, DecryptByKey(PasswordValue)) as [PasswordValue] from CustomerCredentials;


--Insert in RawMaterials
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2000,'Cardboard',974);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2001,'Cutter',464);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2002,'Vacuum-Metalized Polyethylene',120);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2003,'Paperboard',370);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2004,'Biaxially Oriented Polyethylene',50);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2005,'Ink',60);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2006,'Adhesive',600);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2007,'Ethyl Acetate',7000);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2008,'DeliveryBox',450);
INSERT INTO dbo.RawMaterials (MaterialID ,MaterialName,QuantityOnHand)
VALUES (2009,'Zipper',260);


--Insert Data in Products
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(800, 2000, 4, 10, 8, 'https://www.packagingsupplies.com/collections/corrugated-mailers/products/3-x-3-x-1-white-corrugated-mailers', 5.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(801, 2000, 4, 10, 8, 'https://www.packagingsupplies.com/collections/corrugated-boxes/products/3-x-3-x-3-corrugated-boxes', 10.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(802, 2000, 4, 10, 8, 'https://www.packagingsupplies.com/collections/white-corrugated-boxes/products/4-x-4-x-4-white-corrugated-boxes', 15.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(803, 2001, 4, 4, 8, 'https://www.packagingsupplies.com/collections/foam-lined-mailers', 2.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(804, 2000, 14, 4, 8, 'https://www.packagingsupplies.com/collections/insulated-shipping-kits/products/10-1-2-x-8-1-4-x-9-1-4-insulated-shipping-kit', 12.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(805, 2002, 6, 4, 1, 'https://www.packagingsupplies.com/collections/insulated-foam-containers/products/8-x-6-x-9-insulated-foam-containers', 2.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(806, 2003, 10, 12, 2, 'https://www.packagingsupplies.com/collections/insulated-box-liners/products/12-x-12-x-12-insulated-box-liners', 12.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(807, 2001, 6, 2, 2, 'https://www.packagingsupplies.com/collections/cold-packs/products/8-x-8-x-1-1-2-32-oz-ice-brix-cold-packs', 10.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(808, 2002, 7, 10, 2, 'https://www.packagingsupplies.com/collections/cool-shield-bubble-mailers/products/6-1-2-x-10-1-2-cool-shield-bubble-mailers', 8.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(809, 2003, 6, 14, 1, 'https://www.packagingsupplies.com/collections/insulated-mailers/products/12-x-14-cool-stuff-insulated-mailers', 2.0000);
INSERT INTO dbo.Products
(ProductID, MaterialID, Size_Length, Size_Height, Size_Width, Image_url, Price)
VALUES(810, 2001, 5, 12, 3, 'https://www.packagingsupplies.com/collections/retention-packaging/products/12-x-10-x-5-korrvu-r-suspension-packaging', 12.0000);

--Trigger to Set Expiry date automatically

go
create trigger ExpiryDateUpdate
on dbo.Subscriptions
after insert, update,delete
as begin
	declare @expiryDate date;
	declare @startDate date=getdate();
	declare @duration int;
	declare @ProdID int;
	declare @CusID int;
	select @ProdID= Coalesce(i.ProductID,d.ProductID) from inserted i join deleted d
					on i.ProductID=d.ProductID
	select @CusID=Coalesce(i.CustomerID,d.CustomerID) from inserted i join deleted d
					on i.CustomerID=d.CustomerID
	set @expiryDate=DateAdd(yy,1,getdate())
	update dbo.Subscriptions set ExpiryDate=@expiryDate where ProductID= @ProdID and CustomerID=@CusID
end

-- Insert into Subscriptions
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(204,801,100,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(200,800,2,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(201,801,50,2)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(202,803,200,1)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(203,804,100,2)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(204,802,150,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(205,802,75,3)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(206,808,60,3)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(206,809,25,6)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(207,810,100,1)
insert into Subscriptions(CustomerID,ProductID,Quantity,RepeatOrderIn_Months)
values(208,803,250,6)



--Orders
SET IDENTITY_INSERT dbo.Orders ON;
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(300, 200, 'Processing', '2006-04-04', 0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(301, 201, 'processed', '2020-11-11', 0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(302, 203, 'Refund Processed', '2020-11-11', 0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(303, 204, 'Initiated', '2021-01-11', 0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(304, 205, 'Pending', '2021-02-12', 0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(305, 206, 'processing', '2021-02-13', 0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(306, 207, 'processed', '2021-03-01', 0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(307, 208, 'Delivered', '2020-03-18', 0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(308, 209, 'processed', '2020-03-20',0);
INSERT INTO dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(309, 210, 'processing', '2020-03-28', 0);

--Trigger to compute Total amount in Orders 
CREATE TRIGGER TR_UpdateTotalAmtBasedOnQuantity
ON dbo.OrderProducts
AFTER INSERT, UPDATE , DELETE AS
BEGIN
	DECLARE @Amount table (totalprice int, orderID int)
	insert into @Amount 
	SELECT SUM(p.Price * op.Quantity),op.OrderID
	FROM PackageManufacturingDatabaseSystem.dbo.Products p 
	JOIN  OrderProducts op 
	ON op.ProductID = p.ProductID 
	GROUP BY op.OrderID 
	UPDATE Orders 
	SET TotalAmount = (select totalprice from @Amount a
					   where a.OrderID = Orders.OrderID)
END;




--Insert in OrderProducts
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (300,800,2);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (301,802,4);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (302,800,18);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (300,803,20);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (304,804,18);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (305,805,120);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (307,802,87);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (308,806,109);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (308,801,70);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (309,803,45);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (300,801,45);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (300,802,5);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (301,803,5);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (304,800,5);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (304,802,5);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (303,806,2);
INSERT INTO dbo.OrderProducts (OrderID,ProductID,Quantity)
VALUES (306,806,2);


--Insert in Process type
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1000, 'Printing');
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1001, 'Lamination');
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1002, 'Bag making');
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1003, 'Box making');
INSERT INTO dbo.ProcessType
(ProcessID, ProcessName)
VALUES(1004, 'Quality check');


--Returns
SET IDENTITY_INSERT dbo.Returns ON;
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1700,300,800,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1701,301,801,'Quality issues');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1702,302,802,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1703,303,803,'Quality issues');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1704,304,804,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1705,305,805,'Quality issues');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1706,306,806,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1707,307,807,'Quality issues');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1708,308,808,'no longer required');
insert into dbo.Returns([ReturnID],[OrderID],[ProductID],[Reason]) values(1709,309,809,'Quality issues');

--Insert in Refunds
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(600, 1700, 'Gift card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(601, 1701, 'Credit in card', 'Processing');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(602, 1702, 'Gift card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(603, 1703, 'Gift card', 'Processing');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(604, 1704, 'Credit in card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(605, 1705, 'Gift card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(606, 1706, 'Credit in card', 'Processing');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(607, 1707, 'Gift card', 'Processing');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(608, 1708, 'Credit in card', 'Refunded');
INSERT INTO dbo.Refunds
(RefundID, ReturnID, ModeOfRefund, Status)
VALUES(609, 1709, 'Gift card', 'Refunded');



--Insert in process
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1000, 300, 800, 12, '2006-11-11 13:23:44', '2006-11-11 14:56:00');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1000, 301, 801, 10, '2006-11-11 15:00:00', '2006-11-11 16:39:39');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1002, 305, 805, 10, '2006-11-11 15:20:30', '2006-11-11 15:22:59');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1002, 302, 802, 5, '2006-11-11 15:20:30', '2006-11-11 15:22:07');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1002, 302, 800, 2, '2006-11-12 12:26:30', '2006-11-12 13:12:34');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1002, 304, 802, 6, '2006-11-12 15:27:30', '2006-11-12 16:22:09');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1004, 300, 800, 0, '2006-11-12 15:27:30', '2006-11-12 16:22:09');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1004, 301, 801, 0, '2006-11-12 15:30:30', '2006-11-12 15:35:09');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1004, 305, 805, 0, '2006-11-12 15:40:30', '2006-11-12 15:45:09');
INSERT INTO dbo.Process
(ProcessID, OrderID, ProductID, MaterialUsage, StartDate, EndDate)
VALUES(1004, 302, 802, 0, '2006-11-12 15:50:30', '2006-11-12 15:55:09');

--trigger to subtract quantity on process usage
Create trigger SubtractQuantityonHand
on dbo.Process 
after insert,update
as begin
declare @QtyOnHand int;
declare @Qtyused int;
declare @MatID int;
select @QtyOnHand= QuantityOnHand from dbo.RawMaterials
select @Qtyused=MaterialUsage from inserted i;
select @Qtyused=COALESCE(@Qtyused,0);
select @MatID=MaterialID from Products p join inserted i
				on p.ProductID =i.ProductID
update RawMaterials set QuantityOnHand=QuantityOnHand-@Qtyused where MaterialID=@MatID
end

--trigger to add quantity on deletion process usage
Create trigger SubtractQuantityonHandDeletion
on dbo.Process 
after DELETE 
as begin
declare @QtyOnHand int;
declare @Qtyused int;
declare @MatID int;
select @QtyOnHand= QuantityOnHand from dbo.RawMaterials
select @Qtyused=MaterialUsage from deleted d;
select @Qtyused=COALESCE(@Qtyused,0);
select @MatID=MaterialID from Products p join deleted d
				on p.ProductID =d.ProductID
update RawMaterials set QuantityOnHand=QuantityOnHand+@Qtyused where MaterialID=@MatID
END

--Trigger to compute Total Raw Material Purchase
CREATE TRIGGER TR_UpdateTotalRawMaterialPurchase
ON dbo.RawMaterial_VendorPurchase
AFTER INSERT, UPDATE , DELETE
AS
BEGIN
	DECLARE @TotalPurchase table (totalprice int, purchaseID int)
	insert into @TotalPurchase 
	SELECT SUM(rmvp.quantity*rmv.UnitPrice),rmvp.PurchaseID
	FROM PackageManufacturingDatabaseSystem.dbo.RawMaterialsVendors rmv 
	JOIN RawMaterial_VendorPurchase rmvp 
	ON rmv.MaterialVendorID = rmvp.MaterialVendorID 
	GROUP BY rmvp.PurchaseID 
	UPDATE RawMaterialPurchase 
	SET RawMaterialPurchase.TotalPrice = (select totalprice from @TotalPurchase a
	WHERE a.PurchaseID = RawMaterialPurchase.PurchaseID)
END;



--Reprocess
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (300,800,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (301,801,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (302,802,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (303,803,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (304,804,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (305,805,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (306,806,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (307,807,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (308,808,'needs reprocessing');
insert into dbo.Reprocess([OrderID],[ProductID],[Status]) values (309,809,'needs reprocessing');



--Reviews
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(300,800,4,'Excellent quality');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(301,801,2,'delivery not on time');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(302,802,5,'great experience');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(303,803,2,'Quality not up to the mark');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(304,804,5,'Excellent and timely delivery');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(305,805,2,'ok materials');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(306,806,4,'satisfied');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(307,807,1,'not satisfied');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(308,808,5,'Overall good');
 insert into dbo.reviews([OrderID],[ProductID],[Rating],[Review]) values(309,809,2,'poor');

--Vendors
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(1, 'Adam', '2061234567');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(2, 'Laura', '2062345678');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(3, 'Aaron', '2063456789');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(4, 'Michelle', '2063456789');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(5, 'Jeremy', '2064567890');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(6, 'Matt', '4251234567');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(7, 'Andy', '4252345678');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(8, 'Stephen', '4253456789');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(9, 'Stephanie', '4254567890');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(10, 'Olivia', '4255678901');
INSERT INTO dbo.Vendors
(VendorID, VendorName, PhoneNumber)
VALUES(11, 'Billy', '2063123121');



--RawMaterialVendors
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2004, 10, 45, 2.0);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2000, 1, 30, 1.0);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2000, 2, 15, 2.0);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2001, 3, 60, 1.5);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2001, 4, 30, 2.5);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2002, 5, 15, 1.5);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2002, 6, 20, 1.0);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2003, 7, 5, 1.0);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2003, 8, 10, 0.5);
INSERT INTO dbo.RawMaterialsVendors
(MaterialID, VendorID, LeadTime, UnitPrice)
VALUES(2004, 9, 30, 3.0);


--RawMaterialPurchase
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3000, '2021-11-11', 'credit card', 'raw materials purchased', 145);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3001, '2021-03-03', 'check', '', 330);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3002, '2021-01-01', 'cash', '', 147);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3003, '2021-10-10', 'credit card', '', 0);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3004, '2021-09-09', 'cash', '', 0);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3005, '2021-09-15', 'check', '', 0);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3006, '2021-12-12', 'cash', '', 0);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3007, '2021-12-30', 'check', '', 0);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3008, '2021-12-01', 'credit card', '', 0);
INSERT INTO dbo.RawMaterialPurchase
(PurchaseID, PurchaseDate, ModeofPayment, Note, TotalPrice)
VALUES(3009, '2021-11-01', 'check', '', 0);


--RawMaterial_VendorPurchase
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3001, 50, 'Delivered', '12000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3002, 30, 'Delivered', '12000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3000, 50, 'Delivered', '22000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3002, 50, 'preparing for delivery','22000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3000, 30, 'Delivered', '32001');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3001, 30, 'pending', '32001');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3001, 50, 'pending', '42001');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3001, 15, 'pending', '52002');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3001, 20, 'pending', '62002');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3001, 40, 'pending', '72003');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3001, 55, 'Delivered', '82003');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3002, 35, 'pending', '82003');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3003, 50, 'preparing for delivery', '22000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3004, 500, 'preparing for delivery', '32001');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3005, 500, 'preparing for delivery', '32001');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3006, 255, 'preparing for delivery', '12000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3007, 255, 'preparing for delivery', '22000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3008, 255, 'preparing for delivery', '42001');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3009, 300, 'preparing for delivery', '42001');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3000, 78, 'preparing for delivery', '12000');
INSERT INTO dbo.RawMaterial_VendorPurchase
(PurchaseID, quantity, DeliveryStatus, MaterialVendorID)
VALUES(3000, 50, 'preparing for delivery', '22000');

INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(200, 300, 'CREDIT', 10, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(201, 301, 'DEBIT', 30, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(203, 302, 'CASH', 90, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(204, 303, 'CHEQUE', 30, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(205, 304, 'CREDIT', 216, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(206, 305, 'DEBIT', 240, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(207, 306, 'CHEQUE', 30, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(208, 307, 'CASH', 1305, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(209, 308, 'DEBIT', 700, NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.PaymentDetails
(CustomerID, OrderID, ModeOfPayment, Amount, Note)
VALUES(210, 309, 'CASH', 90, NULL);

INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(100, 200, 'This customer wants to buy 1000 of Product 800 with $9, need to negotiate.');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(101, 201, 'This customer wants to buy 2000 Product801 with lower price, need to negotiate.');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(103, 203, 'This customer wants to order 10% off need to negotiate.');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(104, 204, 'This customer wants to order 100 more');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(105, 205, 'This customer wants to order 200 more');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(106, 206, 'This customer wants to order with the new type of product');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(107, 207, 'This customer wants to order once a month.');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(108, 208, 'This customer wants to get products in 2 weeks.');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(109, 209, 'This customer wants to deal.');
INSERT INTO PackageManufacturingDatabaseSystem.dbo.SalesOpportunities
(SaleID, CustomerID, Requirement_Specifications)
VALUES(110, 210, 'This customer wants to see the prototype first.');


--trigger to add quantity on delivered raw materials
Create trigger UpdateQuantityOnHand
on dbo.RawMaterial_VendorPurchase
after insert,update
as begin
declare @QtyOnHand int;
declare @QtyPurchased int;
declare @MatID int;
select @QtyOnHand= QuantityOnHand from dbo.RawMaterials
select @QtyPurchased=Quantity from inserted i where DeliveryStatus='Delivered';
select @QtyPurchased=COALESCE (@QtyPurchased,0)
select @MatID=MaterialID from RawMaterialsVendors rmv join inserted i
				on rmv.MaterialVendorID=i.MaterialVendorID
update RawMaterials set QuantityOnHand=QuantityOnHand+@QtyPurchased where MaterialID=@MatID
end


--trigger to subtract quantity on deleted rows on delivered raw materials
Create trigger UpdateQuantityOnHandDeletion
on dbo.RawMaterial_VendorPurchase
after delete
as begin
declare @QtyOnHand int;
declare @QtyPurchased int;
declare @MatID int;
select @QtyOnHand= QuantityOnHand from dbo.RawMaterials
select @QtyPurchased=isNull(Quantity,0) from deleted d where DeliveryStatus='Delivered';
select @MatID=MaterialID from RawMaterialsVendors rmv join deleted d
				on rmv.MaterialVendorID=d.MaterialVendorID
update RawMaterials set QuantityOnHand=QuantityOnHand-@QtyPurchased where MaterialID=@MatID
end


UPDATE RawMaterial_VendorPurchase  SET DeliveryStatus='Delivered' where MaterialVendorID='22000' ;
SELECT * FROM RawMaterials;

--view
create view OrderDetailsPerMonth
as 
select year(orderDate) SaleYear
	,DateNAME(MONTH,orderDate) as [SaleMonth]
	,count(orderId) as NumberOfOrders
	,sum(TotalAmount) TotalSales 
from dbo.Orders 
group BY year(orderDate), DateNAME(MONTH,orderDate), MONTH(orderDate)
order by YEAR (OrderDate), MONTH(orderDate) offset 0 rows;

-- view
create view ProductStatistic
as 
select p.ProductID 
	, sum(op.Quantity) 
		+ (case when sum(case when r2.ReprocessID is not null then op.Quantity end)is not null 
			then sum(case when r2.ReprocessID is not null then op.Quantity end)
			else 0 end) as NumOfProducedProducts
	,(case when sum(case when r.ReturnID is null then op.Quantity end) is not null 
		then sum(case when r.ReturnID is null then op.Quantity end)
		else 0 end) as NumOfSoldProducts
	, (case when sum(case when r.ReturnID is not null then op.Quantity end) is not null 
		then sum(case when r.ReturnID is not null then op.Quantity end)
		else 0 end) as NumOfReturnedProducts
	, (case when sum(case when r2.ReprocessID is not null then op.Quantity end) is not null 
		then sum(case when r2.ReprocessID is not null then op.Quantity end)
		else 0 end) as NumOfReproducedProducts
from Orders o 
join PackageManufacturingDatabaseSystem.dbo.OrderProducts op on o.OrderID = op.OrderID 
join PackageManufacturingDatabaseSystem.dbo.Products p on p.ProductID = op.ProductID 
left join [Returns] r on r.OrderID = op.OrderID and r.ProductID = op.ProductID
left join Reprocess r2 on r2.OrderID = op.OrderID and r2.ProductID = op.ProductID 
group by p.ProductID;


drop trigger CustomerIdUpdate
CLOSE SYMMETRIC KEY ProjectSymmetricKey;
DROP SYMMETRIC KEY ProjectSymmetricKey;
DROP CERTIFICATE ProjectCertificate;
DROP MASTER KEY;

--Insert data in Customer
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Dominos', '1234567890', 'dominos@gmail.com', 'USA', 'Washington', 'Bothell', '20806 Bothell', 'Everett Hwy Suite 106', '98121', 200);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('WalMart', '2456754321', 'wm@gmail.com', 'USA', 'Washington', 'Bellevue', '986 Aloha', 'Downtown', '98606', 201);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PizzHut', '2345678910', 'pizzhut@gmail.com', 'USA', 'washington', 'Bellevue', '15210 SE 37th st', '', '98007', 202);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('H&M', '2345678911', 'HM@gmail.com', 'USA', 'washington', 'Seattle', '2604 NE', 'University village st', '98101', 203);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Uhaul', '2345678912', 'uhaul@gmail.com', 'USA', 'washington', 'Redmond', '18024', 'Redmond way', '98008', 204);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('GapCloths', '2345678913', 'Gap@gmail.com', 'USA', 'washington', 'Bellevue', '4625 27th Ave', 'NE st #23', '98105', 205);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('TommyHilfigerPerfume', '2345678914', 'tho@gmail.com', 'USA', 'washington', 'Tacoma', 'macys', 'Tacoma mall', '98409', 206);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('SeattleProfessionalMovers', '2345678915', 'spm@gmail.com', 'USA', 'washington', 'Seattle', 'NW 61st St', '', '98101', 207);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PeopleMovers', '2345678916', 'peoplemovers@gmail.com', 'USA', 'washington', 'Renton', 'N 103rd ST', '', '98055', 208);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('IKEA', '2345678917', 'ikea@gmail.com', 'USA', 'washington', 'Redmond', '601 SW', '41st ST', '98057', 209);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('DollarTree', '2345678918', 'dollartree@gmail.com', 'USA', 'washington', 'Seattle', '', '', '98101', 210);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Dominos', '1234567890', 'dominos2@gmail.com', 'USA', 'Montana', 'Helena', '20806 Helena', 'Everett Hwy Suite 106', '59601', 218);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('WalMart', '2456754321', 'wm@gmail2.com', 'USA', 'Texas', 'Austin', '986 Aloha', 'Downtown', '98606', 219);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PizzHut', '2345678910', 'pizzhut2@gmail.com', 'USA', 'California', 'San Jose', '15210 SE 37th st', '', '98007', 220);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('H&M', '2345678911', 'HM2@gmail.com', 'USA', 'Texas', 'Dallas', '2604 NE', 'University village st', '98101', 221);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Uhaul', '2345678912', 'uhaul2@gmail.com', 'USA', 'Arizona', 'Phoenix', '18024', 'Redmond way', '98008', 222);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('GapCloths', '2345678913', 'Gap2@gmail.com', 'USA', 'Colarado', 'Denver', '4625 27th Ave', 'NE st #23', '98105', 223);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('TommyHilfigerPerfume', '2345678914', 'tho2@gmail.com', 'USA', 'Ohio', 'Cincinnati', 'macys', 'Tacoma mall', '98409', 224);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('SeattleProfessionalMovers', '2345678915', 'spm2@gmail.com', 'USA', 'Utah', 'Moab', 'NW 61st St', '', '98101', 225);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PeopleMovers', '2345678916', 'peoplemovers2@gmail.com', 'USA', 'Arizona', 'Phoenix', 'N 103rd ST', '', '98055', 226);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('IKEA', '2345678917', 'ikea2@gmail.com', 'USA', 'Texas', 'Austin', '601 SW', '41st ST', '98057', 227);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('DollarTree', '2345678918', 'dollartree2@gmail.com', 'USA', 'Ohio', 'Cleveland', '', '', '98101', 228);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Dominos', '1234567890', 'dominos3@gmail.com', 'USA', 'Montana', 'Helena', '20806 Helena', 'Everett Hwy Suite 106', '59601', 229);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('WalMart', '2456754321', 'wm@gmail3.com', 'USA', 'Texas', 'Austin', '986 Aloha', 'Downtown', '98606', 230);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PizzHut', '2345678910', 'pizzhut3@gmail.com', 'USA', 'California', 'San Jose', '15210 SE 37th st', '', '98007', 231);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('H&M', '2345678911', 'HM3@gmail.com', 'USA', 'Texas', 'Dallas', '2604 NE', 'University village st', '98101', 232);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Uhaul', '2345678912', 'uhaul3@gmail.com', 'USA', 'Arizona', 'Phoenix', '18024', 'Redmond way', '98008', 233);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('GapCloths', '2345678913', 'Gap3@gmail.com', 'USA', 'Colarado', 'Denver', '4625 27th Ave', 'NE st #23', '98105', 234);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('TommyHilfigerPerfume', '2345678914', 'tho3@gmail.com', 'USA', 'Ohio', 'Cincinnati', 'macys', 'Tacoma mall', '98409', 235);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('SeattleProfessionalMovers', '2345678915', 'spm3@gmail.com', 'USA', 'Utah', 'Moab', 'NW 61st St', '', '98101', 236);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PeopleMovers', '2345678916', 'peoplemovers3@gmail.com', 'USA', 'Arizona', 'Phoenix', 'N 103rd ST', '', '98055', 237);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('IKEA', '2345678917', 'ikea3@gmail.com', 'USA', 'Texas', 'Austin', '601 SW', '41st ST', '98057', 238);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('DollarTree', '2345678918', 'dollartree3@gmail.com', 'USA', 'Ohio', 'Cleveland', '', '', '98101', 239);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Dominos', '1234567890', 'dominos4@gmail.com', 'USA', 'Nebraska', 'Omaha', '20806 Helena', 'Everett Hwy Suite 106', '59601', 240);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('WalMart', '2456754321', 'wm@gmail4.com', 'USA', 'Nebraska', 'Omaha', '986 Aloha', 'Downtown', '98606', 241);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PizzHut', '2345678910', 'pizzhut4@gmail.com', 'USA', 'Nebraska', 'Lincoln', '15210 SE 37th st', '', '98007', 242);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('H&M', '2345678911', 'HM4@gmail.com', 'USA', 'Nebraska', 'Bellevue', '2604 NE', 'University village st', '98101', 243);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Uhaul', '2345678912', 'uhaul4@gmail.com', 'USA', 'Arizona', 'Phoenix', '18024', 'Redmond way', '98008', 244);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('GapCloths', '2345678913', 'Gap4@gmail.com', 'USA', 'Colarado', 'Denver', '4625 27th Ave', 'NE st #23', '98105', 245);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('TommyHilfigerPerfume', '2345678914', 'tho4@gmail.com', 'USA', 'Ohio', 'Cincinnati', 'macys', 'Tacoma mall', '98409', 246);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('SeattleProfessionalMovers', '2345678915', 'spm4@gmail.com', 'USA', 'Utah', 'Provo', 'NW 61st St', '', '98101', 247);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PeopleMovers', '2345678916', 'peoplemovers4@gmail.com', 'USA', 'Arizona', 'Phoenix', 'N 103rd ST', '', '98055', 248);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('IKEA', '2345678917', 'ikea4@gmail.com', 'USA', 'Texas', 'Austin', '601 SW', '41st ST', '98057', 249);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('DollarTree', '2345678918', 'dollartree4@gmail.com', 'USA', 'Ohio', 'Cleveland', '', '', '98101', 250);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Dominos', '1234567890', 'dominos5@gmail.com', 'USA', 'Nebraska', 'Omaha', '20806 Helena', 'Everett Hwy Suite 106', '59601', 251);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('WalMart', '2456754321', 'wm5@gmail.com', 'USA', 'Nebraska', 'Omaha', '986 Aloha', 'Downtown', '98606', 252);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PizzHut', '2345678910', 'pizzhut5@gmail.com', 'USA', 'Nebraska', 'Lincoln', '15210 SE 37th st', '', '98007', 253);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('H&M', '2345678911', 'HM5@gmail.com', 'USA', 'Nebraska', 'Bellevue', '2604 NE', 'University village st', '98101', 254);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('Uhaul', '2345678912', 'uhaul5@gmail.com', 'USA', 'Arizona', 'Phoenix', '18024', 'Redmond way', '98008', 255);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('GapCloths', '2345678913', 'Gap5@gmail.com', 'USA', 'Colarado', 'Denver', '4625 27th Ave', 'NE st #23', '98105', 256);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('TommyHilfigerPerfume', '2345678914', 'tho5@gmail.com', 'USA', 'Ohio', 'Cincinnati', 'macys', 'Tacoma mall', '98409', 257);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('SeattleProfessionalMovers', '2345678915', 'spm5@gmail.com', 'USA', 'Utah', 'Provo', 'NW 61st St', '', '98101', 258);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PeopleMovers', '2345678916', 'peoplemovers5@gmail.com', 'USA', 'Arizona', 'Phoenix', 'N 103rd ST', '', '98055', 259);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('IKEA', '2345678917', 'ikea5@gmail.com', 'USA', 'Texas', 'Austin', '601 SW', '41st ST', '98057', 260);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('DollarTree', '2345678918', 'dollartree5@gmail.com', 'USA', 'Ohio', 'Cleveland', '', '', '98101', 261);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('GapCloths', '2345678913', 'Gap6@gmail.com', 'USA', 'Colarado', 'Denver', '4625 27th Ave', 'NE st #23', '98105', 262);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('TommyHilfigerPerfume', '2345678914', 'tho6@gmail.com', 'USA', 'Ohio', 'Cincinnati', 'macys', 'Tacoma mall', '98409', 263);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('SeattleProfessionalMovers', '2345678915', 'spm6@gmail.com', 'USA', 'Utah', 'Provo', 'NW 61st St', '', '98101', 264);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('PeopleMovers', '2345678916', 'peoplemovers6@gmail.com', 'USA', 'Arizona', 'Phoenix', 'N 103rd ST', '', '98055', 265);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('IKEA', '2345678917', 'ikea6@gmail.com', 'USA', 'Texas', 'Austin', '601 SW', '41st ST', '98057', 266);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Customer
(CompanyName, ContactNumber, EmailID, Country, State, City, Address1, Address2, ZipCode, CustomerID)
VALUES('DollarTree', '2345678918', 'dollartree6@gmail.com', 'USA', 'Ohio', 'Cleveland', '', '', '98101', 267);

--Insert in Orders
 INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(315, 215, 'Delivered', '2019-04-04', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(316, 216, 'processed', '2020-11-11', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(317, 217, 'Refund Processed', '2020-11-11', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(318, 218, 'Initiated', '2021-01-11', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(319, 219, 'Pending', '2021-02-12', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(320, 220, 'processing', '2021-02-13', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(321, 221, 'processed', '2021-03-01', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(322, 222, 'Delivered', '2020-04-18', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(323, 223, 'processed', '2019-03-20', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(324, 224, 'Delivered', '2020-03-28', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(325, 225, 'Delivered', '2020-05-12', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(326, 226, 'Delivered', '2020-12-13', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(327, 227, 'Delivered', '2020-12-13', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(328, 228, 'Delivered', '2019-08-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(329, 229, 'Delivered', '2020-02-13', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(330, 230, 'Delivered', '2020-09-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(331, 231, 'Delivered', '2020-12-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(332, 232, 'Delivered', '2020-06-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(333, 233, 'Delivered', '2020-12-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(334, 234, 'Delivered', '2020-06-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(341, 240, 'Delivered', '2020-12-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(342, 241, 'Delivered', '2020-12-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(343, 242, 'Delivered', '2020-08-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(344, 243, 'Processing', '2020-12-15', 0);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(345, 244, 'Delivered', '2019-04-04', NULL);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.Orders
(OrderID, CustomerID, Status, OrderDate, TotalAmount)
VALUES(346, 245, 'Refunded', '2019-04-04', NULL);


--Insert Order products
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(307, 802, 87);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(307, 807, 34);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(308, 801, 70);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(308, 806, 109);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(308, 808, 31);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(309, 803, 45);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(309, 809, 32);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(310, 800, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(310, 807, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(310, 808, 10);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(310, 810, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(311, 803, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(311, 805, 30);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(312, 802, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(312, 804, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(313, 806, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(313, 807, 302);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(314, 805, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(314, 806, 33);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(315, 803, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(315, 804, 355);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(316, 802, 36);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(316, 808, 83);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(316, 809, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(317, 800, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(317, 804, 366);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(317, 807, 553);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(318, 800, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(318, 801, 36);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(318, 807, 23);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(319, 800, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(319, 802, 33);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(319, 805, 13);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(320, 800, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(320, 802, 63);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(320, 803, 32);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(321, 800, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(321, 801, 23);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(321, 806, 33);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(322, 800, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(322, 805, 31);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(322, 807, 73);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 800, 3);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 801, 5);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 802, 45);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 803, 25);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 804, 6);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 805, 35);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 806, 51);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 807, 25);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 808, 52);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 809, 63);
INSERT INTO PackageManufacturingDatabaseSystem.dbo.OrderProducts
(OrderID, ProductID, Quantity)
VALUES(323, 810, 5);

