class CreatePublishers < ActiveRecord::Migration[7.1]
  def change
    create_table :publishers do |t|
      t.string :name
      t.timestamps
    end

    add_reference :works, :publisher, foreign_key: true, null: true
  end
end
