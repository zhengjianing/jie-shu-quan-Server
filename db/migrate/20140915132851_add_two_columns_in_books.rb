class AddTwoColumnsInBooks < ActiveRecord::Migration
  def change
    add_column  :books, :authorInfo, :text
    add_column  :books, :description, :text
  end
end
