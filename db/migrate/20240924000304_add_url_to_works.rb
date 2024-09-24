class AddUrlToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :ebook_source, :string
  end
end
