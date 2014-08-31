class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :book_id
      t.string :user_id
      t.boolean :available

      t.timestamps
    end
  end
end
