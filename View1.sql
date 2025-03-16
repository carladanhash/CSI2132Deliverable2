USE `e-Hotels`;
CREATE VIEW AvailableRoomsPerArea AS
SELECT 
    h.Address AS Area,
    h.Hotel_Name,
    COUNT(r.Room_ID) AS Available_Rooms
FROM Room r
JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID
LEFT JOIN Booking b ON r.Room_ID = b.Room_ID 
    AND b.Booking_Status = 'Checked-In' 
    AND CURDATE() BETWEEN b.Start_Date AND b.End_Date
WHERE b.Room_ID IS NULL  -- Only include rooms that are NOT booked
GROUP BY h.Address, h.Hotel_Name;
