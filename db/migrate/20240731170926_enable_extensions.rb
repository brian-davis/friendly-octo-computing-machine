class EnableExtensions < ActiveRecord::Migration[7.1]
  def change
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
end
