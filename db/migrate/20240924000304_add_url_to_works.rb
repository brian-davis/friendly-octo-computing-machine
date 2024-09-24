class AddUrlToWorks < ActiveRecord::Migration[7.1]
  # rails db:migrate:down VERSION=20240924000304
  def change
    add_column :works, :ebook_source, :string
    add_column :works, :url, :string
  end
end
# db/migrate/20240924000304_add_url_to_works.rb