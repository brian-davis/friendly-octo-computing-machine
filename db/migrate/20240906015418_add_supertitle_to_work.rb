class AddSupertitleToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :supertitle, :string
  end
end
