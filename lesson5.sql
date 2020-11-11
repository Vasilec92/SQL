--Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
UPDATE users SET created_at=NOW(), updated_at=NOW();

--Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
UPDATE users SET created_at = STR_TO_DATE(created_at, "%d.%m.%Y %k:%i");
ALTER TABLE users MODIFY created_at DATETIME;

--В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.
SELECT value FROM storehouses_products ORDER BY IF(value=0, TRUE,FALSE), value;

--Подсчитайте средний возраст пользователей в таблице users.
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age FROM users;