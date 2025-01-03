# https://github.com/Casecommons/pg_search?tab=readme-ov-file#dmetaphone-double-metaphone-soundalike-search
# https://www.freecodecamp.org/news/fuzzy-string-matching-with-postgresql/
# https://github.com/Casecommons/pg_search
# https://pganalyze.com/blog/full-text-search-ruby-rails-postgres
# https://www.freecodecamp.org/news/fuzzy-string-matching-with-postgresql/
# https://www.postgresql.org/docs/current/fuzzystrmatch.html
# https://github.com/Casecommons/pg_search?tab=readme-ov-file#pg_search_scope

# 20240813213517_add_pg_search_indexes
class AddPgSearchIndexes < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    quotes_sql = <<-SQL.squish
      ALTER TABLE quotes
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(text, '')), 'A')
      ) STORED;
    SQL
    execute(quotes_sql)

    works_sql = <<-SQL.squish
      ALTER TABLE works
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('unaccented_dict', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('unaccented_dict', coalesce(subtitle, '')), 'B') ||
        setweight(to_tsvector('unaccented_dict', coalesce(supertitle, '')), 'C') ||
        setweight(to_tsvector('unaccented_dict', coalesce(foreign_title, '')), 'D')
      ) STORED;
    SQL
    execute(works_sql)

    producers_sql = <<-SQL
      ALTER TABLE producers
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('unaccented_dict', coalesce(custom_name, '')), 'A') ||
        setweight(to_tsvector('unaccented_dict', coalesce(forename, '')), 'B') ||
        setweight(to_tsvector('unaccented_dict', coalesce(surname, '')), 'C') ||
        setweight(to_tsvector('unaccented_dict', coalesce(foreign_name, '')), 'D')
      ) STORED;
    SQL
    execute(producers_sql)

    add_index :quotes, :searchable, using: :gin, algorithm: :concurrently
    add_index :works, :searchable, using: :gin, algorithm: :concurrently
    add_index :producers, :searchable, using: :gin, algorithm: :concurrently
  end


  def down
    # DEBUG
    remove_index :quotes, :searchable
    remove_index :works, :searchable
    remove_index :producers, :searchable

    remove_column :quotes, :searchable
    remove_column :works, :searchable
    remove_column :producers, :searchable

    function_sql = <<~SQL.squish
      DROP FUNCTION pg_search_dmetaphone(text);
      DROP EXTENSION fuzzystrmatch;
    SQL
    execute(function_sql)
  end
end