DELIMITER $$

CREATE TRIGGER prevent_booking_of_damaged_rooms
BEFORE INSERT ON Booking 
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Room 
        WHERE Room.RoomNumber = NEW.Room_Number 
        AND Room.Hotel_ID = NEW.Hotel_ID
        AND Room.Damages = 'Pending Repair'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot book room that contains unresolved damages.';
    END IF;
END $$

DELIMITER ;
