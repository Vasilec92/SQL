-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.


USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(50) NOT NULL,
	id_pk_name INT NOT NULL,
	name VARCHAR(50) NOT NULL
) ENGINE = ARCHIVE;

-- TRIGER ON table USER 
DROP TRIGGER IF EXISTS log_users;
DELIMITER //
CREATE TRIGGER log_users
	AFTER INSERT ON users
		FOR EACH ROW
		BEGIN 
			INSERT INTO logs (created_at, table_name, id_pk_name, name)
			VALUES (NOW(), 'users', NEW.id, NEW.name);
		END //
DELIMITER ;

-- TRIGER ON table catalogs 
DROP TRIGGER IF EXISTS log_catalogs;
DELIMITER //
CREATE TRIGGER log_catalogs
	AFTER INSERT ON catalogs
		FOR EACH ROW
		BEGIN 
			INSERT INTO logs (created_at, table_name, id_pk_name, name)
			VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
		END //
DELIMITER ;

-- TRIGER ON table products 
DROP TRIGGER IF EXISTS log_products;
DELIMITER //
CREATE TRIGGER log_products
	AFTER INSERT ON products
		FOR EACH ROW
		BEGIN 
			INSERT INTO logs (created_at, table_name, id_pk_name, name)
			VALUES (NOW(), 'products', NEW.id, NEW.name);
		END //
DELIMITER ;


INSERT INTO users(name, birthday_at, created_at , updated_at)
VALUES ('Jonson', '2000-02-02', NOW(), NOW());

INSERT INTO catalogs (name)
VALUES ('books');

INSERT INTO products (name, description , price, catalog_id , created_at, updated_at)
VALUES ('test','test', 60, 1, NOW(), NOW());

SELECT * FROM logs;

-- Создайте SQL-запрос, который помещает в таблицу users миллион записей.
-- создала для 1000 записей,  миллион будет долго выполнятся

USE shop;

DROP PROCEDURE IF EXISTS dowhile;

DELIMITER //
CREATE PROCEDURE dowhile()
BEGIN
  DECLARE userN INT DEFAULT 1;
  WHILE userN <= 1000 DO
    INSERT INTO users(name, birthday_at, created_at , updated_at)
	VALUES (CONCAT('user_',userN) , NOW() , NOW(), NOW());
    SET userN = userN + 1;
  END WHILE;
END //
DELIMITER ;

CALL dowhile();
SELECT * FROM users;