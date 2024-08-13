class AddPgSearchIndexes < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_index :quotes, :searchable, using: :gin, algorithm: :concurrently
    add_index :works, :searchable, using: :gin, algorithm: :concurrently
    add_index :producers, :searchable, using: :gin, algorithm: :concurrently
  end
end