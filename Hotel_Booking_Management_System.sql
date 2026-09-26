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
