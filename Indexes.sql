USE `e-Hotels`;

-- Index to speed up searching for customer bookings
CREATE INDEX idx_booking_customer_date ON Booking(Customer_ID, Start_Date);

-- Index to improve room lookups by hotel and room number
CREATE UNIQUE INDEX idx_room_hotel ON Room(Hotel_ID, Room_Number);

-- Index to quickly filter employees by role in a specific hotel
CREATE INDEX idx_employee_hotel_role ON Employee(Hotel_ID, Employee_Role);

-- Index for fast room availability checks (Room_ID, Start_Date, End_Date)
CREATE INDEX idx_room_availability ON Booking(Room_ID, Start_Date, End_Date);

-- Index for searching rooms by price in a given area
CREATE INDEX idx_room_price_area ON Room(Price, Hotel_ID);

-- Index to speed up hotel lookups by address (useful for searching rooms in a location)
CREATE INDEX idx_hotel_address ON Hotel(Address);

SHOW INDEXES FROM Booking;
SHOW INDEXES FROM Room;
SHOW INDEXES FROM Hotel;
SHOW INDEXES FROM Employee;
