class AddTagsToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :tags, :string, array: true, default: []
    add_index :works, :tags, using: "gin"
  end
end
