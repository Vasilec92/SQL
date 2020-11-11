-- 1 Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT 
	users.name 
FROM 
	users
JOIN 
	orders 
ON 
	users.id = orders.user_id
GROUP BY 
	users.name;



-- 2 Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT 
	products.name, catalogs.name AS catalogs
FROM 
	products
JOIN 
	catalogs
ON 
	products.catalog_id=catalogs.id;


-- 4 Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

CREATE TABLE flights 
(
	id INT PRIMARY KEY NOT NULL, 
	fromCity VARCHAR(25),  
	toCity	VARCHAR(25)
);

INSERT INTO flights (id,fromCity,toCity)
VALUES 
(1,'moscow', 'omsk'),
(2,'novgorod', 'kazan'),
(3,'irkutsk', 'moscow'),
(4,'omsk', 'irkutsk');

CREATE TABLE cities 
(
	label VARCHAR(25),  
	name VARCHAR(25)
);

INSERT INTO cities (label,name)
VALUES 
('moscow', 'Москва'),
('omsk', 'Омск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('irkutsk', 'Иркутск');

SELECT 
	flights.id,
	(SELECT name FROM cities WHERE cities.label = flights.fromCity) AS `from`,
	(SELECT name FROM cities WHERE cities.label = flights.toCity) AS `to`	
FROM 
	flights;




