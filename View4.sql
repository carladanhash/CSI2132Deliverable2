USE `e-Hotels`;

CREATE VIEW RoomPricesPerView AS
SELECT 
    h.Address AS Area,
    h.Hotel_Name,
    r.View_Type,
    COUNT(r.Room_ID) AS Total_Rooms,
    MIN(r.Price) AS Min_Price,
    AVG(r.Price) AS Avg_Price,
    MAX(r.Price) AS Max_Price
FROM Room r
JOIN Hotel h ON r.Hotel_ID = h.Hotel_ID
GROUP BY h.Address, h.Hotel_Name, r.View_Type
ORDER BY h.Address, r.View_Type;
