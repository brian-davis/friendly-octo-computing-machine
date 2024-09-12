class EnableExtensions < ActiveRecord::Migration[7.1]
  def change
    function_sql = <<~SQLTEXT.squish
      CREATE EXTENSION unaccent;
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
