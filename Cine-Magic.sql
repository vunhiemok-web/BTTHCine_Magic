
USE Cine_Magic;

DROP TABLE bookings;
DROP TABLE showtimes;
DROP TABLE rooms;
DROP TABLE movies;

CREATE TABLE movies (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
     duration_minutes INT,
     ge_restriction INT CHECK (ge_restriction IN (0, 13, 16, 18)) DEFAULT 0
);

CREATE TABLE rooms (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    max_seats INT ,
     status VARCHAR(15) CHECK (status IN ('active', 'maintenance')) DEFAULT 'active'
);

CREATE TABLE showtimes (
	id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT NOT NULL,
    room_id INT ,
    show_time DATETIME,
    ticket_price INT CHECK (ticket_price > 0),
     FOREIGN KEY (movie_id) REFERENCES movies(id),
     FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE bookings (
	id INT PRIMARY KEY AUTO_INCREMENT,
    showtime_id INT,
    phone VARCHAR(15),
    customer_name VARCHAR(50),
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (showtime_id) REFERENCES showtimes(id)
); 

INSERT INTO movies (title, duration_minutes, ge_restriction) VALUES
('Mai', 160, 16),
('Đào, Phở và Piano', 100, 13),
('Lật Mặt 7: Một Điều Ước', 140, 13),
('Quỷ Cẩu', 110, 18);

INSERT INTO rooms (name, max_seats, status) VALUES
('Phòng 1', 100, 'active'),
('Phòng 2', 80, 'active'),
('Phòng 3', 60, 'maintenance');

INSERT INTO showtimes (movie_id, room_id, show_time, ticket_price) VALUES
(1, 1, '2026-05-03 18:00', 120000),
(2, 1, '2026-05-03 20:30', 85000),
(3, 2, '2026-05-04 17:00', 95000),
(4, 2, '2026-05-04 21:00', 100000),
(1, 2, '2026-05-05 19:00', 90000);

INSERT INTO bookings (showtime_id, phone, customer_name) VALUES
(1, '0987654321', 'Vu Hoang Nhiem'),
(2, '0987654322', 'Nguyen Phuong Vy'),
(3, '0987654323', 'Le Quang Phuc'),
(4, '0987654324', 'Le Phuoc Loc'),
(5, '0987654325', 'Nguyen Duc Huy'),
(1, '0987654326', 'Hoang Duong Nam'),
(2, '0987654327', 'Nguyen Khanh Hung'),
(3, '0987654328', 'Tu Nhan Duc'),
(4, '0987654329', 'Nguyen Dang Khoa'),
(5, '0987654330', 'Nguyen Tuan Khang');

SET SQL_SAFE_UPDATES = 0;

UPDATE rooms
SET status ='maintenance'
WHERE name = 'Phòng 1';

UPDATE showtimes
SET room_id = 2
WHERE  room_id = 1;

DELETE FROM bookings
WHERE phone = '0987654321';

DELETE FROM bookings WHERE showtime_id IN (
    SELECT id FROM showtimes WHERE movie_id = 3
);

SET SQL_SAFE_UPDATES = 1;

SELECT title FROM movies
WHERE duration_minutes BETWEEN 90 AND 120;

SELECT * FROM bookings b
INNER JOIN showtimes st ON b.showtime_id = st.id
WHERE st.id = 2
ORDER BY b.booking_date DESC;

SELECT * FROM movies
WHERE ge_restriction >= 18 OR duration_minutes > 150;
SELECT *
FROM showtimes
WHERE ticket_price > 100000
  AND MONTH(show_time) = MONTH(CURRENT_DATE())
  AND YEAR(show_time) = YEAR(CURRENT_DATE());
