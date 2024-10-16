class AddWishlistToWorks < ActiveRecord::Migration[7.1]
  def up
    add_column :works, :wishlist, :boolean, default: false
    add_index :works, :wishlist
  end

  def down
    remove_index :works, :wishlist
    remove_column :works, :wishlist
  end
end
