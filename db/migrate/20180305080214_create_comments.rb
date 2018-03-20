# add coments model
class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.text :body
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
