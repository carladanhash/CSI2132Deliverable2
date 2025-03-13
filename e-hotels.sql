DROP DATABASE IF EXISTS `e-Hotels`;
CREATE DATABASE `e-Hotels`;
USE `e-Hotels`;

-- HOTEL CHAIN TABLE; 
CREATE TABLE HotelChain (
    Chain_ID INT AUTO_INCREMENT PRIMARY KEY,
    Chain_Name VARCHAR(50) NOT NULL UNIQUE,
    Number_Of_Hotels INT NOT NULL DEFAULT 0,
    CentralOffice_Address VARCHAR(255) NOT NULL
);
-- Set the starting value of the auto-increment of the chain_id 
ALTER TABLE HotelChain AUTO_INCREMENT = 10000;

-- HOTEL TABLE;
CREATE TABLE Hotel (
 Hotel_ID INT AUTO_INCREMENT PRIMARY KEY,
 Chain_ID INT NOT NULL,
 Hotel_Name VARCHAR(50) NOT NULL,
 Address VARCHAR(255) NOT NULL,
 Category ENUM('1-Star', '2-Star', '3-Star', '4-Star', '5-Star') NOT NULL,
 Number_Of_Rooms INT NOT NULL,
 FOREIGN KEY (Chain_ID) REFERENCES HotelChain(Chain_ID) ON DELETE CASCADE
);
-- Set the starting value of the auto-increment of the hotel_id 
ALTER TABLE Hotel AUTO_INCREMENT = 20000;

-- CUSTOMER TABLE
CREATE TABLE Customer (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    IDType ENUM('SSN', 'SIN', 'Driving_License') NOT NULL,
    ID_Number VARCHAR(50) NOT NULL UNIQUE,
    Date_Of_Registration DATE NOT NULL
);
-- Set the starting value of the auto-increment of the hotel_id 
ALTER TABLE Customer AUTO_INCREMENT = 300000;


-- EMPLOYEE TABLE
CREATE TABLE Employee (
    Employee_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Employee_Role ENUM('Manager', 'Receptionist', 'Housekeeping', 'Security') NOT NULL,
    Hotel_ID INT NOT NULL,
    FOREIGN KEY (Hotel_ID) REFERENCES Hotel(Hotel_ID) ON DELETE CASCADE
);
-- Set the starting value of the auto-increment of the hotel_id 
ALTER TABLE Employee AUTO_INCREMENT = 40000;


-- CONTACT TABLE
CREATE TABLE Contact (
    Contact_ID INT AUTO_INCREMENT PRIMARY KEY,
    Entity_Type ENUM('HOTEL_CHAIN', 'HOTEL', 'CUSTOMER') NOT NULL,
    Entity_ID INT NOT NULL,
    Contact_Type ENUM('EMAIL', 'PHONE') NOT NULL,
    Contact_Value VARCHAR(255) NOT NULL
);
-- Set the starting value of the auto-increment of the hotel_id 
ALTER TABLE Contact AUTO_INCREMENT = 50000;



-- ROOM TABLE
CREATE TABLE Room (
    Room_ID INT AUTO_INCREMENT PRIMARY KEY, 
    Room_Number INT UNIQUE,  
    Hotel_ID INT NOT NULL,           
    Room_Capacity ENUM('Single', 'Double', 'Suite', 'Family') NOT NULL,
    Extendable BOOLEAN DEFAULT FALSE,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    View_Type ENUM('Sea', 'Mountain') NOT NULL,
    Damage_Status ENUM('None', 'Pending Repair') DEFAULT 'None',
    FOREIGN KEY (Hotel_ID) REFERENCES Hotel(Hotel_ID) ON DELETE CASCADE
);

-- Set the starting value of the auto-increment for Room_NUMBER
ALTER TABLE Room AUTO_INCREMENT = 1;

-- ROOM AMENITIES TABLE (TO HANDLE MULTIPLE AMENITIES PER ROOM)
CREATE TABLE RoomAmenities (
    Room_ID INT NOT NULL,
    Amenity VARCHAR(100) NOT NULL,
    PRIMARY KEY (Room_ID, Amenity),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID) ON DELETE CASCADE
);


-- BOOKING TABLE
CREATE TABLE Booking (
   Booking_ID INT AUTO_INCREMENT PRIMARY KEY,
   Customer_ID INT NOT NULL,
   Room_ID INT NOT NULL,
   Hotel_ID INT NOT NUlL,
   Start_Date DATETIME NOT NULL,
   End_Date DATETIME NOT NULL,
   Employee_ID INT,  -- Employee who handles the booking (optional)
   Booking_Status  ENUM('Pending', 'Checked-In', 'Cancelled') DEFAULT 'Pending',
   FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE,
   FOREIGN KEY (Room_ID) REFERENCES Room (Room_ID) ON DELETE CASCADE,
   FOREIGN KEY (Hotel_ID) REFERENCES Hotel (Hotel_ID) ON DELETE CASCADE,
   FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE SET NULL
);
-- Set the starting value of the auto-increment of the hotel_id 
ALTER TABLE Booking AUTO_INCREMENT = 60000;


-- RENTING TABLE
CREATE TABLE Renting (
    Renting_ID INT AUTO_INCREMENT PRIMARY KEY,
    Hotel_ID INT NOT NULL,
    Employee_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Booking_ID INT NULL, 
    Room_ID INT NOT NULL,
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NOT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID) ON DELETE SET NULL,
    FOREIGN KEY (Hotel_ID) REFERENCES Hotel(Hotel_ID) ON DELETE CASCADE,
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID) ON DELETE CASCADE
);
-- Set the starting value of the auto-increment of the hotel_id 
ALTER TABLE Renting AUTO_INCREMENT = 70000;

-- ARCHIVE TABLE (FOR HISTORICAL DATA)
CREATE TABLE Archive (
    Archive_ID INT AUTO_INCREMENT PRIMARY KEY,
    Entity_Type ENUM('BOOKING', 'RENTING') NOT NULL,
    Entity_ID INT NOT NULL,
    Archive_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Booking ADD CONSTRAINT chk_Booking_Dates CHECK (Start_Date < End_Date);

DELIMITER //
CREATE TRIGGER prevent_double_booking
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Booking 
        WHERE Room_ID = NEW.Room_ID
        AND Booking_Status = 'Checked-In'
        AND (NEW.Start_Date BETWEEN Start_Date AND End_Date 
            OR NEW.End_Date BETWEEN Start_Date AND End_Date)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Room is already booked for the selected period.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER prevent_last_minute_cancellation
BEFORE UPDATE ON Booking
FOR EACH ROW
BEGIN
    IF OLD.Booking_Status = 'Checked-In' AND NEW.Booking_Status = 'Cancelled' AND TIMESTAMPDIFF(HOUR, NOW(), OLD.Start_Date) < 24 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot cancel a booking less than 24 hours before check-in.';
    END IF;
END;
//
DELIMITER ;

-- Insert Hotel Chains
INSERT INTO HotelChain (Chain_Name, Number_Of_Hotels, CentralOffice_Address)
VALUES
('Luxury Stays', 8, '123 Luxury Blvd, Luxury City, LC'),
('Comfort Suites', 8, '456 Comfort Rd, Comfort Town, CT'),
('Budget Inns', 8, '789 Budget St, Budget City, BC'),
('Exclusive Resorts', 8, '101 Exclusive Ln, Elite Town, ET'),
('Global Hotels', 8, '202 Global Ave, Global City, GC');

-- Insert Hotels for each Hotel Chain
-- Luxury Stays
INSERT INTO Hotel (Chain_ID, Hotel_Name, Address, Category, Number_Of_Rooms)
VALUES
(10000, 'Luxury Stays Downtown', '123 Luxury Blvd, Luxury City, LC', '5-Star', 10),
(10000, 'Luxury Stays Seaside', '234 Ocean Blvd, Luxury City, LC', '5-Star', 8),
(10000, 'Luxury Stays Mountain View', '345 Mountain Rd, Luxury City, LC', '4-Star', 10),
(10000, 'Luxury Stays Garden Resort', '567 Garden Rd, Luxury City, LC', '4-Star', 9),
(10000, 'Luxury Stays Desert Retreat', '890 Desert Dr, Luxury City, LC', '5-Star', 7),
(10000, 'Luxury Stays Lakeview', '123 Lakeside Dr, Luxury City, LC', '5-Star', 8),
(10000, 'Luxury Stays Downtown 2', '125 Luxury Blvd, Luxury City, LC', '4-Star', 5),
(10000, 'Luxury Stays Beach Resort', '234 Ocean Blvd, Luxury City, LC', '5-Star', 6);

-- Comfort Suites
INSERT INTO Hotel (Chain_ID, Hotel_Name, Address, Category, Number_Of_Rooms)
VALUES
(10001, 'Comfort Suites Downtown', '456 Comfort Rd, Comfort Town, CT', '3-Star', 10),
(10001, 'Comfort Suites Lakeside', '567 Lakeside Ave, Comfort Town, CT', '3-Star', 7),
(10001, 'Comfort Suites Mountain View', '678 Mountain Ave, Comfort Town, CT', '3-Star', 8),
(10001, 'Comfort Suites Oceanfront', '789 Ocean Blvd, Comfort Town, CT', '3-Star', 9),
(10001, 'Comfort Suites Garden', '890 Garden Rd, Comfort Town, CT', '2-Star', 8),
(10001, 'Comfort Suites City Center', '123 City Rd, Comfort Town, CT', '2-Star', 6),
(10001, 'Comfort Suites Valley', '234 Valley Rd, Comfort Town, CT', '3-Star', 7),
(10001, 'Comfort Suites Beach', '345 Beach Rd, Comfort Town, CT', '3-Star', 8);

-- Budget Inns
INSERT INTO Hotel (Chain_ID, Hotel_Name, Address, Category, Number_Of_Rooms)
VALUES
(10002, 'Budget Inn City Center', '789 Budget St, Budget City, BC', '2-Star', 8),
(10002, 'Budget Inn Seaside', '890 Ocean Blvd, Budget City, BC', '1-Star', 7),
(10002, 'Budget Inn Downtown', '123 Downtown St, Budget City, BC', '1-Star', 6),
(10002, 'Budget Inn River View', '456 River Rd, Budget City, BC', '2-Star', 10),
(10002, 'Budget Inn Country', '789 Country Rd, Budget City, BC', '1-Star', 5),
(10002, 'Budget Inn City 2', '234 City Rd, Budget City, BC', '2-Star', 9),
(10002, 'Budget Inn Lakeside', '345 Lakeside Ave, Budget City, BC', '1-Star', 8),
(10002, 'Budget Inn Desert', '456 Desert Ave, Budget City, BC', '2-Star', 7);

-- Exclusive Resorts
INSERT INTO Hotel (Chain_ID, Hotel_Name, Address, Category, Number_Of_Rooms)
VALUES
(10003, 'Exclusive Resort Beach', '101 Exclusive Ln, Elite Town, ET', '5-Star', 12),
(10003, 'Exclusive Resort Mountain', '202 Mountain Dr, Elite Town, ET', '5-Star', 9),
(10003, 'Exclusive Resort Lakefront', '303 Lakeview Blvd, Elite Town, ET', '4-Star', 10),
(10003, 'Exclusive Resort Forest', '404 Forest Rd, Elite Town, ET', '5-Star', 8),
(10003, 'Exclusive Resort Desert', '505 Desert Rd, Elite Town, ET', '5-Star', 7),
(10003, 'Exclusive Resort Seaside', '606 Ocean Blvd, Elite Town, ET', '4-Star', 9),
(10003, 'Exclusive Resort Downtown', '707 City Ave, Elite Town, ET', '5-Star', 6),
(10003, 'Exclusive Resort Spa', '808 Spa St, Elite Town, ET', '4-Star', 5);

-- Global Hotels
INSERT INTO Hotel (Chain_ID, Hotel_Name, Address, Category, Number_Of_Rooms)
VALUES
(10004, 'Global Hotel City Center', '202 Global Ave, Global City, GC', '3-Star', 8),
(10004, 'Global Hotel Riverside', '303 River Rd, Global City, GC', '3-Star', 6),
(10004, 'Global Hotel Skyline', '404 Skyline Blvd, Global City, GC', '4-Star', 10),
(10004, 'Global Hotel Beach', '505 Beach Blvd, Global City, GC', '4-Star', 7),
(10004, 'Global Hotel Mountain Retreat', '606 Mountain Dr, Global City, GC', '4-Star', 8),
(10004, 'Global Hotel Lake View', '707 Lake Ave, Global City, GC', '5-Star', 9),
(10004, 'Global Hotel Garden', '808 Garden Blvd, Global City, GC', '3-Star', 8),
(10004, 'Global Hotel Oceanfront', '909 Ocean Blvd, Global City, GC', '5-Star', 6);

-- Insert Rooms for the Hotels (at least 5 rooms for each hotel with different capacities)
-- Luxury Stays Seaside
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(201, 20000, 'Single', FALSE, 180.00, 'Sea', 'None'),
(202, 20000, 'Double', TRUE, 220.00, 'Sea', 'None'),
(203, 20000, 'Suite', FALSE, 550.00, 'Sea', 'None'),
(204, 20000, 'Family', FALSE, 350.00, 'Sea', 'None'),
(205, 20000, 'Double', TRUE, 230.00, 'Sea', 'None');


-- Luxury Stays Garden Resort
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(401, 20000, 'Single', TRUE, 160.00, 'Sea', 'None'),
(402, 20000, 'Double', FALSE, 210.00, 'Sea', 'None'),
(403, 20000, 'Suite', FALSE, 550.00, 'Sea', 'None'),
(404, 20000, 'Family', TRUE, 320.00, 'Sea', 'None'),
(405, 20000, 'Double', TRUE, 230.00, 'Sea', 'None');

-- Comfort Suites Lakeside
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(301, 20001, 'Single', FALSE, 90.00, 'Sea', 'None'),
(302, 20001, 'Double', TRUE, 130.00, 'Sea', 'None'),
(303, 20001, 'Suite', FALSE, 250.00, 'Sea', 'None'),
(304, 20001, 'Family', TRUE, 200.00, 'Sea', 'None'),
(305, 20001, 'Double', FALSE, 180.00, 'Sea', 'None');


-- Budget Inn Seaside
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(501, 20002, 'Single', FALSE, 60.00, 'Sea', 'None'),
(502, 20002, 'Double', TRUE, 100.00, 'Sea', 'None'),
(503, 20002, 'Suite', FALSE, 190.00, 'Sea', 'None'),
(504, 20002, 'Family', FALSE, 140.00, 'Sea', 'None'),
(505, 20002, 'Double', TRUE, 110.00, 'Sea', 'None');

-- Budget Inn Downtown
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(601, 20002, 'Single', TRUE, 70.00, 'Mountain', 'None'),
(602, 20002, 'Double', FALSE, 110.00, 'Mountain', 'None'),
(603, 20002, 'Suite', FALSE, 160.00, 'Mountain', 'None'),
(604, 20002, 'Family', TRUE, 140.00, 'Mountain', 'None'),
(605, 20002, 'Double', TRUE, 100.00, 'Mountain', 'None');

-- Budget Inn River View
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(701, 20002, 'Single', FALSE, 80.00, 'Sea', 'None'),
(702, 20002, 'Double', TRUE, 120.00, 'Sea', 'None'),
(703, 20002, 'Suite', FALSE, 200.00, 'Sea', 'None'),
(704, 20002, 'Family', TRUE, 170.00, 'Sea', 'None'),
(705, 20002, 'Double', TRUE, 130.00, 'Sea', 'None');

-- Exclusive Resort Beach
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(901, 20003, 'Single', TRUE, 250.00, 'Sea', 'None'),
(902, 20003, 'Double', FALSE, 350.00, 'Sea', 'None'),
(903, 20003, 'Suite', FALSE, 700.00, 'Sea', 'None'),
(904, 20003, 'Family', TRUE, 500.00, 'Sea', 'None'),
(905, 20003, 'Double', TRUE, 300.00, 'Sea', 'None');

-- Exclusive Resort Mountain
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(1001, 20003, 'Single', FALSE, 220.00, 'Mountain', 'None'),
(1002, 20003, 'Double', TRUE, 280.00, 'Mountain', 'None'),
(1003, 20003, 'Suite', FALSE, 650.00, 'Mountain', 'None'),
(1004, 20003, 'Family', TRUE, 450.00, 'Mountain', 'None'),
(1005, 20003, 'Double', FALSE, 300.00, 'Mountain', 'None');

-- Exclusive Resort Lakefront
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(1101, 20003, 'Single', TRUE, 230.00, 'Sea', 'None'),
(1102, 20003, 'Double', TRUE, 290.00, 'Mountain', 'None'),
(1103, 20003, 'Suite', FALSE, 700.00, 'Sea', 'None'),
(1104, 20003, 'Family', TRUE, 480.00, 'Mountain', 'None'),
(1105, 20003, 'Double', FALSE, 320.00, 'Sea', 'None');

-- Global Hotel City Center
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(1201, 20004, 'Single', FALSE, 100.00, 'Mountain', 'None'),
(1202, 20004, 'Double', TRUE, 140.00, 'Mountain', 'None'),
(1203, 20004, 'Suite', FALSE, 220.00, 'Mountain', 'None'),
(1204, 20004, 'Family', TRUE, 180.00, 'Mountain', 'None'),
(1205, 20004, 'Double', TRUE, 150.00, 'Mountain', 'None');

-- Global Hotel Riverside
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(1301, 20004, 'Single', FALSE, 110.00, 'Sea', 'None'),
(1302, 20004, 'Double', TRUE, 150.00, 'Sea', 'None'),
(1303, 20004, 'Suite', FALSE, 240.00, 'Sea', 'None'),
(1304, 20004, 'Family', TRUE, 200.00, 'Sea', 'None'),
(1305, 20004, 'Double', TRUE, 160.00, 'Sea', 'None');

-- Global Hotel Skyline
INSERT INTO Room (Room_Number, Hotel_ID, Room_Capacity, Extendable, Price, View_Type, Damage_Status)
VALUES
(1401, 20004, 'Single', FALSE, 120.00, 'Mountain', 'None'),
(1402, 20004, 'Double', TRUE, 170.00, 'Sea', 'None'),
(1403, 20004, 'Suite', FALSE, 300.00, 'Mountain', 'None'),
(1404, 20004, 'Family', TRUE, 250.00, 'Sea', 'None'),
(1405, 20004, 'Double', TRUE, 180.00, 'Mountain', 'None');


INSERT INTO RoomAmenities (Room_ID, Amenity)
SELECT 
    r.Room_ID, a.Amenity
FROM 
    Room r
CROSS JOIN 
    (SELECT 'Free WiFi' AS Amenity 
     UNION ALL SELECT 'Air Conditioning' 
     UNION ALL SELECT 'TV' 
     UNION ALL SELECT 'Mini Fridge' 
     UNION ALL SELECT 'Coffee Maker') a;

-- Checking the inserted rooms
SELECT * FROM Room;
-- Insert customers
INSERT INTO Customer (First_Name, Last_Name, Address, IDType, ID_Number, Date_Of_Registration)
VALUES 
    ('John', 'Doe', '123 Elm St, City, Country', 'SSN', '123-45-6789', '2023-01-15'),
    ('Jane', 'Smith', '456 Oak St, City, Country', 'SIN', 'S123456789', '2023-02-20'),
    ('Alice', 'Brown', '789 Pine St, City, Country', 'Driving_License', 'D987654321', '2023-03-10'),
    ('Bob', 'Johnson', '101 Maple St, City, Country', 'SSN', '987-65-4321', '2023-04-25'),
    ('Charlie', 'Davis', '202 Birch St, City, Country', 'SIN', 'S987654321', '2023-05-05');
-- Insert employees
INSERT INTO Employee (First_Name, Last_Name, Address, Employee_Role, Hotel_ID)
VALUES 
    ('Michael', 'Williams', '303 Cedar St, City, Country', 'Manager', 20000),
    ('Emma', 'Miller', '404 Fir St, City, Country', 'Receptionist', 20001),
    ('Sophia', 'Wilson', '505 Pine St, City, Country', 'Housekeeping', 20002),
    ('Liam', 'Moore', '606 Maple St, City, Country', 'Security', 20003),
    ('Olivia', 'Taylor', '707 Oak St, City, Country', 'Manager', 20004);
-- Insert bookings
INSERT INTO Booking (Customer_ID, Hotel_ID, Room_ID, Start_Date, End_Date, Employee_ID, Booking_Status)
VALUES 
    (300000, 20001,1, '2023-06-01 14:00:00', '2023-06-05 11:00:00', 40000, 'Pending'),
    (300001, 20002,2, '2023-07-10 16:00:00', '2023-07-12 11:00:00', 40001, 'Checked-In'),
    (300002, 20003,3, '2023-08-05 14:00:00', '2023-08-08 11:00:00', 40002, 'Pending'),
    (300003, 20004,4, '2023-09-15 15:00:00', '2023-09-20 11:00:00', 40003, 'Checked-In'),
    (300004, 20005,5, '2023-10-10 12:00:00', '2023-10-15 10:00:00', 40004, 'Cancelled');
-- Insert renting records
INSERT INTO Renting (Hotel_ID, Employee_ID, Customer_ID, Booking_ID, Room_ID, Start_Date, End_Date)
VALUES 
    (20000, 40000, 300000,60000,  6, '2023-06-01 14:00:00', '2023-06-05 11:00:00'),
    (20001, 40001, 300001,60001, 7, '2023-07-10 16:00:00', '2023-07-12 11:00:00'),
    (20002, 40002, 300002, 60002 ,8, '2023-08-05 14:00:00', '2023-08-08 11:00:00'),
    (20003, 40003, 300003, 60003, 9, '2023-09-15 15:00:00', '2023-09-20 11:00:00'),
    (20004, 40004, 300004, 60004, 10, '2023-10-10 12:00:00', '2023-10-15 10:00:00');
