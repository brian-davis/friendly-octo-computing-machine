class AddLocationFieldToPublisher < ActiveRecord::Migration[7.1]
  def change
    add_column :publishers, :location, :string
  end
end
