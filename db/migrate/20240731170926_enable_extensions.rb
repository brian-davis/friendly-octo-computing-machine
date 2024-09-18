class EnableExtensions < ActiveRecord::Migration[7.1]
  def up
    # https://stackoverflow.com/a/50595181/21928926
    function_sql = <<~SQLTEXT.squish
      CREATE EXTENSION unaccent;

      CREATE TEXT SEARCH CONFIGURATION unaccented_dict (COPY = simple);
      ALTER TEXT SEARCH CONFIGURATION unaccented_dict
        ALTER MAPPING FOR hword, hword_part, word
        WITH unaccent, simple;

      CREATE EXTENSION fuzzystrmatch;

      CREATE OR REPLACE FUNCTION pg_search_dmetaphone(text)
        RETURNS text
        LANGUAGE SQL IMMUTABLE STRICT AS $function$
          SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ')
        $function$;
    SQLTEXT
    execute(function_sql)
  end

  def down
    function_sql = <<~SQL.squish
      DROP FUNCTION IF EXISTS pg_search_dmetaphone;
      DROP TEXT SEARCH CONFIGURATION IF EXISTS unaccented_dict;
      DROP EXTENSION IF EXISTS unaccent;
    SQL
    execute(function_sql)
  end
end
