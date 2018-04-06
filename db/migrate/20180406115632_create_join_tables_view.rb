class CreateJoinTablesView < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE VIEW join_tables AS
        SELECT  
		 i.id as idd,
		 i.image as image,
		 i.user_id as i_u_id,
		 i.created_at as i_created_at,
		 i.aasm_state as state,
		 i.title_img as title,
		 i.tags as tags,
		 i.likes_img as likes,
		 u.id as u_id,
		 u.name as name,
		 u.email as email,
		 c.id as c_id,
		 c.body as comment_text,
         c.created_at as c_created_at
		FROM images as i
		INNER JOIN users as u ON u.id = i.user_id
		INNER JOIN comments as c ON c.commentable_id = i.id
		ORDER BY i.likes_img ASC
    SQL
  end
end
