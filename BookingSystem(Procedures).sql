use littlelemondm;

insert into Bookings(BookingID, Date, TableNumber, CustomerID, NumberOFGuest)
VALUES (1, "2022-10-10", 5, 1, 2),
(2, "2022-11-12", 3, 3, 2),
(3, "2022-10-11", 2, 2, 2),
(4, "2022-10-13", 2, 1, 2);

select * from bookings;

DELIMITER //
create procedure CheckBooking(bookingDate date, tableNo INT)
	BEGIN
		DECLARE datecheck date;
		DECLARE tablecheck INT;
        
        SET datecheck = (select Date from Bookings where Date = bookingDate LIMIT 1);
		SET tablecheck = (select TableNumber From Bookings where TableNumber = tableNo LIMIT 1);
        
        IF (datecheck = bookingDate and tablecheck = tableNo)
			THEN select CONCAT("Table " , tableNo, " is already booked") AS BookingStatus;
		ELSE select CONCAT("Table " , tableNo, " is free") AS BookingStatus;
		end if;
	END//
DELIMITER ;
call CheckBooking("2022-10-18", 2);

DELIMITER //
create procedure AddValidBooking(bookingDate date, tableNo INT)
BEGIN
	DECLARE IDmax INT;
    DECLARE datecheck date;
	DECLARE tablecheck INT;
	
    start transaction;
    SET IDmax = (select MAX(BookingID) from Bookings);
    SET datecheck = (select Date from Bookings where Date = bookingDate LIMIT 1);
	SET tablecheck = (select TableNumber From Bookings where TableNumber = tableNo LIMIT 1);
        
	IF (datecheck = bookingDate and tablecheck = tableNo)
		THEN select CONCAT("Table " , tableNo, " is already booked - booking cancelled") AS BookingStatus;
        rollback;
	ELSE 
		INSERT INTO Bookings(BookingID, Date, TableNumber, CustomerID, NumberOFGuest)
			VALUES (IDmax + 1, bookingDate, tableNo, 1, 2);
		select CONCAT("Table " , tableNo, " is booked - booking compleated") AS BookingStatus;
        commit;
	end if;
END //
DELIMITER ;
call AddValidBooking("2022-10-18", 5);

DELIMITER //
create procedure AddBooking(bID INT, cID INT, bookingDate date, tableNo INT)
BEGIN
	DECLARE bookingIDcheck INT;
    DECLARE datecheck date;
	DECLARE tablecheck INT;
	
    SET bookingIDcheck = (select BookingID from Bookings where bookingID = bID LIMIT 1);
    SET datecheck = (select Date from Bookings where Date = bookingDate LIMIT 1);
	SET tablecheck = (select TableNumber From Bookings where TableNumber = tableNo LIMIT 1);
        
	IF (datecheck = bookingDate and tablecheck = tableNo)
		THEN select CONCAT("Table " , tableNo, " is already booked - booking not created") AS BookingStatus;
	ELSEIF (bookingIDcheck = bID)
		THEN select CONCAT("Table " , tableNo, " is free but the BookingID number can not be reapeted - booking not created") AS BookingStatus;
	ELSE 
		INSERT INTO Bookings(BookingID, Date, TableNumber, CustomerID, NumberOFGuest)
			VALUES (bID, bookingDate, tableNo, cID, 2);
		select CONCAT("Table " , tableNo, " is booked - booking compleated") AS BookingStatus;
	end if;
END //
DELIMITER ;
call AddBooking(6, 1, "2022-10-19", 3);

DELIMITER //
create procedure UpdateBooking(bID INT, changeDate date)
BEGIN
	DECLARE bookingIDcheck INT;
    SET bookingIDcheck = (select BookingID from Bookings where bookingID = bID LIMIT 1);
    
    IF(bookingIDcheck = bID)
		THEN update Bookings SET Date = changeDate where BookingID = bID;
			select CONCAT("Booking ", bID, " updated") AS Conifrmation;
	ELSE 
		select CONCAT("BookingID number does not exists") AS Conifrmation;
	END IF;
END //
DELIMITER ;
call UpdateBooking(1, "2022-10-09");

DELIMITER //
create procedure CancelBooking(bID INT)
BEGIN
	DECLARE bookingIDcheck INT;
    SET bookingIDcheck = (select BookingID from Bookings where bookingID = bID LIMIT 1);
    
    IF(bookingIDcheck = bID)
		THEN delete from Bookings where BookingID = bID;
			select CONCAT("Booking ", bID, " cancelled") AS Conifrmation;
	ELSE 
		select CONCAT("BookingID number does not exists") AS Conifrmation;
	END IF;
END //
DELIMITER ;
call CancelBooking(6);
drop procedure cancelBooking;