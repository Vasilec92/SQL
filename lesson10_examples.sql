-- Базы данных. Урок 10. Транзакции, переменные, представления


-- ДЗ к уроку 8

-- 1.Переписать запросы, заданые к ДЗ урока 6 с использованием JOIN
--  (три запроса). 

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT profiles.gender, 
  COUNT(likes.id) AS total_likes
  FROM likes
    JOIN profiles
      ON likes.user_id = profiles.user_id
    GROUP BY profiles.gender
    ORDER BY total_likes DESC
    LIMIT 1;
    
-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT SUM(got_likes) AS total_likes_for_youngest
  FROM (   
    SELECT COUNT(DISTINCT likes.id) AS got_likes 
      FROM profiles
        LEFT JOIN likes
          ON likes.target_id = profiles.user_id
            AND target_type_id = 2
      GROUP BY profiles.user_id
      ORDER BY profiles.birthday DESC
      LIMIT 10
) AS youngest;   

-- Вариант с левой таблицей профилей

SELECT SUM(got_likes) AS total_likes_for_youngest
  FROM (   
    SELECT COUNT(target_types.id) AS got_likes 
      FROM profiles
        LEFT JOIN likes
          ON likes.target_id = profiles.user_id
        LEFT JOIN target_types
          ON likes.target_type_id = target_types.id
            AND target_types.name = 'users'
      GROUP BY profiles.user_id
      ORDER BY profiles.birthday DESC
      LIMIT 10
) AS youngest;

-- Вариант с правой таблицей профилей

SELECT SUM(got_likes) AS total_likes_for_youngest
  FROM (   
    SELECT COUNT(target_types.id) AS got_likes 
      FROM likes
        INNER JOIN target_types
          ON likes.target_type_id = target_types.id
            AND target_types.name = 'users'
        RIGHT JOIN profiles
          ON likes.target_id = profiles.user_id
      GROUP BY profiles.user_id
      ORDER BY profiles.birthday DESC
      LIMIT 10
) AS youngest;
    

-- Найти 10 пользователей, которые проявляют наименьшую активность в
-- использовании социальной сети.

SELECT users.id,
  COUNT(DISTINCT messages.id) + 
  COUNT(DISTINCT likes.id) + 
  COUNT(DISTINCT media.id) AS activity 
  FROM users
    LEFT JOIN messages 
      ON users.id = messages.from_user_id
    LEFT JOIN likes
      ON users.id = likes.user_id
    LEFT JOIN media
      ON users.id = media.user_id
  GROUP BY users.id
  ORDER BY activity
  LIMIT 10;



-- ДЗ к уроку 9

-- 1.В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users.
-- Используйте транзакции.

SELECT * FROM shop.users;
SELECT * FROM sample.users;

START TRANSACTION;
  INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
  DELETE FROM shop.users WHERE id = 1;
COMMIT;

-- 2.Создайте представление, которое выводит название name товарной
-- позиции из таблицы products и соответствующее название каталога name
-- из таблицы catalogs.

CREATE OR REPLACE VIEW products_catalogs AS
SELECT
  p.name AS product,
  c.name AS catalog
FROM
  products AS p
JOIN
  catalogs AS c
ON
  p.catalog_id = c.id;

-- 3.Пусть имеется таблица с календарным полем created_at.
-- В ней размещены разреженые календарные записи за август 2018 года '2018-08-01', '2018-08-04', 
-- '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, 
-- выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATE NOT NULL
);

INSERT INTO posts VALUES
(NULL, 'первая запись', '2018-08-01'),
(NULL, 'вторая запись', '2018-08-04'),
(NULL, 'третья запись', '2018-08-16'),
(NULL, 'четвертая запись', '2018-08-17');

CREATE TEMPORARY TABLE last_days (
  day INT
);

INSERT INTO last_days VALUES
(0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
(11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
(21), (22), (23), (24), (25), (26), (27), (28), (29), (30);

SELECT
  DATE(DATE('2018-08-31') - INTERVAL l.day DAY) AS day,
  NOT ISNULL(p.name) AS order_exist
FROM
  last_days AS l
LEFT JOIN
  posts AS p
ON
  DATE(DATE('2018-08-31') - INTERVAL l.day DAY) = p.created_at
ORDER BY
  day;

-- 4.Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя
-- только 5 самых свежих записей.

DROP TABLE IF EXISTS posts;
CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATE NOT NULL
);

INSERT INTO posts VALUES
(NULL, 'первая запись', '2018-11-01'),
(NULL, 'вторая запись', '2018-11-02'),
(NULL, 'третья запись', '2018-11-03'),
(NULL, 'четвертая запись', '2018-11-04'),
(NULL, 'пятая запись', '2018-11-05'),
(NULL, 'шестая запись', '2018-11-06'),
(NULL, 'седьмая запись', '2018-11-07'),
(NULL, 'восьмая запись', '2018-11-08'),
(NULL, 'девятая запись', '2018-11-09'),
(NULL, 'десятая запись', '2018-11-10');

DELETE
  posts
FROM
  posts
JOIN
 (SELECT
    created_at
  FROM
    posts
  ORDER BY
    created_at DESC
  LIMIT 5, 1) AS delpst
ON
  posts.created_at <= delpst.created_at;

SELECT * FROM posts;


-- Практическое задание по теме “Администрирование MySQL”
-- (эта тема изучается по вашему желанию)

--1.Создайте двух пользователей которые имеют доступ к базе данных shop.
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
-- второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER 'shop_read'@'localhost';
GRANT SELECT, SHOW VIEW ON shop.* TO 'shop_read'@'localhost' IDENTIFIED BY '';

SHOW DATABASES;
USE shop;
SHOW TABLES;
SELECT * FROM catalogs;
INSERT INTO catalogs (name) VALUES ('Оперативная память');

CREATE USER 'shop'@'localhost';
GRANT ALL ON shop.* TO 'shop'@'localhost' IDENTIFIED BY '';


-- 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password,
-- содержащие первичный ключ, имя пользователя и его пароль. Создайте представление
-- username таблицы accounts, предоставляющее доступ к столбцам id и name. Создайте
-- пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы
-- извлекать записи из представления username.

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  password VARCHAR(255)
);

INSERT INTO accounts (name, password) VALUES
  ('Геннадий', 'Qt3X08VetW'),
  ('Наталья', 'hvg0b057Br'),
  ('Александр', 'a4YGUJjRLk'),
  ('Сергей', 'YYug1IeyWl'),
  ('Иван', 'oKoo7KXvTE'),
  ('Мария', 'w5r4yvfo9f');

CREATE VIEW username AS SELECT id, name FROM accounts;

SELECT * FROM username;

CREATE USER 'user_read'@'localhost';
GRANT SELECT (id, name) ON shop.username TO 'user_read'@'localhost';


-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"

-- 1.Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна
-- возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать
-- фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 —
-- "Доброй ночи".

USE vk;

DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello ()
RETURNS TINYTEXT NO SQL
BEGIN
  DECLARE hour INT;
  SET hour = HOUR(NOW());
  CASE
    WHEN hour BETWEEN 0 AND 5 THEN
      RETURN "Доброй ночи";
    WHEN hour BETWEEN 6 AND 11 THEN
      RETURN "Доброе утро";
    WHEN hour BETWEEN 12 AND 17 THEN
      RETURN "Добрый день";
    WHEN hour BETWEEN 18 AND 23 THEN
      RETURN "Добрый вечер";
  END CASE;
END//

DELIMITER ;
SELECT NOW(), hello ();


-- 2.В таблице products есть два текстовых поля: name с названием товара и
-- description с его описанием. Допустимо присутствие обоих полей или одного из них.
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER //

CREATE TRIGGER validate_name_description_insert BEFORE INSERT ON products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Both name and description are NULL';
  END IF;
END//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 9360.00, 2)//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('ASUS PRIME Z370-P', 'HDMI, SATA3, PCI Express 3.0,, USB 3.1', 9360.00, 2)//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, 'HDMI, SATA3, PCI Express 3.0,, USB 3.1', 9360.00, 2)//

CREATE TRIGGER validate_name_description_update BEFORE UPDATE ON products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Both name and description are NULL';
  END IF;
END//

-- 3.Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
--# Вызов функции FIBONACCI(10) должен возвращать число 55.

DELIMITER //

CREATE FUNCTION FIBONACCI(num INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE fs DOUBLE;
  SET fs = SQRT(5);

  RETURN (POW((1 + fs) / 2.0, num) + POW((1 - fs) / 2.0, num)) / fs;
END//

SELECT FIBONACCI(10)//


-- Триггеры, хранимые процедуры и функции на БД vk

-- Создание триггера для обработки target_id

-- Сначала создадим функцию для проверки существования строки
-- с идентификатором target_id в соответствующей таблице
 
DROP FUNCTION IF EXISTS is_row_exists;
DELIMITER //

CREATE FUNCTION is_row_exists (target_id INT, target_type_id INT)
RETURNS BOOLEAN READS SQL DATA

BEGIN
  DECLARE table_name VARCHAR(50);
  SELECT name FROM target_types WHERE id = target_type_id INTO table_name;
  
  CASE table_name
    WHEN 'messages' THEN
      RETURN EXISTS(SELECT 1 FROM messages WHERE id = target_id);
    WHEN 'users' THEN 
      RETURN EXISTS(SELECT 1 FROM users WHERE id = target_id);
    WHEN 'media' THEN
      RETURN EXISTS(SELECT 1 FROM media WHERE id = target_id);
    WHEN 'posts' THEN
      RETURN EXISTS(SELECT 1 FROM posts WHERE id = target_id);
    ELSE 
      RETURN FALSE;
  END CASE;
  
END//

DELIMITER ;

SELECT is_row_exists(1, 1);


-- Создадим триггер для проверки валидности target_id и target_type_id
 
DROP TRIGGER IF EXISTS like_validation;
DELIMITER //

CREATE TRIGGER likes_validation BEFORE INSERT ON likes

FOR EACH ROW BEGIN
  IF !is_row_exists(NEW.target_id, NEW.target_type_id) THEN
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "Error adding like! Target table doesn't contain row id provided!";
  END IF;
END//

DELIMITER ;

INSERT INTO likes (user_id, target_id, target_type_id) VALUES (34, 56, 2);


-- Просмотр функций и процедур
SHOW FUNCTION STATUS LIKE 'is_row_exists';
SHOW CREATE FUNCTION is_row_exists;

SHOW PROCEDURE STATUS LIKE 'posts_analysis';
SHOW CREATE PROCEDURE posts_analysis;

-- Индексы
-- Рассмотрим запрос
SELECT id, first_name, last_name 
  FROM users 
    WHERE email = 'alexis29@example.org';

-- В самом простом случае, индекс необходимо создавать для тех колонок, которые присутствуют в условии WHERE.
-- Рассмотрим запрос из примера:
SELECT id, first_name, last_name 
  FROM users 
    WHERE email = 'alexis29@example.org';
    
CREATE INDEX users_email_idx ON users(email);

-- Внутренности хранения индексов
-- Представим, что наша таблица выглядит так:
SELECT id, first_name, last_name, email FROM users;

-- После создания индекса на колонку email, MySQL сохранит все ее значения в 
-- отсортированном виде:
users_email_idx
+-----------------------------+
| acarroll@example.net        |
| alvera.terry@example.org    |
| alyce76@example.com         |
| arianna46@example.net       |
| arielle.murazik@example.org |
| aurelio.abbott@example.org  |
| beatty.tommie@example.com   |
| bergnaum.asia@example.org   |
| bergnaum.donato@example.org |
| blaise68@example.org        |
+-----------------------------+

-- После этой операции MySQL начнет использовать индекс users_email_idx для выполнения подобных запросов.

-- Сортировка
SELECT * FROM profiles ORDER BY birthday;

-- действует такое же правило — создаем индекс на колонку, по которой происходит сортировка:
CREATE INDEX profiles_birthday_idx ON profiles(birthday);

-- MySQL поддерживает также уникальные индексы. Это удобно для колонок, 
-- значения в которых должны быть уникальными по всей таблице. 

-- Такие индексы улучшают эффективность выборки для уникальных значений. 
SELECT * FROM users WHERE email = 'alexis29@example.org';

-- На колонку email необходимо создать уникальный индекс:
DROP INDEX users_email_idx ON users;
CREATE UNIQUE INDEX users_email_uq ON users(email);

-- Составные индексы
-- Рассмотрим такой запрос:
SELECT * FROM messages WHERE from_user_id = 9 AND to_user_id = 3;

-- Нам следует создать составной индекс на обе колонки:
CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id);

-- Устройство составного индекса
-- messages_from_user_id_to_user_id_idx
-- 1 3
-- 2 4
-- 3 8
-- ...

-- Сортировка
-- Составные индексы также можно использовать, если выполняется сортировка:
SELECT * FROM profiles WHERE country = 'Russia' ORDER BY birthday;

-- В этом случае нам нужно будет создать индекс в порядке
-- WHERE ORDER BY


-- Оконные функции

-- Задача
-- Найти сколько занимают места медиафайлы в разрезе типов в процентном соотношении

-- Решаем традиционным способом, применяя агрегатные функции
SELECT media_types.name, 
  SUM(media.size) AS total_by_type,
  (SELECT SUM(size) FROM media) AS total_size,
  SUM(media.size)/(SELECT SUM(size) FROM media) * 100 AS "%%" 
    FROM media
      JOIN media_types
        ON media.media_type_id = media_types.id
    GROUP BY media.media_type_id;

-- Реализация используя агрегатные функции как оконные
SELECT DISTINCT media_types.name, 
  SUM(media.size) OVER(PARTITION BY media.media_type_id) AS total_by_type,
  SUM(media.size) OVER() AS total,
  SUM(media.size) OVER(PARTITION BY media.media_type_id) / SUM(media.size) OVER() * 100 AS "%%"
    FROM media
      JOIN media_types
        ON media.media_type_id = media_types.id;

-- Расширяем вывод
SELECT DISTINCT media_types.name,
  AVG(media.size) OVER(PARTITION BY media.media_type_id) AS average,
  MIN(media.size) OVER(PARTITION BY media.media_type_id) AS min,
  MAX(media.size) OVER(PARTITION BY media.media_type_id) AS max,
  SUM(media.size) OVER(PARTITION BY media.media_type_id) AS total_by_type,
  SUM(media.size) OVER() AS total,
  SUM(media.size) OVER(PARTITION BY media.media_type_id) / SUM(media.size) OVER() * 100 AS "%%"
    FROM media
      JOIN media_types
        ON media.media_type_id = media_types.id;

-- Выносим окно отдельно
SELECT DISTINCT media_types.name,
  AVG(media.size) OVER w AS average,
  MIN(media.size) OVER w AS min,
  MAX(media.size) OVER w AS max,
  SUM(media.size) OVER w AS total_by_type,
  SUM(media.size) OVER() AS total,
  SUM(media.size) OVER w / SUM(media.size) OVER() * 100 AS "%%"
    FROM (media
      JOIN media_types
        ON media.media_type_id = media_types.id)
        WINDOW w AS (PARTITION BY media.media_type_id);

-- Оконные функции не сворачивают вывод
-- Убираем DISTINCT
SELECT media_types.name,
  AVG(media.size) OVER w AS average,
  MIN(media.size) OVER w AS min,
  MAX(media.size) OVER w AS max,
  SUM(media.size) OVER w AS total_by_type,
  SUM(media.size) OVER() AS total,
  SUM(media.size) OVER w / SUM(media.size) OVER() * 100 AS "%%"
    FROM (media
      JOIN media_types
        ON media.media_type_id = media_types.id)
        WINDOW w AS (PARTITION BY media.media_type_id);

-- Применяем чистые оконные функции
SELECT user_id, birthday,
  ROW_NUMBER() OVER w AS 'row_number',
  FIRST_VALUE(birthday) OVER w AS 'first',
  LAST_VALUE(birthday) OVER(PARTITION BY LEFT(birthday, 3)
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'last',
  NTH_VALUE(birthday, 2) OVER w AS 'second'
    FROM profiles
      WINDOW w AS (PARTITION BY LEFT(birthday, 3) ORDER BY birthday);


-- Задания на БД vk:

-- 1. Проанализировать какие запросы могут выполняться наиболее
-- часто в процессе работы приложения и добавить необходимые индексы.

-- 2. Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100


