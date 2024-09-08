class AddFinishedToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :finished, :boolean
  end
end
