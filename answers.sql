-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

(
select count(user_id) as numberLikes from likes where user_id in
	(select user_id from profiles where gender = "F")
)
UNION
(
select count(user_id) from likes where user_id in
	(select user_id from profiles where gender = "M")
);

-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).

SELECT COUNT(user_id) FROM likes 
	WHERE user_id IN 
		(SELECT * FROM 
			(SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10) 
		temp);


--  5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети

SELECT first_name, last_name, count(user_id) AS numberLikes 
FROM users, likes WHERE users.id = likes.user_id 
GROUP BY user_id ORDER BY numberLikes LIMIT 10;
 
 
 