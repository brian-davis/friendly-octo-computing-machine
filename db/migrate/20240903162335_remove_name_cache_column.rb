class RemoveNameCacheColumn < ActiveRecord::Migration[7.1]
  def up
    remove_column(:producers, :name)
  end

  def down
    add_column(:producers, :name, :string)
  end
end
