class ChangeQuotePageToString < ActiveRecord::Migration[7.1]
  def up
    change_column :quotes, :page, :string
  end

  def down
    change_column :quotes, :page, :integer
  end
end
