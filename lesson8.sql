-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT gender, count(likes.user_id) as total
FROM profiles 
JOIN likes 
	ON profiles.user_id = likes.user_id
GROUP BY gender;


--. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
SELECT SUM(total) 
 FROM
	(SELECT profiles.user_id, likes.target_id , profiles.birthday, count(target_id) as total
	 FROM profiles 
	 LEFT JOIN likes 
	 	ON profiles.user_id = likes.target_id AND target_type_id =2 
	 GROUP BY user_id 
	 ORDER BY birthday desc 
	LIMIT 10) as sumTotal;

 -- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети

SELECT 
	users.id,
	users.first_name,
	users.last_name,
	count(likes.user_id)+
	count(media.user_id)+
	count(messages.from_user_id) AS activity
FROM 
	users 
LEFT JOIN likes 
	ON likes.user_id = users.id
LEFT JOIN  media 
	ON media.user_id = users.id
LEFT JOIN messages 
	ON messages.from_user_id = users.id
GROUP BY users.id 
ORDER BY activity
LIMIT 10;
