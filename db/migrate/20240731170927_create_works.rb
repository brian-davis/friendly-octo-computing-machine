class CreateWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :works do |t|
      t.string :title
      t.string :subtitle
      t.string :supertitle
      t.string :alternate_title
      t.string :foreign_title
      t.string :custom_citation
     
      t.text :accession_note
     
      t.string :tags, array: true, default: []
      
      # TODO: postgresql enum column
      t.integer :format, default: 0, index: true

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

    add_index :works, :tags, using: "gin"
  end
end
