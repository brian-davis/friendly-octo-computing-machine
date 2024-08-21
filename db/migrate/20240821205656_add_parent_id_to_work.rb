class AddParentIdToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :parent_id, :integer
    add_index :works, :parent_id
  end
end
