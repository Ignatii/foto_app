class AddCommentableCountToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :commentable_count, :integer, default: 0
  end
end
