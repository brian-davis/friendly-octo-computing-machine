class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes do |t|
      t.text :text
      t.string :page
      t.string :custom_citation
      t.references :work, null: false, foreign_key: true

      t.timestamps
    end
  end
end
