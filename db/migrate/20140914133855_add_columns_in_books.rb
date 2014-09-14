class AddColumnsInBooks < ActiveRecord::Migration
  def change
    add_column :books, :name, :string
    add_column :books, :authors, :string
    add_column :books, :imageHref, :string
    add_column :books, :description, :string
    add_column :books, :authorInfo, :string
    add_column :books, :price, :string
    add_column :books, :publisher, :string
    add_column :books, :publishDate, :string
  end
end
