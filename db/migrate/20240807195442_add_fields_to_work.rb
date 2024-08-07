class AddFieldsToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :subtitle, :string
    add_column :works, :alternate_title, :string
    add_column :works, :foreign_title, :string
    add_column :works, :year_of_composition, :integer
    add_column :works, :year_of_publication, :integer
  end
end
