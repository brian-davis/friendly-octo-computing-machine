module ProducerSql
  FULL_NAME_SQL = <<~SQL.squish
    COALESCE(
      NULLIF(producers.custom_name, ''),
      CONCAT_WS(
        ' ',
        NULLIF(producers.forename, ''),
        NULLIF(producers.middle_name, ''),
        NULLIF(producers.surname, '')
      )
    )
  SQL

  FULL_SURNAME_SQL = <<~SQL.squish
    COALESCE(
      NULLIF(producers.custom_name, ''),
      CONCAT_WS(
        ', ',
        NULLIF(producers.surname, ''),
        CONCAT_WS(
          ' ',
          NULLIF(producers.forename, ''),
          NULLIF(producers.middle_name, '')
        )
      )
    )
  SQL

  SURNAME_SQL = <<~SQL.squish
    COALESCE(
      NULLIF(producers.custom_name, ''),
      NULLIF(producers.surname, '')
    )
  SQL
end