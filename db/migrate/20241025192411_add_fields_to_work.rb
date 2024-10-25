class AddFieldsToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :condition, :integer
    add_column :works, :cover, :integer
    add_column :works, :series_ordinal, :integer
  end
end
