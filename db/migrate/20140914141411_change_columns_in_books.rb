class ChangeColumnsInBooks < ActiveRecord::Migration
  def change
    rename_column :books, :imageHref, :image_href
    rename_column :books, :authorInfo, :author_info
    rename_column :books, :publishDate, :publish_date
  end
end
