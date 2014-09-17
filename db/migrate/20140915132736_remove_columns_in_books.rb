class RemoveColumnsInBooks < ActiveRecord::Migration
  def change
    remove_column  :books, :author_info, :string
    remove_column  :books, :description, :string
  end
end
