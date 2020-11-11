USE vk;
SHOW INDEX FROM likes ;
-- users
CREATE INDEX users_first_name_idx ON users(first_name);
CREATE INDEX users_last_name_idx ON users(last_name);
-- profiles
CREATE INDEX profiles_birthday_idx ON profiles(birthday);
-- media
CREATE INDEX media_filename_idx ON media(filename);
CREATE INDEX media_user_id_idx ON media(user_id);
-- messages
CREATE INDEX messages_from_user_id_to_user_id_idx ON messages(from_user_id,to_user_id);
-- frendships
CREATE INDEX friendships_user_id_friend_id_idx ON friendships(user_id,friend_id);

 -- 2. Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT DISTINCT	
	communities.name,
	((SELECT COUNT(*) FROM communities_users)/(SELECT COUNT(*) FROM communities)) AS average,
	COUNT(communities.id) OVER w AS usersInCommunity, 
	MAX(profiles.birthday) OVER w AS  youngestUser,
	MIN(profiles.birthday) OVER w AS oldestUser,
	COUNT(profiles.user_id) OVER() AS total,
	COUNT(communities.id) OVER w / COUNT(profiles.user_id) OVER() * 100 AS "%"
	FROM communities_users 
JOIN communities
	ON communities.id = communities_users.community_id 	
JOIN profiles 
	ON communities_users.user_id = profiles.user_id
WINDOW w AS (PARTITION BY communities.id);

