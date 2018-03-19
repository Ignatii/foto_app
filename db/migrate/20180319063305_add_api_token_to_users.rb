class AddApiTokenToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :api_token, :string
  	add_column :users, :email, :string
  end
end
