class AddRoleToWorkProducers < ActiveRecord::Migration[7.1]
  def change
    add_column :work_producers, :role, :integer
  end
end
