class AddJournalFieldsToWorks < ActiveRecord::Migration[7.1]
  def change
    # TODO: normalize, avoid dump

    add_column :works, :journal_name, :string
    add_column :works, :journal_volume, :integer
    add_column :works, :journal_issue, :integer
    add_column :works, :article_page_span, :string
    add_column :works, :article_date, :date
    add_column :works, :review_title, :string
    add_column :works, :review_author, :string
    add_column :works, :media_source, :string
    add_column :works, :media_timestamp, :string
    add_column :works, :interviewer_name, :string
    add_column :works, :media_format, :string
    add_column :works, :media_date, :date
  end
end
