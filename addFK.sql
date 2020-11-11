use vk;
desc communities_users;

ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT communities_users_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;

AlTER TABLE cities 
	 ADD CONSTRAINT cities_country_id_fk 
    	FOREIGN KEY (country_id) REFERENCES countries(id)
    		ON DELETE SET NULL;

 select * from media;
desc media ;
 
AlTER TABLE media 
	 ADD CONSTRAINT media_media_type_id_fk 
    	FOREIGN KEY (media_type_id) REFERENCES media_types(id)
    		ON DELETE CASCADE;

desc friendships ;

ALTER TABLE friendships
  ADD CONSTRAINT friendships_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendships_friend_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendships_status_id_fk 
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
      ON DELETE CASCADE;

desc messages;

ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
 desc posts;

ALTER TABLE posts
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT posts_community_id_fk 
    	FOREIGN KEY (community_id) REFERENCES communities(id)
    		ON DELETE CASCADE,
  ADD CONSTRAINT posts_media_id_fk 
    	FOREIGN KEY (media_id) REFERENCES media(id)
    		ON DELETE SET NULL;
 
    	
 desc likes;

ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT likes_target_type_id_fk 
    FOREIGN KEY (target_type_id) REFERENCES target_types(id)
      ON DELETE CASCADE;
  
  
    