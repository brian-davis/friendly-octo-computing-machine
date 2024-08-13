# https://www.postgresql.org/docs/current/fuzzystrmatch.html

# https://www.freecodecamp.org/news/fuzzy-string-matching-with-postgresql/

# https://thoughtbot.com/blog/optimizing-full-text-search-with-postgres-tsvector-columns-and-triggers

# https://pganalyze.com/blog/full-text-search-ruby-rails-postgres

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
        setweight(to_tsvector('english', coalesce(name, '')), 'A')
      ) STORED;
    SQL
  end

  def down
    remove_column :quotes, :searchable
    remove_column :works, :searchable
    remove_column :producers, :searchable
  end
end
