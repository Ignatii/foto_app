class AddTitleAndTagsToImages < ActiveRecord::Migration[5.1]
  def change
  	add_column :images, :title_img, :string
  	add_column :images, :tags, :string
  end
end
