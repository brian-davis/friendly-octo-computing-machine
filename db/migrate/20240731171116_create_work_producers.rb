class CreateWorkProducers < ActiveRecord::Migration[7.1]
  def up
    create_table :work_producers do |t|
      t.references :work, null: false, foreign_key: true
      t.references :producer, null: false, foreign_key: true

      # t.integer :role, default: 0, index: true

      t.timestamps
    end

    execute <<-SQL
      CREATE TYPE work_producer_role AS ENUM ('author', 'editor', 'contributor', 'translator', 'illustrator');
    SQL
    add_column :work_producers, :role, :work_producer_role, default: "author"

    add_index :work_producers, :role

    add_unique_constraint :work_producers, [:work_id, :producer_id, :role], deferred: true
  end

  def down
    remove_unique_constraint :work_producers, [:work_id, :producer_id, :role], deferred: true
    remove_index :work_producers, :role
    remove_column :work_producers, :role
    execute <<-SQL
      DROP TYPE work_producer_role;
    SQL
    drop_table :work_producers
  end
end
