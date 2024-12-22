-- Таблица работников
CREATE TABLE Workers (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(16) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Таблица книг
CREATE TABLE Books (
    id SERIAL PRIMARY KEY,
    author VARCHAR(200) NOT NULL, 
    title VARCHAR(200) NOT NULL,
    type VARCHAR(30) NOT NULL CHECK (type IN ('В твердой обложке', 'В мягкой обложке', 'Суперобложка'))
);

-- Таблица заказов
CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    order_date DATE NOT NULL,
    production_date DATE NOT NULL,
    order_state VARCHAR(40) NOT NULL CHECK (order_state IN ('В обработке', 'В очереди', 'В производстве', 'Ожидает отправки', 'Выполнен')),
    production_state VARCHAR(40) NOT NULL CHECK (production_state IN ('Не начато', 'Препресс', 'Печать', 'Сшивание', 'Запаковка', 'Завершено')),
    cost_per_one INT NOT NULL CHECK (cost_per_one >= 0),
    quantity INT NOT NULL CHECK (quantity > 0),
    CONSTRAINT fk_book FOREIGN KEY(book_id) REFERENCES Books(id)
);

-- Таблица корректоров
CREATE TABLE Proofreaders (
    worker_id INT PRIMARY KEY,
    order_id INT,
    CONSTRAINT fk_worker FOREIGN KEY(worker_id) REFERENCES Workers(id),
    CONSTRAINT fk_order FOREIGN KEY(order_id) REFERENCES Orders(id)
);

-- Таблица машин
CREATE TABLE Machines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL, 
    serial_number VARCHAR(20) NOT NULL, 
    state VARCHAR(40) NOT NULL CHECK (state IN ('Простаивает', 'В работе', 'Настройка', 'Неисправен'))
);

-- Таблица печатников
CREATE TABLE Printers (
    worker_id INT PRIMARY KEY,
    machine_id INT NOT NULL,
    order_id INT,
    CONSTRAINT fk_printer_worker FOREIGN KEY(worker_id) REFERENCES Workers(id),
    CONSTRAINT fk_machine FOREIGN KEY(machine_id) REFERENCES Machines(id),
    CONSTRAINT fk_printer_order FOREIGN KEY(order_id) REFERENCES Orders(id)
);

-- Таблица материалов
CREATE TABLE Materials (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0)
);

-- Таблица необходимых материалов
CREATE TABLE Required_materials (
    id SERIAL PRIMARY KEY,
    materials_id INT NOT NULL,
    machine_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    delivery_time TIMESTAMP NOT NULL,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Доставлено','В обработке')),
    CONSTRAINT fk_required_materials FOREIGN KEY(materials_id) REFERENCES Materials(id),
    CONSTRAINT fk_required_machine FOREIGN KEY(machine_id) REFERENCES Machines(id)
);






INSERT INTO Workers (full_name, date_of_birth, phone_number, email) VALUES 
    ('Васильев Борис Дмитриевич', '1973-09-15', '+7 977 555 88 88', 'vasilev.b.d.tipogr@mail.ru'),
    ('Прохорова Наталья Константиновна', '1991-01-10', '+7 912 987 65 43', 'prohorova.n.k.tipogr@mail.ru'),
    ('Иванов Дмитрий Сергеевич', '1985-10-25', '+7 999 111 28 28', 'ivanov.d.s.tipogr@mail.ru'),
    ('Книгов Антон Сергеевич', '1990-04-01', '+7 999 123 45 67', 'knigov.a.s.tipogr@mail.ru'),
    ('Голубев Иван Михайлович', '1972-03-21', '+7 905 553 10 31', 'golubev.i.m.tipogr@mail.ru'),
    ('Поздняков Александр Владимирович', '1987-01-15', '+7 924 086 47 46', 'pozdnyakov.a.v.tipogr@mail.ru'),
    ('Савин Максим Ильич', '1995-10-06', '+7 988 208 96 27', 'savin.m.i.tipogr@mail.ru'),
    ('Мухин Ярослав Владимирович', '1971-01-12', '+7 947 911 16 77', 'mukhin.ya.v.tipogr@mail.ru'),
    ('Любимова София Артёмовна', '1984-02-10', '+7 947 795 55 01', 'lyubimova.s.a.tipogr@mail.ru'),
    ('Клюева Кира Данииловна', '1978-09-28', '+7 984 968 90 72', 'klyueva.k.d.tipogr@mail.ru');

INSERT INTO Books (author, title, type) VALUES
    ('Джордж Оруэлл', '1984', 'В твердой обложке'),
    ('Рэй Брэдбери', '451 градус по Фаренгейту', 'В мягкой обложке'),
    ('Исаак Азимов', 'Я, робот', 'В твердой обложке'), 
    ('Филип Киндред Дик', 'Мечтают ли андроиды об электроовцах?', 'В твердой обложке'),
    ('Габриэль Гарсиа Маркес', '100 лет одиночества', 'Суперобложка'),
    ('Альбер Камю', 'Посторонний', 'В мягкой обложке');

INSERT INTO Orders (book_id, order_date, production_date, order_state, production_state, cost_per_one, quantity) VALUES 
    (1, '2024-05-10', '2024-06-01', 'Выполнен', 'Завершено', 140, 20000),
    (2, '2024-06-20', '2024-07-02', 'Ожидает отправки', 'Завершено', 160, 13000),
    (3, '2024-09-05', '2024-09-18', 'В производстве', 'Печать', 220, 5000),
    (4, '2024-09-03', '2024-09-20', 'В производстве', 'Препресс', 150, 10000),
    (5, '2024-08-15', '2024-09-30', 'В очереди', 'Не начато', 180, 25000),
    (6, '2024-09-12', '2024-10-11', 'В обработке', 'Не начато', 200, 40000);

INSERT INTO Proofreaders (worker_id, order_id) VALUES 
    (2, 4),
    (6, 5);

INSERT INTO Machines (name, serial_number, state) VALUES 
    ('Станок для печати листов', 'RJ000128410', 'Настройка'),
    ('Станок для печати листов', 'RJ000133309', 'В работе'),
    ('Станок для печати обложек', 'OJ004011479', 'Настройка'),
    ('Станок для создания печатной формы', 'ST173232', 'В работе'),
    ('Станок для сшивания тетрадей', 'DD002298419', 'Настройка'),
    ('Станок для сшивания обложек', 'DR003454677', 'Настройка'),
    ('Крышкоделательная машина', 'DE001040887', 'Простаивает'),
    ('Станок для сборки книг', 'BK00568901', 'Настройка'),
    ('Станок для нанесения лака', 'LA003456789', 'Простаивает');

INSERT INTO Printers (worker_id, machine_id, order_id) VALUES 
    (1, 1, 4),
    (3, 2, 3),
    (4, 3, 4),
    (5, 2, 3),
    (7, 8, 3),
    (8, 5, 3),
    (9, 6, 3),
    (10, 1, NULL);

INSERT INTO Materials (name, quantity) VALUES 
    ('Пачка листов офсетной бумаги (1000 шт)', 14000),
    ('Пачка листов газетной бумаги (1000 шт)', 8200),
    ('Металическая пластина', 2000),
    ('Черная краска для ч/б печати (1 л)', 6000),
    ('Набор красок для цветной печати (1 л)', 3000),
    ('Крышки (100)', 7600),
    ('Катушка с белой нитью', 1000),
    ('Пленка для ламинирования (100 м2)', 1500);

INSERT INTO Required_materials (materials_id, machine_id, quantity, delivery_time, status) VALUES 
    (3, 4, 2, '2024-09-14 10:00', 'Доставлено'),
    (2, 2, 35, '2024-09-15 12:00', 'Доставлено'),
    (4, 2, 1, '2024-09-15 12:00', 'Доставлено'),
    (5, 1, 2, '2024-09-15 16:00', 'В обработке'),
    (1, 2, 2, '2024-09-15 16:00', 'В обработке'),
    (1, 1, 70, '2024-09-15 18:00', 'В обработке'),
    (4, 1, 2, '2024-09-15 18:00', 'В обработке');










