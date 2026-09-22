CREATE DATABASE IF NOT EXISTS auto_repair_shop;
USE auto_repair_shop;

DROP TABLE IF EXISTS order_parts;
DROP TABLE IF EXISTS order_services;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS parts;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS masters;
DROP TABLE IF EXISTS cars;
DROP TABLE IF EXISTS clients;

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    vin VARCHAR(17) NOT NULL UNIQUE,
    CONSTRAINT fk_cars_clients FOREIGN KEY (client_id) 
        REFERENCES clients(client_id) ON DELETE CASCADE
);

CREATE TABLE masters (
    master_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE parts (
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    master_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'В работе',
    CONSTRAINT fk_orders_cars FOREIGN KEY (car_id) 
        REFERENCES cars(car_id) ON DELETE CASCADE,
    CONSTRAINT fk_orders_masters FOREIGN KEY (master_id) 
        REFERENCES masters(master_id) ON DELETE RESTRICT
);

CREATE TABLE order_services (
    order_service_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    price_at_moment DECIMAL(10, 2) NOT NULL CHECK (price_at_moment >= 0),
    CONSTRAINT fk_order_services_orders FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_services_services FOREIGN KEY (service_id) 
        REFERENCES services(service_id) ON DELETE RESTRICT
);

CREATE TABLE order_parts (
    order_part_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    price_at_moment DECIMAL(10, 2) NOT NULL CHECK (price_at_moment >= 0),
    CONSTRAINT fk_order_parts_orders FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_parts_parts FOREIGN KEY (part_id) 
        REFERENCES parts(part_id) ON DELETE RESTRICT
);


INSERT INTO clients (first_name, last_name, phone, email) VALUES
('Иван', 'Иванов', '+79991112233', 'ivan@mail.ru'),
('Петр', 'Петров', '+79992223344', 'petr@mail.ru'),
('Алексей', 'Сидоров', '+79993334455', 'sidorov@mail.ru'),
('Сергей', 'Кузнецов', '+79994445566', 'kuznetsov@yandex.ru'),
('Дмитрий', 'Смирнов', '+79995556677', 'smirnov@gmail.com');

INSERT INTO cars (client_id, brand, model, license_plate, vin) VALUES
(1, 'Toyota', 'Camry', 'А111АА77', 'JTDKN3DU000000001'),
(1, 'Lada', 'Vesta', 'В222ВВ77', 'XTAGFL11000000002'),
(2, 'BMW', 'X5', 'Е333ЕЕ77', 'WBAFR110000000003'),
(3, 'Kia', 'Rio', 'К444КК77', 'Z94CB411000000004'),
(4, 'Hyundai', 'Solaris', 'М555ММ77', 'Z94CT411000000005'),
(5, 'Volkswagen', 'Polo', 'Н666НН77', 'WVWZZZ6R000000006');

INSERT INTO masters (first_name, last_name, specialization) VALUES
('Михаил', 'Алексеев', 'Моторист'),
('Андрей', 'Васильев', 'Автоэлектрик'),
('Олег', 'Николаев', 'Ходовик'),
('Роман', 'Орлов', 'Диагност'),
('Евгений', 'Попов', 'Мастер ТО');

INSERT INTO services (name, price) VALUES
('Замена масла в двигателе', 1500.00),
('Компьютерная диагностика', 2000.00),
('Замена тормозных колодок', 2500.00),
('Замена свечей зажигания', 1000.00),
('Шиномонтаж R16', 3000.00);

INSERT INTO parts (name, price, stock_quantity) VALUES
('Масло моторное 4Л', 4500.00, 20),
('Фильтр масляный', 800.00, 35),
('Колодки тормозные передние', 3500.00, 15),
('Свеча зажигания', 600.00, 50),
('Фильтр воздушный', 900.00, 25);

INSERT INTO orders (car_id, master_id, created_at, status) VALUES
(1, 1, '2026-09-01 10:00:00', 'Завершен'),
(2, 5, '2026-09-02 11:30:00', 'Завершен'),
(3, 3, '2026-09-03 14:15:00', 'Завершен'),
(4, 2, '2026-09-04 09:00:00', 'Завершен'),
(5, 4, '2026-09-05 16:45:00', 'Завершен'),
(6, 1, '2026-09-06 12:20:00', 'Завершен'),
(1, 3, '2026-09-07 15:10:00', 'Завершен'),
(2, 2, '2026-09-08 10:00:00', 'Завершен'),
(3, 5, '2026-09-09 13:40:00', 'В работе'),
(4, 1, '2026-09-10 11:00:00', 'В работе'),
(5, 3, '2026-09-11 17:00:00', 'В работе');

INSERT INTO order_services (order_id, service_id, quantity, price_at_moment) VALUES
(1, 1, 1, 1500.00),
(1, 2, 1, 2000.00),
(2, 1, 1, 1500.00),
(3, 3, 1, 2500.00),
(4, 2, 1, 2000.00),
(5, 4, 1, 1000.00),
(6, 1, 1, 1500.00),
(7, 3, 1, 2500.00),
(8, 2, 1, 2000.00),
(9, 5, 1, 3000.00),
(10, 1, 1, 1500.00),
(11, 3, 1, 2500.00);

INSERT INTO order_parts (order_id, part_id, quantity, price_at_moment) VALUES
(1, 1, 1, 4500.00),
(1, 2, 1, 800.00),
(2, 1, 1, 4500.00),
(2, 2, 1, 800.00),
(3, 3, 1, 3500.00),
(5, 4, 4, 600.00),
(6, 1, 1, 4500.00),
(6, 5, 1, 900.00),
(7, 3, 1, 3500.00),
(10, 1, 1, 4500.00),
(10, 2, 1, 800.00);