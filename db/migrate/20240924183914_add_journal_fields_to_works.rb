class AddJournalFieldsToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :journal_name, :string
    add_column :works, :journal_volume, :integer
    add_column :works, :journal_issue, :integer
    add_column :works, :journal_page_span, :string
  end
end
