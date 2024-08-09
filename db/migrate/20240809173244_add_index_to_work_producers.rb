class AddIndexToWorkProducers < ActiveRecord::Migration[7.1]
  def change
    add_index :work_producers, [:work_id, :producer_id, :role], unique: true
  end
end
