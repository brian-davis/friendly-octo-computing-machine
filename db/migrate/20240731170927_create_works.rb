class CreateWorks < ActiveRecord::Migration[7.1]
  def up
    create_table :works do |t|
      t.string :title
      t.string :subtitle
      t.string :supertitle
      t.string :alternate_title
      t.string :foreign_title
      t.string :custom_citation
     
      t.text :accession_note
     
      t.string :tags, array: true, default: []
      
      # t.integer :format, default: 0, index: true

      # TODO: real enum
      t.string :language
      t.string :original_language
      
      # https://guides.rubyonrails.org/association_basics.html#self-joins
      t.references :parent, null: true, foreign_key: {to_table: :works}

      t.integer :rating
      
      t.integer :year_of_composition
      t.integer :year_of_publication
      
      t.date :date_of_completion
      t.date :date_of_accession
      t.timestamps
    end

    # https://naturaily.com/blog/ruby-on-rails-enum
    execute <<-SQL
      CREATE TYPE work_format AS ENUM ('book', 'chapter', 'ebook', 'journal_article', 'news_article', 'book_review', 'interview', 'thesis', 'web_page', 'social_media', 'video', 'personal');
    SQL
    add_column :works, :format, :work_format, default: "book"

    add_index :works, :format
    add_index :works, :tags, using: "gin"
  end

  def down
    remove_index :works, :tags
    remove_index :works, :work_format

    remove_column :works, :format
    execute <<-SQL
      DROP TYPE work_format;
    SQL

    drop_table :works
  end
end
