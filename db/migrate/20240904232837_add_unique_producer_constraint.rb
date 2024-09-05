class AddUniqueProducerConstraint < ActiveRecord::Migration[7.1]
  def change
    add_unique_constraint :producers, [:given_name, :family_name, :birth_year]
  end
  # -- execute("ALTER TABLE \"producers\" ADD CONSTRAINT producers_given_name_family_name_birth_year_unique UNIQUE (\"given_name\", \"family_name\", \"birth_year\") DEFERRABLE INITIALLY IMMEDIATE")
end
