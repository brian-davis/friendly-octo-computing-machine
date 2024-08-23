class CreateReadingSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :reading_sessions do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.references :work, null: false, foreign_key: true
      t.integer :pages
      t.integer :duration

      t.timestamps
    end
  end
end
