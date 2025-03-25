-- QUERY 1: Find Customers Who have booked the most expensive room in any hotel.

SELECT C.First_Name, C.Last_Name, B.Booking_ID, R.Price AS Room_Price, H.Hotel_Name
FROM Customer C
JOIN Booking AS B ON C.Customer_ID = B.Customer_ID
JOIN Room AS R ON B.Room_ID = R.Room_ID
JOIN Hotel AS H ON R.Hotel_ID = H.Hotel_ID
WHERE R.Price = (
    SELECT MAX(R1.Price) FROM Room R1 WHERE R1.Hotel_ID = R.Hotel_ID
)
ORDER BY R.Price;

-- -----------------------------------------------------------------------------

-- QUERY 2: Find all Employees that work in a 5-star hotel. [3 rows for result]

SELECT E.First_Name, E.Last_Name, H.Hotel_Name
FROM Employee AS E
JOIN Hotel H ON E.Hotel_ID = H.Hotel_ID
WHERE H.Category = '5-Star';

-- ---------------------------------------------------------------------------------

-- QUERY 3: Find out how many customers booked a hotel with the address 234 Ocean Blvd, Luxury City, LC.

SELECT COUNT(DISTINCT B.Customer_ID) AS Total_Customers
FROM Booking AS B
JOIN Hotel AS H ON B.Hotel_ID = H.Hotel_ID
WHERE H.Address = '234 Ocean Blvd, Luxury City, LC';

-- ---------------------------------------------------------------------------------

-- QUERY 4: Which employee made the renting with the hotel ID 20000.

SELECT E.First_Name, E.Last_Name
FROM Renting AS R
JOIN Employee AS E ON R.Employee_ID = E.Employee_ID
WHERE R.Hotel_ID = 20000;

-- -----------------------------------------------------------------------------------

-- QUERY 5: Find the Employees that work in Hotels that have at least one room that is priced above the average room price.

SELECT DISTINCT E.First_Name, E.Last_Name, E.Employee_Role, H.Hotel_Name
FROM Employee AS E
JOIN Hotel AS H ON E.Hotel_ID = H.Hotel_ID
WHERE H.Hotel_ID IN (
    SELECT DISTINCT R.Hotel_ID
    FROM Room AS R
    WHERE R.Price > (SELECT AVG(Price) FROM Room)
);






