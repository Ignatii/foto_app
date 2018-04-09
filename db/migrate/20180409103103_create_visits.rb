class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits do |t|
      t.references :user, foreign_key: true
      t.references :country, foreign_key: true
      t.boolean :enable
      t.timestamps
    end
  end
end
