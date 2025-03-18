DELIMITER $$

CREATE TRIGGER prevent_last_minute_cancellation
BEFORE UPDATE ON Booking
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Cancelled' AND TIMESTAMPDIFF(HOUR, CURRENT_TIMESTAMP, OLD.Start_Date) < 24 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot cancel booking within 24 hours of the start date.';
    END IF;
END$$

DELIMITER ;



