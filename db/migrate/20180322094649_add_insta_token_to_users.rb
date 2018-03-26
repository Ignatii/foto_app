class AddInstaTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :insta_token, :string, default: nil
  end
end
