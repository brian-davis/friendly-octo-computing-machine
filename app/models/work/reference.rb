# app/models/post/publisher.rb
class Work::Reference < ActiveRecord::AssociatedObject
  include TimeFormatter

  def short_title
    work.title.sub("The ", "")
  end

  def long_title
    [work.supertitle, work.title, work.subtitle].map(&:presence).compact.join(": ")
  end

  def publisher_name
    work.publisher&.name.presence || work.parent&.publisher&.name
  end

  # TODO: research self-join SQL fallback
  def year_of_publication
    work.year_of_publication || work.parent&.year_of_publication
  end

  def year_of_composition
    work.year_of_composition || work.parent&.year_of_composition
  end

  def language_or_translation
    [work.language, work.original_language].map(&:presence).compact.join(", translated from ")
  end

  # TODO: DRY with alpha_producer_names
  def byline
    # author_names = work.producers.pluck(Arel.sql "COALESCE(NULLIF(producers.custom_name, ''), NULLIF(producers.surname,''))")
    author_names = work.producers.map { |p| p.custom_name || p.surname }

    return "" if author_names.empty?

    author_names = author_names.to_sentence

    year_source = work.year_of_publication.presence ||
                  work.year_of_composition.presence ||
                  work.parent&.year_of_publication.presence ||
                  work.parent&.year_of_composition.presence

    year = common_era_year(year_source) # ApplicationHelper
    [
      author_names,
      year
    ].compact.join(", ")
  end
 
  # :index
  def full_title_line
    byline_result = work.reference.byline
    return work.title if byline_result.blank?
    "#{work.reference.long_title} (#{byline_result})"
  end

  # quotes general index
  def short_title_line
    byline_result = work.reference.byline
    return work.reference.short_title if byline_result.blank?
    "#{work.reference.short_title} (#{byline_result})"
  end

  # full names
  def producer_names(role = :author)
    role_method = role.to_s.pluralize
    work.send(role_method).pluck_full_name.to_sentence
  end

  # last names only
  def producer_last_names(role = :author)
    role_method = role.to_s.pluralize
    work.send(role_method).pluck_last_name.to_sentence
  end

    # first result is 'last, first middle', rest are 'first middle last'
  # TODO: move SQL logic to model.
  def alpha_producer_names(role = nil)
    role_sql = if role
      "AND wp.role = '#{role}'"
    end

    # too complex for pluck?
    sql = <<~SQL.squish
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
          WHERE wp.work_id = #{work.id}
          #{role_sql}
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
          WHERE wp.work_id = #{work.id}
          #{role_sql}
        ORDER BY wp.created_at
        OFFSET 1
      )
    ) AS u
    ORDER BY seq;
    SQL
    results = Producer.connection.select_all(Arel.sql sql)
    results.rows.flatten.to_sentence({ two_words_connector: ", and "})
  end

  # # DEPRECATED: keeping original code for reference, testing, benchmarking
  # def _alpha_producer_names(role = :author)
  #   role_method = role.to_s.pluralize
  #   first_author_name = work.send(role_method).limit(1).pluck_alpha_name
  #   rest_author_names = work.send(role_method).offset(1).pluck_full_name
  #   author_names = (first_author_name + rest_author_names).to_sentence({ two_words_connector: ", and "})
  # end
end