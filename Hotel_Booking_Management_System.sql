USE hotel_booking;
CREATE TABLE Hotels (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_name VARCHAR(50),
    city VARCHAR(30),
    star_rating int
    );
INSERT INTO Hotels(hotel_name, city, star_rating)
VALUES
('Grand Palace', 'Chennai',5),
('Sea view', 'Goa',4),
('Royal Stay', 'Hyderabad',5);
SELECT * FROM Hotels;
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT,
    room_number VARCHAR(10),
    room_type VARCHAR(30),
    price DECIMAL(10,2),
    FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id)
);
INSERT INTO Rooms(hotel_id, room_number, room_type, price)
VALUES
(1, '101', 'Deluxe', 2500),
(1, '102', 'Suite', 4000),
(2, '201', 'Standard', 1800),
(3, '301', 'Deluxe', 3000);
SELECT * FROM Rooms;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(100)
);
INSERT INTO Customers(customer_name, phone, email)
VALUES
('Navya', '9876543210', 'navya@gmail.com'),
('Rahul', '9876543211', 'rahul@gmail.com'),
('Priya', '9876543212', 'priya@gmail.com');
SELECT * FROM Customers;
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    booking_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);
INSERT INTO Bookings(customer_id, room_id, check_in, check_out, booking_status)
VALUES
(1, 1, '2026-09-25', '2026-09-27', 'Confirmed'),
(2, 3, '2026-09-26', '2026-09-29', 'Confirmed'),
(3, 2, '2026-09-28', '2026-10-01', 'Pending');
SELECT * FROM Bookings;
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_status VARCHAR(20),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
INSERT INTO Payments(booking_id, amount, payment_date, payment_status)
VALUES
(1, 2500.00, '2026-09-25', 'Paid'),
(2, 1800.00, '2026-09-26', 'Paid'),
(3, 4000.00, '2026-09-28', 'Pending');
SELECT * FROM Payments;
SELECT 
    b.booking_id,
    c.customer_name,
    r.room_number,
    r.room_type,
    b.check_in,
    b.check_out,
    b.booking_status
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Rooms r ON b.room_id = r.room_id;

-- 1. Display Available Rooms
SELECT
    r.room_number,
    r.room_type,
    r.price,
    h.hotel_name
FROM Rooms r
JOIN Hotels h
ON r.hotel_id = h.hotel_id
WHERE r.room_id NOT IN (
    SELECT room_id
    FROM Bookings
    WHERE booking_status IN ('Active', 'Booked')
);

-- 2. Find Guests Staying Today
SELECT
    c.customer_name,
    h.hotel_name,
    r.room_number,
    b.check_in,
    b.check_out
FROM Customers c
JOIN Bookings b
ON c.customer_id = b.customer_id
JOIN Rooms r
ON b.room_id = r.room_id
JOIN Hotels h
ON r.hotel_id = h.hotel_id
WHERE CURDATE() BETWEEN b.check_in AND b.check_out
AND b.booking_status = 'Active';

-- 3. Calculate Total Revenue
SELECT
    SUM(amount) AS Total_Revenue
FROM Payments
WHERE payment_status = 'Paid';

-- 4. Display Bookings Between Two Dates
SELECT
    b.booking_id,
    c.customer_name,
    h.hotel_name,
    b.check_in,
    b.check_out
FROM Bookings b
JOIN Customers c
ON b.customer_id = c.customer_id
JOIN Rooms r
ON b.room_id = r.room_id
JOIN Hotels h
ON r.hotel_id = h.hotel_id
WHERE b.check_in BETWEEN '2026-09-25' AND '2026-09-30';

-- 5. Find the Most Booked Room Type
SELECT
    r.room_type,
    COUNT(*) AS Total_Bookings
FROM Rooms r
JOIN Bookings b
ON r.room_id = b.room_id
GROUP BY r.room_type
ORDER BY Total_Bookings DESC
LIMIT 1;

-- 6. Calculate Occupancy Rate
SELECT
    ROUND(
        COUNT(DISTINCT b.room_id) * 100.0 /
        COUNT(DISTINCT r.room_id),
        2
    ) AS Occupancy_Rate
FROM Rooms r
LEFT JOIN Bookings b
ON r.room_id = b.room_id
AND b.booking_status = 'Active';

-- 7. Display Cancelled Bookings
SELECT
    b.booking_id,
    c.customer_name,
    h.hotel_name,
    r.room_number
FROM Bookings b
JOIN Customers c
ON b.customer_id = c.customer_id
JOIN Rooms r
ON b.room_id = r.room_id
JOIN Hotels h
ON r.hotel_id = h.hotel_id
WHERE b.booking_status = 'Cancelled';


-- 8. Find Customers with Multiple Bookings
SELECT
    c.customer_name,
    COUNT(b.booking_id) AS Total_Bookings
FROM Customers c
JOIN Bookings b
ON c.customer_id = b.customer_id
GROUP BY c.customer_name
HAVING COUNT(b.booking_id) > 1;


-- 9. Display Average Room Price
SELECT
    AVG(price) AS Average_Room_Price
FROM Rooms;

-- 10. Find Hotels with More Than 100 Rooms
SELECT
    h.hotel_name,
    COUNT(r.room_id) AS Total_Rooms
FROM Hotels h
JOIN Rooms r
ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_name
HAVING COUNT(r.room_id) > 100;


-- 11. Find the Highest-Paying Customer
SELECT
    c.customer_name,
    SUM(p.amount) AS Total_Spent
FROM Customers c
JOIN Bookings b
ON c.customer_id = b.customer_id
JOIN Payments p
ON b.booking_id = p.booking_id
GROUP BY c.customer_name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 12. Hotel-wise Revenue
SELECT
    h.hotel_name,
    SUM(p.amount) AS Revenue
FROM Hotels h
JOIN Rooms r
ON h.hotel_id = r.hotel_id
JOIN Bookings b
ON r.room_id = b.room_id
JOIN Payments p
ON b.booking_id = p.booking_id
WHERE p.payment_status = 'Paid'
GROUP BY h.hotel_name;


-- 13. Most Expensive Room
SELECT
    room_number,
    room_type,
    price
FROM Rooms
ORDER BY price DESC
LIMIT 1;


-- 14. Customers Who Never Made a Booking
SELECT
    c.customer_name
FROM Customers c
LEFT JOIN Bookings b
ON c.customer_id = b.customer_id
WHERE b.booking_id IS NULL;
-- 15. Rank Hotels by Revenue
SELECT
    h.hotel_name,
    SUM(p.amount) AS Revenue,
    RANK() OVER (
        ORDER BY SUM(p.amount) DESC
    ) AS Revenue_Rank
FROM Hotels h
JOIN Rooms r
ON h.hotel_id = r.hotel_id
JOIN Bookings b
ON r.room_id = b.room_id
JOIN Payments p
ON b.booking_id = p.booking_id
WHERE p.payment_status = 'Paid'
GROUP BY h.hotel_name;