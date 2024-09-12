class CreateWorkProducers < ActiveRecord::Migration[7.1]
  def change
    create_table :work_producers do |t|
      t.references :work, null: false, foreign_key: true
      t.references :producer, null: false, foreign_key: true

      # TODO: postgresql enum column
      t.integer :role, default: 0, index: true

      t.timestamps
    end
    add_unique_constraint :work_producers, [:work_id, :producer_id, :role], deferred: true
  end
end
