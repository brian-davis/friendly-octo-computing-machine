class AddConstraintsToPublisher < ActiveRecord::Migration[7.1]
  def change
    add_presence_constraint :publishers, :name, deferred: true
    add_unique_constraint :publishers, :name, deferred: true
  end
end
