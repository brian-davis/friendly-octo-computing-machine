module Citation
  class Bibliography < Citation::Base
    def entry
      if work.children.any? && work.editors.any?
        return unless work.publisher && work.year_of_publication

        editor_names = producer_names(:editor)

        editor_status = work.editors.count > 1 ? "eds." : "ed."
        title = work.long_title
        publisher = work.publisher.name
        year = work.year_of_publication

        "#{editor_names}, #{editor_status}, _#{title}_ (#{publisher}, #{year})."
      elsif work.format_book? || work.format_translated_book?
        return unless work.authors.any? && work.publisher && work.year_of_publication

        title = work.long_title
        publisher = work.publisher.name
        year = work.year_of_publication

        if work.translators.any?
          translator_names = producer_names(:translator)
          strict_author_names = alpha_producer_names(:author)
          "#{strict_author_names}. _#{title}_. Translated by #{translator_names}. #{publisher}, #{year}."
        else
          strict_author_names = alpha_producer_names(:author)
          "#{strict_author_names}. _#{title}_. #{publisher}, #{year}."
        end
      elsif work.format_chapter?
        return unless work.authors.any? && work.parent.publisher && work.parent.year_of_publication

        title = work.long_title

        parent_editor_names = Citation::Base.new(work.parent).producer_names(:editors)

        parent_title = work.parent.long_title
        parent_publisher = work.parent.publisher.name
        parent_year = work.parent.year_of_publication

        if work.translators.any?
          translator_names = producer_names(:translators)

          "#{formatted_authors}. “#{title}.” Translated by #{translator_names}. In _#{parent_title}_, edited by #{parent_editors}. #{parent_publisher}, #{parent_year}."
        else
          "#{alpha_producer_names}. “#{title}.” In _#{parent_title}_, edited by #{parent_editor_names}. #{parent_publisher}, #{parent_year}."
        end
      else
        # TODO
        ""
      end
    end

  protected
    # first result is 'last, first middle', rest are 'first middle last'
    def alpha_producer_names(role = nil)
      rindex = WorkProducer.roles[role]
      role_sql = if rindex
        "AND wp.role = #{rindex}"
      end

      # too complex for pluck
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

    # DEPRECATED: keeping original code for reference, testing, benchmarking
    def _alpha_producer_names(role = :author)
      role_method = role.to_s.pluralize
      first_author_name = work.send(role_method).limit(1).pluck_alpha_name
      rest_author_names = work.send(role_method).offset(1).pluck_full_name
      author_names = (first_author_name + rest_author_names).to_sentence({ two_words_connector: ", and "})
    end
  end
end