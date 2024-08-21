class AddCustomCitationToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :custom_citation, :string
  end
end
