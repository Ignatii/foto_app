class AddLikesToImages < ActiveRecord::Migration[5.1]
  def change
  	add_column :images, :likes_img, :integer, default: 0
  end
end
