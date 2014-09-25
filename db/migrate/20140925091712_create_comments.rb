class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :douban_book_id
      t.string :user_name
      t.text :content

      t.timestamps
    end
  end
end
