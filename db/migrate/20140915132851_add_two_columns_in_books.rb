class AddTwoColumnsInBooks < ActiveRecord::Migration
  def change
    add_column  :books, :author_info, :text
    add_column  :books, :description, :text
  end
end
