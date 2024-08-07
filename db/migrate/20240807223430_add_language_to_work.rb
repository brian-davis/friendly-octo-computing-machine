class AddLanguageToWork < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :language, :string
    add_column :works, :original_language, :string
  end
end
