class AddDateOfAccessionToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :date_of_accession, :date
  end
end
