create view OrderDetailsPerMonth
as 
select year(orderDate) SaleYear
	,DateNAME(MONTH,orderDate) as [SaleMonth]
	,count(orderId) as NumberOfOrders
	,sum(TotalAmount) TotalSales 
from dbo.Orders 
group BY year(orderDate), DateNAME(MONTH,orderDate), MONTH(orderDate)
order by YEAR (OrderDate), MONTH(orderDate) offset 0 rows;


create view ProductStatistic
as 
select p.ProductID , sum(op.Quantity) 
		+ isnull(sum(case when r2.ReprocessID is not null then op.Quantity end),0) as NumOfProducedProducts
	,isnull(sum(case when r.ReturnID is null then op.Quantity end),0) as NumOfSoldProducts
	,isnull(sum(case when r.ReturnID is not null then op.Quantity end),0) as NumOfReturnedProducts
	,isnull(sum(case when r2.ReprocessID is not null then op.Quantity end),0) as NumOfReproducedProducts
from Orders o 
join PackageManufacturingDatabaseSystem.dbo.OrderProducts op on o.OrderID = op.OrderID 
join PackageManufacturingDatabaseSystem.dbo.Products p on p.ProductID = op.ProductID 
left join [Returns] r on r.OrderID = op.OrderID and r.ProductID = op.ProductID
left join Reprocess r2 on r2.OrderID = op.OrderID and r2.ProductID = op.ProductID 
group by p.ProductID;
