module WorkSql
  # complex, requires custom substitution
  # TODO: can some of this be built on Producer
  ALPHA_FIRST = <<~SQL.squish
    SELECT alpha_name FROM (
      (
        SELECT
          1 AS seq,
          COALESCE(
            NULLIF(p.custom_name, ''),
            CONCAT_WS(
              ', ',
              NULLIF(p.surname, ''),
              CONCAT_WS(
                ' ',
                NULLIF(p.forename, ''),
                NULLIF(p.middle_name, '')
              )
            )
          ) alpha_name
        FROM producers p
        INNER JOIN work_producers wp
          ON p.id = wp.producer_id
          WHERE wp.work_id = :work_id
          :role_sql
        ORDER BY wp.created_at
        LIMIT 1
      )
      UNION
      (
        SELECT
          2 AS seq,
          COALESCE(
            NULLIF(p.custom_name, ''),
            CONCAT_WS(
              ' ',
              NULLIF(p.forename, ''),
              NULLIF(p.middle_name, ''),
              NULLIF(p.surname, '')
            )
          ) alpha_name
        FROM producers p
        INNER JOIN work_producers wp
          ON p.id = wp.producer_id
          WHERE wp.work_id = :work_id
          :role_sql
        ORDER BY wp.created_at
        OFFSET 1
      )
    ) AS u
    ORDER BY seq;
  SQL

  FULL_TITLE_SQL = <<~SQL.squish
    COALESCE(
      CONCAT_WS(
        ': ',
        NULLIF(works.supertitle, ''),
        NULLIF(works.title, ''),
        NULLIF(works.subtitle, '')
      )
    )
  SQL
end