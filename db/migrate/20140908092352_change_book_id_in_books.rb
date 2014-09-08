class ChangeBookIdInBooks < ActiveRecord::Migration
  def change
    rename_column :books, :book_id, :douban_book_id
  end
end
