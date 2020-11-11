-- Урок 4
-- CRUD операции

-- Работа с БД vk
-- Загружаем дамп консольным клиентом
DROP DATABASE vk;
CREATE DATABASE vk;

-- Переходим в папку с дампом 
-- mysql -u root -p vk < vk.dump.sql


-- Доработки и улучшения структуры БД vk
USE vk;

-- Вариант 1
-- Из таблицы profiles вынести в отдельные таблицы Статус, Страна, Город. Это справочные данные и их удобно держать отдельно

create table profiles_statuses (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    name VARCHAR(30) NOT NULL UNIQUE COMMENT "Название статуса",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Статусы профилей";

-- Вносим изменения
CREATE TABLE profile_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(30) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Статусы профилей";

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  photo_id INT UNSIGNED COMMENT "Ссылка на основную фотографию пользователя",
  status_id INT UNSIGNED NOT NULL COMMENT "Идентификатор статуса",
  city_id INT UNSIGNED NOT NULL COMMENT "Идентификатор города проживания",
  -- Поле COUNTRY убрано, так как может быть получено из поля CITY 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили";

ALTER TABLE profiles ADD COLUMN status_id INT UNSIGNED NOT NULL COMMENT "Идентификатор статуса" AFTER photo_id;

-- Вносим изменения
CREATE TABLE countries (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(50) NOT NULL UNIQUE COMMENT "Название страны",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Список стран";

-- Вносим изменения
CREATE TABLE cities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  country_id INT UNSIGNED NOT NULL COMMENT "Идентификатор страны",
  name VARCHAR(50) NOT NULL UNIQUE COMMENT "Название города",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Список стран";


-- Вариант 2
-- по таблице friendships

requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",

PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ"

-- Из того как я представляю логику работы таблицы requested_at и created_at полностью себя дублируют. 
-- А с учетом составного первичного ключа и единственно возможного измениения(confirmed_at),
-- то confirmed_at и updated_at тоже дублируются. 
-- Как итог -возможно все сократить до createdat/updated_at

DESC friendships;
-- Вносим изменения
ALTER TABLE friendships DROP COLUMN requested_at;


-- Вариант 3
CREATE TABLE `messages_communities_relations` (
  `message_id` bigint(20) unsigned NOT NULL COMMENT 'Ссылка на сообщение',
  `community_id` bigint(20) unsigned NOT NULL COMMENT 'Ссылка на группу',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`message_id`,`community_id`) COMMENT 'Составной первичный ключ',
  KEY `community_id` (`community_id`),
  CONSTRAINT `messages_communities_relations_ibfk_1` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_communities_relations_ibfk_2` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Связи сообщений и групп';

CREATE TABLE `messages_users_relations` (
  `message_id` bigint(20) unsigned NOT NULL COMMENT 'Ссылка на сообщение',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'Ссылка на получателя сообщения',
  `is_delivered` tinyint(1) DEFAULT NULL COMMENT 'Признак доставки',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`message_id`,`user_id`) COMMENT 'Составной первичный ключ',
  KEY `user_id` (`user_id`),
  CONSTRAINT `messages_users_relations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_users_relations_ibfk_2` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Связи сообщений и пользователей';


-- Вариант 4
-- Очевидно, что в БД нужно добавлять связи (внешние ключи таблиц).
--  Поскольку таблицы уже заполнены, полагаю, что будем добавлять ключи через ALTER TABLE. 
-- А пока можно добавить пару аналогичных таблиц, только другой тематики

-- Таблица для фото
CREATE TABLE photos (
  id SERIAL PRIMARY KEY,
  album_id BIGINT unsigned NOT NULL,
  media_id BIGINT unsigned NOT NULL
);

-- Таблица для профайлов компаний
CREATE TABLE company_profail (
    `company_id` serial, 
    company_name VARCHAR(100),
    company_description LONGTEXT,
    company_adres varchar(300),
    company_created DATE NULL,
    company_contacts json 
);	

-- Таблица для комментариев
CREATE TABLE comments (
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	to_user_id BIGINT UNSIGNED NOT NULL, -- кому сообщение
	to_media_id BIGINT UNSIGNED NULL,  
	to_photo_id BIGINT UNSIGNED NULL 
);

-- Вопросы по БД следующие:
-- Зачем задаём значения как уникальные?
-- media_types(name)
-- friendship_statuses(name)


-- Вариант 5
-- Я добавил в таблицу дружбы столбец relative (родственник)
-- и переименовал таблицу в friendships_relatives:
status_relative_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус родственности"

-- так же создал таблицу родственных связей:
-- Таблица родственных связей
CREATE TABLE relative_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создание строки",
  update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Статус родственности"


-- Не очень понятен параметр photo_id в profiles, в media есть
-- ссылки на полльзователей, или фото ай ди про другое?
-- Естественно необходимо добавить внешние ключи для контроля,
-- правильные ли параметры вносятся в таблицы.


-- Вариант 6
-- таблица постов именно те которые делает пользватель у себя на странице
CREATE TABLE twitter(
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Посты";


-- Вариант 7
-- Изменить тип данных для пола в профилях на ENUM
DESC profiles;
SELECT DISTINCT gender FROM profiles;

-- Вносим изменения
ALTER TABLE profiles MODIFY COLUMN gender ENUM('D', 'P', 'M') NOT NULL;



-- Дорабатываем тестовые данные
-- Смотрим все таблицы
SHOW TABLES;

-- Анализируем данные пользователей
SELECT * FROM users LIMIT 10;

-- Смотрим структуру таблицы пользователей
DESC users;

-- Приводим в порядок временные метки
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;                  

-- Смотрим структуру профилей
DESC profiles;

-- Анализируем данные
SELECT * FROM profiles LIMIT 10;

-- Добавляем ссылки на фото
UPDATE profiles SET photo_id = FLOOR(1 + RAND() * 100);

-- Работаем с статусам профиля
SELECT * FROM profile_statuses;

-- Добавим пару статусов
INSERT INTO profile_statuses (name) VALUES ('active'), ('pending'), ('disabled'); 

-- Обновим ссылки на статусы в профилях
UPDATE profiles SET status_id = 1;

-- Выставим нескольких пользователей в другие статусы
UPDATE profiles SET status_id = 2 WHERE user_id IN (3, 56, 78, 83, 22);
UPDATE profiles SET status_id = 3 WHERE user_id IN (32, 6, 81, 88, 43);

-- Удалим старый столбец статуса
ALTER TABLE profiles DROP COLUMN status;

-- Добавим ссылки на города
ALTER TABLE profiles ADD COLUMN city_id INT UNSIGNED AFTER city;

-- Заполним таблицу городов
ALTER TABLE cities MODIFY COLUMN country_id INT UNSIGNED;
INSERT INTO cities (name) SELECT DISTINCT city FROM profiles;

-- Заполним таблицу стран
INSERT INTO countries (name) SELECT DISTINCT country FROM profiles;

-- Заполним ссылки на страну в справочнике городов
SELECT COUNT(*) FROM countries;
UPDATE cities SET country_id = FLOOR(1 + RAND() * 82);
ALTER TABLE cicies MODIFY COLUMN country_id INT UNSIGNED NOT NULL;

-- Заполним ссылки на города в профилях
SELECT COUNT(*) FROM cities;
UPDATE profiles SET city_id = FLOOR(1 + RAND() * 100);

-- Удалим столбцы city и country
ALTER TABLE profiles DROP column city;
ALTER TABLE profiles DROP column country;

-- Смотрим структуру таблицы сообщений
DESC messages;

-- Анализируем данные
SELECT * FROM messages LIMIT 10;

-- Обновляем значения ссылок на отправителя и получателя сообщения
UPDATE messages SET 
  from_user_id = FLOOR(1 + RAND() * 100),
  to_user_id = FLOOR(1 + RAND() * 100);

-- Смотрим структуру таблицы медиаконтента 
DESC media;

-- Анализируем данные
SELECT * FROM media LIMIT 10;

-- Перемешивам ссылки на владельца
UPDATE media SET user_id = FLOOR(1 + RAND() * 100);

-- Создаём временную таблицу форматов медиафайлов
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));

-- Заполняем значениями
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');

-- Проверяем
SELECT * FROM extensions;

-- Обновляем ссылку на файл
UPDATE media SET filename = CONCAT(
  'http://dropbox.net/vk/',
  filename,
  (SELECT last_name FROM users ORDER BY RAND() LIMIT 1),
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

-- Обновляем размер файлов
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

-- Заполняем метаданные
UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');  

-- Возвращаем столбцу метеданных правильный тип
ALTER TABLE media MODIFY COLUMN metadata JSON;

-- Анализируем типы медиаконтента
SELECT * FROM media_types;

-- Удаляем все типы
DELETE FROM media_types;

-- Добавляем нужные типы
INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

-- DELETE не сбрасывает счётчик автоинкрементирования,
-- поэтому применим TRUNCATE
TRUNCATE media_types;

-- Обновляем данные для ссылки на владельца
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);


-- Смотрим структуру таблицы дружбы
DESC friendships;

-- Анализируем данные
SELECT * FROM friendships LIMIT 10;

-- Обновляем ссылки на друзей
UPDATE friendships SET 
  user_id = FLOOR(1 + RAND() * 100),
  friend_id = FLOOR(1 + RAND() * 100);

-- Исправляем случай когда user_id = friend_id
UPDATE friendships SET friend_id = friend_id + 1 WHERE user_id = friend_id;
 
-- Анализируем данные 
SELECT * FROM friendship_statuses;

-- Очищаем таблицу
TRUNCATE friendship_statuses;

-- Вставляем значения статусов дружбы
INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');
 
-- Обновляем ссылки на статус 
UPDATE friendships SET status_id = FLOOR(1 + RAND() * 3); 

-- Анализируем данные
SELECT * FROM communities;

-- Удаляем часть групп
DELETE FROM communities WHERE id > 20;

-- Анализируем таблицу связи пользователей и групп
SELECT * FROM communities_users;

-- Обновляем значения community_id
UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 20);

-- Использование справки в терминальном клиенте
HELP SELECT;

-- Документация
-- https://dev.mysql.com/doc/refman/8.0/en/
-- http://www.rldp.ru/mysql/mysql80/index.htm


-- Практическое задание по теме “CRUD - операции”

-- 1.Повторить все действия по доработке БД vk.

-- 2.Подобрать сервис который будет служить основой для вашей курсовой работы.

-- 3(по желанию) Предложить свою реализацию лайков и постов.


