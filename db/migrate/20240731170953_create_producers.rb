class CreateProducers < ActiveRecord::Migration[7.1]
  def change
    create_table :producers do |t|
      t.string :custom_name
      t.string :forename
      t.string :middle_name
      t.string :surname
      t.string :foreign_name
      t.string :bio_link
      t.string :nationality

      t.integer :year_of_birth
      t.integer :year_of_death

      t.integer :works_count, default: 0

      t.timestamps
    end

    add_unique_constraint :producers, [:forename, :surname, :year_of_birth]
  end
end
