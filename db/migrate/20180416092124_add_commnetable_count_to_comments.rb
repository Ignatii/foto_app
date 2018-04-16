class AddCommnetableCountToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :commentable_count, :integer, default: 0
  end
end
