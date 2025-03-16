USE `e-Hotels`;
CREATE VIEW RoomCapacityAndViewByAddress AS
SELECT 
    h.Address AS Area,
    h.Hotel_Name,
    r.View_Type,
    COUNT(r.Room_ID) AS Total_Rooms,
    SUM(
        CASE 
            WHEN r.Room_Capacity = 'Single' THEN 1
            WHEN r.Room_Capacity = 'Double' THEN 2
            WHEN r.Room_Capacity = 'Suite' THEN 4
            WHEN r.Room_Capacity = 'Family' THEN 6
            ELSE 1  -- Default if capacity is unknown
        END
    ) AS Total_Capacity
FROM Room r
JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID
GROUP BY h.Address, h.Hotel_Name, r.View_Type
ORDER BY h.Address, r.View_Type;
