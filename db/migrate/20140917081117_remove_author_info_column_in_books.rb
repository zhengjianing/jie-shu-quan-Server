class RemoveAuthorInfoColumnInBooks < ActiveRecord::Migration
  def change
    remove_column  :books, :authorInfo, :string
  end
end
