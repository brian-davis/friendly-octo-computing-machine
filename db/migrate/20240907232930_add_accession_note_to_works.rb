class AddAccessionNoteToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :accession_note, :text
  end
end
