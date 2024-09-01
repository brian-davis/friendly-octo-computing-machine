# https://github.com/Casecommons/pg_search
# https://pganalyze.com/blog/full-text-search-ruby-rails-postgres
# https://www.freecodecamp.org/news/fuzzy-string-matching-with-postgresql/
# https://www.postgresql.org/docs/current/fuzzystrmatch.html

class AddPgSearchColumns < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TABLE quotes
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(text, '')), 'A')
      ) STORED;
    SQL

    execute <<-SQL
      ALTER TABLE works
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(title, '')), 'A')
      ) STORED;
    SQL

    execute <<-SQL
      ALTER TABLE producers
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(custom_name, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(given_name, '')), 'B') ||

        setweight(to_tsvector('english', coalesce(family_name, '')), 'C') ||
        setweight(to_tsvector('english', coalesce(foreign_name, '')), 'D')
      ) STORED;
    SQL
  end

  def down
    remove_column :quotes, :searchable
    remove_column :works, :searchable
    remove_column :producers, :searchable
  end
end