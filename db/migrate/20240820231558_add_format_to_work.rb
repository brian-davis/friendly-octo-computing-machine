class AddFormatToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :format, :integer, default: 0
  end
end
