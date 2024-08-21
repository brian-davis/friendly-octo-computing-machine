class ChangeQuoteSection < ActiveRecord::Migration[7.1]
  def up
    rename_column :quotes, :section, :custom_citation
  end

  def down
    rename_column :quotes, :custom_citation, :section
  end
end
