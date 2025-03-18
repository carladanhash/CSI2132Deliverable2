DELIMITER $$

CREATE TRIGGER remove_employee_after_hotel_shutdown
AFTER DELETE ON Hotel
FOR EACH ROW 
BEGIN
    DELETE FROM Employee
    WHERE Employee.Hotel_ID = OLD.Hotel_ID;
END $$

DELIMITER ;

