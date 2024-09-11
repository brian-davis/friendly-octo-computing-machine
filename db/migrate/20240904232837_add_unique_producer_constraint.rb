class AddUniqueProducerConstraint < ActiveRecord::Migration[7.1]
  def change
    # TODO
    add_unique_constraint :producers, [:forename, :surname, :birth_year]
  end
end
