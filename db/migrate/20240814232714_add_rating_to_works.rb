class AddRatingToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :rating, :integer
  end
end
