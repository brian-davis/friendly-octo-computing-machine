class AddNotableToNotes < ActiveRecord::Migration[7.1]
  def change
    add_reference :notes, :notable, null: false, polymorphic: true, index: true
    remove_reference :notes, :work, null: false, foreign_key: true
  end
end
