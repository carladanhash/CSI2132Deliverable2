DELIMITER $$

CREATE TRIGGER delete_bookings_after_customer_is_deleted
AFTER DELETE ON Customer
FOR EACH ROW 
BEGIN
    DELETE FROM Booking
    WHERE Booking.Customer_ID = OLD.Customer_ID;
END $$

DELIMITER ;
