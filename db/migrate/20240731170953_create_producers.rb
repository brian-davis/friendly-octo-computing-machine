class CreateProducers < ActiveRecord::Migration[7.1]
  def change
    create_table :producers do |t|
      t.string :custom_name
      t.string :given_name
      t.string :middle_name
      t.string :family_name
      t.string :foreign_name
      t.string :name

      t.timestamps
    end
  end
end
