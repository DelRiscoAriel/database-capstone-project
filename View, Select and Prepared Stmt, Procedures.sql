use littlelemondm;

create view OrdersView as 
select OrderID, Quantity, TotalCost as Cost
from Orders where Quantity > 2;

select * from OrdersView;

select Customers.CustomerID, CONCAT(Customers.FirstName, " ",Customers.LastName) AS FullName, Orders.OrderID, Orders.TotalCost, Manus.ManuID, Manus.Courses
from Orders inner join Bookings on Orders.BookingID = Bookings.BookingID
inner join Customers on Bookings.CustomerID = Customers.CustomerID
inner join Manus on Orders.MenuID = Manus.ManuID;

select ManuID from Manus
where ManuID in (select ManuID From Orders where Quantity > 2);

DELIMITER //
CREATE procedure GetMaxQuantity() 
	BEGIN
		select MAX(Quantity) AS 'Max Quantity in Orders'from Orders;
	END //
DELIMITER ;

Call GetMaxQuantity();

prepare GetOrderDetail From 'select OrderID, Quantity, TotalCost From Orders where OrderID = ?';

set @id = 1;
EXECUTE GetOrderDetail USING @id;

DELIMITER //
CREATE procedure CancelOrder(id int) 
	BEGIN
		delete from Orders where OrderID = id;
        select CONCAT('Order(', id, ') is cancelled') AS Confirmation;
	END //
DELIMITER ;

call CancelOrder(5);