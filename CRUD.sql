DROP DATABASE vk;
CREATE DATABASE vk;
use vk;
-- ?????? ?????????
CREATE TABLE profile_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "????????????? ??????",
  name VARCHAR(30) NOT NULL UNIQUE COMMENT "???????? ???????",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "????? ???????? ??????",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "????? ?????????? ??????"
) COMMENT "??????? ????????";

ALTER TABLE profiles ADD COLUMN status_id INT UNSIGNED NOT NULL COMMENT "????????????? ???????" AFTER photo_id;

-- ?????? ?????????
CREATE TABLE countries (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "????????????? ??????",
  name VARCHAR(50) NOT NULL UNIQUE COMMENT "???????? ??????",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "????? ???????? ??????",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "????? ?????????? ??????"
) COMMENT "?????? ?????";

-- ?????? ?????????
CREATE TABLE cities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "????????????? ??????",
  country_id INT UNSIGNED NOT NULL COMMENT "????????????? ??????",
  name VARCHAR(50) NOT NULL UNIQUE COMMENT "???????? ??????",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "????? ???????? ??????",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "????? ?????????? ??????"
) COMMENT "?????? ?????";

ALTER TABLE friendships DROP COLUMN requested_at;
desc media_types;
desc friendship_statuses;
desc profiles ;

ALTER TABLE profiles MODIFY COLUMN gender ENUM('F', 'M') NOT NULL;
SELECT DISTINCT gender FROM profiles;

SHOW TABLES;
SELECT * FROM users LIMIT 10;
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at ;

SELECT * FROM profiles LIMIT 10;

SELECT photo_id FROM profiles ORDER BY photo_id;
UPDATE profiles SET updated_at = NOW() WHERE updated_at < created_at ;

SELECT * FROM profile_statuses;
INSERT INTO profile_statuses (name) VALUES ('active'),('pending'),('disables');

-- UPDATE profiles SET status_id = FLOOR(1 + RAND() *3);
UPDATE profiles SET status_id = 1;
UPDATE profiles SET status_id = 2 WHERE user_id IN (2, 56, 76, 3, 89);
UPDATE profiles SET status_id = 3 WHERE user_id IN (22, 26, 86, 33, 99);

ALTER TABLE profiles DROP COLUMN status;

ALTER TABLE profiles ADD COLUMN city_id INT UNSIGNED AFTER city; 

INSERT INTO cities (name) SELECT DISTINCT city FROM profiles ;
desc cities ;

ALTER TABLE cities MODIFY COLUMN country_id INT UNSIGNED;
SELECT * FROM cities ;

INSERT INTO countries (name) SELECT DISTINCT country FROM profiles ;
UPDATE cities SET country_id = FLOOR(1 + RAND() * 77);

SELECT * FROM profiles LIMIT 10;
UPDATE profiles SET city_id = FLOOR(1 + RAND() * 100);

ALTER TABLE profiles DROP COLUMN city;
ALTER TABLE profiles DROP COLUMN country;

SELECT * FROM messages;
UPDATE messages SET updated_at = NOW() WHERE updated_at < created_at ;

SELECT * FROM media;
UPDATE media SET updated_at = NOW() WHERE updated_at < created_at ;

CREATE TEMPORARY TABLE exst (name Varchar(10));
INSERT INTO exst (name) VALUES ('jpeg'),('png'),('mpeg4'),('mp3');

UPDATE media SET filename = CONCAT(
	'http//dropbox.net/vk/',
	(SELECT last_name FROM users ORDER BY RAND() LIMIT 1 ),
	(SELECT name FROM exst ORDER BY RAND() LIMIT 1 )
	);

UPDATE media SET `size` = FLOOR(10000 + RAND() * 100000000) WHERE `size` < 1000;

UPDATE media SET metadata = CONCAT('{"owner":"',
	(SELECT CONCAT(first_name,' ', last_name) FROM users WHERE users.id = media.user_id),
	'"}');
desc media;

ALTER TABLE media MODIFY COLUMN metadata JSON;
SELECT * FROM media_types ;

SELECT * FROM friendships;
UPDATE friendships SET updated_at = NOW() WHERE updated_at < created_at ;
UPDATE friendships SET confirmed_at = NOW() WHERE confirmed_at < created_at ;
SELECT * FROM friendship_statuses;
TRUNCATE friendship_statuses;
INSERT INTO friendship_statuses (name) VALUES ('Requested'), ('Confirmed'), ('Rejected');
UPDATE friendships SET status_id = FLOOR(1 + RAND() *3);

SELECT * FROM communities;
UPDATE communities SET updated_at = NOW() WHERE updated_at < created_at ;

SELECT * FROM communities_users;

