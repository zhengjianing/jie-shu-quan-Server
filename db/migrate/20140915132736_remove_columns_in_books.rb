class RemoveColumnsInBooks < ActiveRecord::Migration
  def change
    remove_column  :books, :authorInfo, :string
    remove_column  :books, :description, :string
  end
end
