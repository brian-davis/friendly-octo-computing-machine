class AddFieldsToProducer < ActiveRecord::Migration[7.1]
  def change
    add_column :producers, :birth_year, :integer
    add_column :producers, :death_year, :integer
    add_column :producers, :bio_link, :string
    add_column :producers, :nationality, :string
  end
end
