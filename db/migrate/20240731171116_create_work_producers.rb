class CreateWorkProducers < ActiveRecord::Migration[7.1]
  def change
    create_table :work_producers do |t|
      t.references :work, null: false, foreign_key: true
      t.references :producer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
