class CreatePublishers < ActiveRecord::Migration[7.1]
  def change
    create_table :publishers do |t|
      t.string :name
      t.integer :works_count, default: 0

      t.timestamps
    end

    add_reference :works, :publisher, foreign_key: true, null: true
    add_presence_constraint :publishers, :name, deferred: true
    add_unique_constraint :publishers, :name, deferred: true
  end

end
