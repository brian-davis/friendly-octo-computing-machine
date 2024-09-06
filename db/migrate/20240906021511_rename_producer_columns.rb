class RenameProducerColumns < ActiveRecord::Migration[7.1]
  def up
    remove_unique_constraint :producers, [:given_name, :family_name, :birth_year]

    rename_column :producers, :birth_year, :year_of_birth
    rename_column :producers, :death_year, :year_of_death

    add_unique_constraint :producers, [:given_name, :family_name, :year_of_birth]
  end

  def down
    remove_unique_constraint :producers, [:given_name, :family_name, :year_of_birth]

    rename_column :producers, :year_of_birth, :birth_year
    rename_column :producers, :year_of_death, :death_year

    add_unique_constraint :producers, [:given_name, :family_name, :birth_year]
  end
end
