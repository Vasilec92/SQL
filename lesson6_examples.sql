-- Урок 6
-- Операторы, фильтрация, сортировка и ограничение


-- Разбор ДЗ

-- Тема Операции, задание 1
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными.
-- Заполните их текущими датой и временем.
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', NULL, NULL),
  ('Наталья', '1984-11-12', NULL, NULL),
  ('Александр', '1985-05-20', NULL, NULL),
  ('Сергей', '1988-02-14', NULL, NULL),
  ('Иван', '1998-01-12', NULL, NULL),
  ('Мария', '2006-08-29', NULL, NULL);

UPDATE
  users
SET
  created_at = NOW(),
  updated_at = NOW();
  
  
-- Тема Операции, задание 2
-- Таблица users была неудачно спроектирована.
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались
-- значения в формате "20.10.2017 8:10".
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');

UPDATE
  users
SET
  created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
  updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE
  users
CHANGE
  created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE
  users
CHANGE
  updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DESCRIBE users;


-- Тема Операции, задание 3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые
-- разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения
-- значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);

SELECT
  *
FROM
  storehouses_products
ORDER BY
  IF(value > 0, 0, 1),
  value;

SELECT
  *
FROM
  storehouses_products
ORDER BY
  value = 0, value;


-- Тема Операции, задание 4
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в
-- августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT name  
  FROM users
  WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');

-- Тема Операции, задание 5
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2);
-- Отсортируйте записи в порядке, заданном в списке IN.

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

SELECT
  *
FROM
  catalogs
WHERE
  id IN (5, 1, 2)
ORDER BY
  FIELD(id, 5, 1, 2);

-- Тема Агрегация, задание 1
-- Подсчитайте средний возраст пользователей в таблице users
SELECT
  AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age
FROM
  users;
	  
-- Тема Агрегация, задание 2
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
SELECT
  DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
  COUNT(*) AS total
FROM
  users
GROUP BY
  day
ORDER BY
  total DESC;

-- Тема Агрегация, задание 3
-- (по желанию) Подсчитайте произведение чисел в столбце таблицы
INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

SELECT ROUND(EXP(SUM(LN(id)))) FROM catalogs;



-- Предложенные варианты реализации лайков и публикаций (только для анализа, не для создания!)

-- Варианты реализации таблиц для хранения лайков и постов

-- Вариант 1
-- Реализация лайков
CREATE TABLE contet_type (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
	name VARCHAR(10),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
);

INSERT  INTO content_type (name) VALUES 
	('media'),
	('message'); 

CREATE TABLE likes (
	-- id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
	user_id INT COMMENT 'Идентификатор пользователя',
	content_id INT COMMENT 'Идентификатор контента',
	content_type_id INT COMMENT 'Идентификатор типа контента',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	UNIQUE KEY (user_id, content_id, content_type_id) COMMENT 'Составной первичный ключ'
);

-- Тестовые данные
INSERT  INTO likes (user_id, content_id, content_type_id) VALUES 
	(1,1,1); 
	
	
-- Вариант 2	
-- Реализация лайков:
create table likes (
	-- Первичный ключ
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    -- ID тех данных, которые мы лайкаем
    data_id INT UNSIGNED NOT NULL,
    -- Тип данных, которые мы лайкаем (посты, фото, пользователи и т.д.) берется из отдельной таблицы
    data_type_id INT UNSIGNED NOT NULL,
    -- ID  пользователя, который поставил лайк
    user_id INT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки"
);

create table data_types (
	-- Первичный ключ
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    -- Название типа данных ("photo", "post", "user", etc)
    name VARCHAR(30) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

-- Добавляем тестовые данные
INSERT INTO data_types (name) VALUES ('user'), ('media'), ('post');

-- Чтобы подсичать количество лайков под фотграфией с ID = 23 (к примеру) можно использовать запрос:
SELECT COUNT(*) FROM likes 
	WHERE data_ID = 23 AND data_type_id = (SELECT id FROM data_types WHERE name = 'media');
    
-- РЕАЛИЗАЦИЯ ПОСТОВ
create table posts (
	-- Первичный ключ
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    -- ID автора поста
    user_id INT UNSIGNED NOT NULL,
    -- Заголовок поста
    title VARCHAR(50) NOT NULL,
    -- Текст самого поста. Считаем, что текста может быть много, поэтому используем тип данных TEXT
    -- Ну и тут советуют тоже так делать: https://stackoverflow.com/questions/5458376/what-column-data-type-should-i-use-for-storing-large-amounts-of-text-or-html
    body TEXT NOT NULL
);


-- Вариант 3
CREATE TABLE likes
(
  id_user INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Пользаватель который лайкает",
  id_media INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Контент который лайкают",
  created_at DATETIME DEFAULT NOW() COMMENT "Время лайка"
) COMMENT "Лайки";

CREATE TABLE posts
(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор поста",
  id_user INT UNSIGNED NOT NULL COMMENT "Пользователь создавший пост",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Посты";


-- Вариант 4
-- Думаю, стоит создать таблицу posts, которая будет содержать 4 столбца:
-- id(PRIMARY KEY); user_id(ссылка на пользователя, который выложил пост, NULL если не пользователь);
-- ссылка на сообщество, если пост от сообщества(NULL, если не сообщество); 
-- содержание поста;

-- Для лайков примерно также: id(PRIMARY KEY); 
-- user_id(ссылка на пользователя, который поставил лайк, NULL если не пользователь);
-- ссылка на сообщество, если лайк от сообщества(NULL, если не сообщество);


-- Вариант 5
CREATE TABLE posts (
	id INT UNSIGNED AUTO INCREMENT NOT NULL PRIMARY KEY COMMENT 'Идентификатор поста',
	user_id INT UNSIGNED COMMENT 'Ссылка на пользователя, разместившего пост',
	community_id INT UNSIGNED COMMENT 'Ссылка на группу, разместившую пост',
	body TEXT COMMENT 'Текст поста',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время размещения поста',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления поста'
) COMMENT 'Посты';

CREATE TABLE posts_media (
	post_id = INT UNSIGNED NOT NULL COMMENT 'Ссылка на пост',
	media_id = INT UNSIGNED NOT NULL COMMENT 'Ссылка на медиафайл',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки связи',
	PRIMARY KEY (post_id, media_id) COMMENT 'Составной первичный ключ'
) comment 'Таблица связей постов и медиафайлов';

CREATE TABLE likes (
	id INT UNSIGNED AUTO INCREMENT NOT NULL PRIMARY KEY COMMENT 'Идентификатор лайка',
	user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на поставившего лайк',
	media_id INT UNSIGNED COMMENT 'Ссылка на лайкнутый медиафайл',
	post_id  INT UNSIGNED COMMENT 'Ссылка на лайкнутый пост',
	created_at DATATIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время, когда лайк был поставлен'
) COMMENT 'Лайки';


-- Вариант 6
-- Таблица постов, предложила еще врошлй раз, но код урезался 
CREATE TABLE twitter(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автора поста",
  communities_id INT NOT NULL COMMENT "Ссылка на нруппу если пост пренадлежит группе",
  body TEXT NOT NULL COMMENT "Текст поста",
  media_id INT UNSIGNED COMMENT "Ссылка на медиафайл",
  id_comment INT UNSIGNED NOT NULL COMMENT "Ссылка на комментарий к посту",
  id_likes INT NOT NULL AUTO_INCREMENT COMMENT "Счечик лайка" 
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Посты";

-- Таблица для комментариев
CREATE TABLE comments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  id_twitter INT UNSIGNED NOT NULL COMMENT "Ссылка на пост",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автора коментария",
  body TEXT NOT NULL COMMENT "Текст коментария ",
  media_id INT UNSIGNED COMMENT "Ссылка на медиафайл",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

--Таблица лайков 
CREATE TABLE like(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  twitter_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пост",
  user_id INT UNSIGNED NOT NULL COMMENT "Пользователь который поставил лайк"
);


-- Вариант 7
CREATE TABLE likes (
comments_id INT UNSIGNED NOT null,
media_id INT UNSIGNED NOT null,
like_body BOOLEAN);


-- Вариант 8
-- посты
-- так как постов много, и они могут быть опубликованы как от имени пользователя, так и от имени группы, 
-- то нужно сделать 2 таблицы
CREATE TABLE posts_users (
  id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Пользователь, автор поста", 
  content text,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Посты пользователей";
 
CREATE TABLE posts_communities (
  id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Пользователь, автор поста", 
  community_id INT UNSIGNED NOT NULL COMMENT "Группа поста",
  content text COMMENT "Содержимое поста",
  from_community TINYINT UNSIGNED DEFAULT 0 COMMENT "Опубликован от имени группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Посты сообществ";

-- к постам могут быть прикреплены медиа файлы
CREATE TABLE posts_users_media (
  post_id INT UNSIGNED NOT NULL COMMENT "Идентификатор поста",
  media_id INT UNSIGNED NOT NULL COMMENT "Идентификатор медиа", 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (post_id, media_id) COMMENT "Первичный ключ"
) COMMENT "Медиа постов пользователей";

CREATE TABLE posts_communities_media (
  post_id INT UNSIGNED NOT NULL COMMENT "Идентификатор поста",
  media_id INT UNSIGNED NOT NULL COMMENT "Идентификатор медиа", 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (post_id, media_id) COMMENT "Первичный ключ"
) COMMENT "Медиа постов сообществ";

-- таблицы лайков
-- лайков может быть очень много, поэтому разделяю таблицы для разных видов лайков
CREATE TABLE posts_users_likes (
  post_id INT UNSIGNED NOT NULL COMMENT "Идентификатор поста",
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя", 
  is_active TINYINT UNSIGNED DEFAULT 1 COMMENT "Активен",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (post_id, user_id) COMMENT "Первичный ключ"
) COMMENT "Лайки постов пользователей";

CREATE TABLE posts_community_likes (
  post_id INT UNSIGNED NOT NULL COMMENT "Идентификатор поста",
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя", 
  is_active TINYINT UNSIGNED DEFAULT 1 COMMENT "Активен",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (post_id, user_id) COMMENT "Первичный ключ"
) COMMENT "Лайки постов сообществ";

CREATE TABLE media_likes (
  media_id INT UNSIGNED NOT NULL COMMENT "Идентификатор медиа",
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя", 
  is_active TINYINT UNSIGNED DEFAULT 1 COMMENT "Активен",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (media_id, user_id) COMMENT "Первичный ключ"
) COMMENT "Лайки медиа";

-- Вариант 9 (финальный)
-- Применим вариант с таблицей типов лайков
-- (применяем к базе vk только этот вариант!)

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

-- Проверим
SELECT * FROM likes LIMIT 10;

-- Создадим таблицу постов
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- Добавляем внешние ключи в БД vk
-- Для таблицы профилей

-- Смотрим структуру таблицы
DESC profiles;

-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_status_id_fk
    FOREIGN KEY (status_id) REFERENCES profile_statuses(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_city_id_fk
    FOREIGN KEY (city_id) REFERENCES cities(id)
      ON DELETE SET NULL;

-- Изменяем тип столбца при необходимости
ALTER TABLE profiles DROP FOREIGN KEY profiles_user_id_fk;
ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;
      
-- Для таблицы сообщений

-- Смотрим структурв таблицы
DESC messages;

-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

-- Смотрим диаграмму отношений в DBeaver (ERDiagram)


-- Если нужно удалить
ALTER TABLE table_name DROP FOREIGN KEY constraint_name;


-- Примеры на основе базы данных vk
USE vk;

-- Получаем данные пользователя
SELECT * FROM users WHERE id = 7;

SELECT first_name, last_name, 'city', 'main_photo' FROM users WHERE id = 7;

SELECT
  first_name,
  last_name,
  (SELECT name FROM cities WHERE id = 
    (SELECT city_id FROM profiles WHERE user_id = 7)) AS city,
  (SELECT filename FROM media WHERE id = 
    (SELECT photo_id FROM profiles WHERE user_id = 7)
  ) AS file_path
  FROM users
    WHERE id = 7;  

-- Дорабатывем условия    
SELECT
  first_name,
  last_name,
  (SELECT name FROM cities WHERE id = 
    (SELECT city_id FROM profiles WHERE user_id = users.id)) AS city,
  (SELECT filename FROM media WHERE id = 
    (SELECT photo_id FROM profiles WHERE user_id = users.id)
  ) AS file_path
  FROM users
    WHERE id = 7;          

-- Получаем фотографии пользователя
SELECT filename FROM media
  WHERE user_id = 7
    AND media_type_id = (
      SELECT id FROM media_types WHERE name = 'image'
    );
    
SELECT * FROM media_types;

-- Выбираем историю по добавлению фотографий пользователем
SELECT CONCAT(
  'Пользователь ', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = media.user_id),
  ' добавил фото ', 
  filename, ' ', 
  created_at) AS news 
    FROM media 
    WHERE user_id = 7 AND media_type_id = (
        SELECT id FROM media_types WHERE name = 'image'
);

-- Найдём кому принадлежат 10 самых больших медиафайлов
SELECT user_id, filename, size 
  FROM media 
  ORDER BY size DESC
  LIMIT 10;
  
 -- Выбираем друзей пользователя с двух сторон отношения дружбы
(SELECT friend_id FROM friendships WHERE user_id = 7)
UNION
(SELECT user_id FROM friendships WHERE friend_id = 7);

-- Выбираем только друзей с активным статусом
SELECT * FROM friendship_statuses;

(SELECT friend_id 
  FROM friendships 
  WHERE user_id = 7 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
    )
)
UNION
(SELECT user_id 
  FROM friendships 
  WHERE friend_id = 7 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
    )
);


-- Выбираем медиафайлы друзей
SELECT filename FROM media WHERE user_id IN (
  (SELECT friend_id 
  FROM friendships 
  WHERE user_id = 7 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
    )
  )
  UNION
  (SELECT user_id 
    FROM friendships 
    WHERE friend_id = 7 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
    )
  )
);

-- Определяем пользователей, общее занимаемое место медиафайлов которых 
-- превышает 100МБ
SELECT user_id, SUM(size) AS total
  FROM media
  GROUP BY user_id
  HAVING total > 100000000;
  
-- С итогами  
SELECT user_id, SUM(size) AS total
  FROM media
  GROUP BY user_id WITH ROLLUP
  HAVING total > 100000000;  
    
-- Выбираем сообщения от пользователя и к пользователю
SELECT from_user_id, to_user_id, body, is_delivered, created_at 
  FROM messages
    WHERE from_user_id = 7 OR to_user_id = 7
    ORDER BY created_at DESC;
    
-- Сообщения со статусом
SELECT from_user_id, 
  to_user_id, 
  body, 
  IF(is_delivered, 'delivered', 'not delivered') AS status 
    FROM messages
      WHERE (from_user_id = 7 OR to_user_id = 7)
    ORDER BY created_at DESC;
    
-- Поиск пользователя по шаблонам имени  
SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM users
  WHERE first_name LIKE 'M%';
  
-- Используем регулярные выражения
SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM users
  WHERE last_name RLIKE '^K.*r$';
  
  
  
-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. 
-- Агрегация данных”

-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:

-- 1. Создать и заполнить таблицы лайков и постов.

-- 2. Создать все необходимые внешние ключи и диаграмму отношений.

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

-- 4. Подсчитать количество лайков которые получили 10 самых молодых пользователей. 

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в
-- использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).

