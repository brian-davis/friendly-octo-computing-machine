class Citation
  class Bibliography
    attr_reader :work

    def initialize(work)
      @work = work
    end

    def entry
      if work.compilation?
        return unless work.editors.any? && work.publisher && work.year_of_publication

        editor_names = work.editors.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }.to_sentence
        editor_status = work.editors.count > 1 ? "eds." : "ed."
        title_and_subtitle = [work.title, work.subtitle].map(&:presence).compact.join(": ")
        publisher = work.publisher.name
        year = work.year_of_publication

        "#{editor_names}, #{editor_status}, _#{title_and_subtitle}_ (#{publisher}, #{year})."
      elsif work.book?
        return unless work.authors.any? && work.publisher && work.year_of_publication

        authors = work.authors.to_a
        first_author = authors.shift
        first_author_name = [
          first_author.family_name,
          [
            first_author.given_name,
            first_author.middle_name
          ].map(&:presence).compact.join(" ")
        ].map(&:presence).compact.join(", ")
        rest_author_names = authors.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }
        author_names = ([first_author_name] + rest_author_names).to_sentence({ two_words_connector: ", and "})

        title_and_subtitle = [work.title, work.subtitle].map(&:presence).compact.join(": ")
        publisher = work.publisher.name
        year = work.year_of_publication

        if work.translators.any?
          translator_names = work.translators.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }.to_sentence

          "#{author_names}. _#{title_and_subtitle}_. Translated by #{translator_names}. #{publisher}, #{year}."
        else
          "#{author_names}. _#{title_and_subtitle}_. #{publisher}, #{year}."
        end

      elsif work.chapter?
        return unless work.authors.any? && work.parent.publisher && work.parent.year_of_publication

        authors = work.authors.to_a
        first_author = authors.shift
        first_author_name = [
          first_author.family_name,
          [
            first_author.given_name,
            first_author.middle_name
          ].map(&:presence).compact.join(" ")
        ].map(&:presence).compact.join(", ")
        rest_author_names = authors.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }
        author_names = ([first_author_name] + rest_author_names).to_sentence({ two_words_connector: ", and "})

        title_and_subtitle = [work.title, work.subtitle].map(&:presence).compact.join(": ")

        parent_editor_names = work.parent.editors.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }.to_sentence

        parent_title_and_subtitle = [work.parent.title, work.parent.subtitle].map(&:presence).compact.join(": ")
        parent_publisher = work.parent.publisher.name
        parent_year = work.parent.year_of_publication

        if work.translators.any?
          translator_names = work.translators.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }.to_sentence

          "#{formatted_authors}. “#{title}.” Translated by #{translator_names}. In _#{parent_title}_, edited by #{parent_editors}. #{parent_publisher}, #{parent_year}."
        else
          "#{author_names}. “#{title_and_subtitle}.” In _#{parent_title_and_subtitle}_, edited by #{parent_editor_names}. #{parent_publisher}, #{parent_year}."
        end
      else
        # TODO
        ""
      end
    end
  end

  class Note
    attr_reader :quote
    attr_reader :work

    def initialize(quote)
      @quote = quote
      @work = @quote.work
    end

    # only quote
    def short
      if work.book?
        return unless work.authors.any? && quote.page.present?

        author_last_names = work.authors.map { |a| a.custom_name || a.family_name }.to_sentence
        short_title = work.title.sub("The ", "")
        page = quote.page # String
        result = "#{author_last_names}, _#{short_title}_, #{page}."
        return result
      elsif work.chapter?
        return unless work.authors.any? && quote.page.present?

        author_last_names = work.authors.map { |author| author.custom_name || author.family_name }.to_sentence
        short_title = work.title.sub("The ", "")
        "#{author_last_names}, “#{short_title},” #{quote.page}."
      end
    end

    # only quote
    def long
      if work.book?
        return unless work&.authors&.any? && work.year_of_publication && quote.page

        author_names = work.authors.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }.to_sentence
        title_and_subtitle = [work.title, work.subtitle].map(&:presence).compact.join(": ")
        page = quote.page

        publisher = work.publisher.name
        year = work.year_of_publication
        result = "#{author_names}, _#{title_and_subtitle}_ (#{publisher}, #{year}), #{page}."
        return result
      elsif work.chapter?
        return unless work.authors.any? && work.parent && work.parent&.editors&.any? && work.parent&.publisher && work.parent&.year_of_publication && quote.page

        author_names = work.authors.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }.to_sentence

        title_and_subtitle = [work.title, work.subtitle].map(&:presence).compact.join(": ")
        parent_title_and_subtitle = [work.parent.title, work.parent.subtitle].map(&:presence).compact.join(": ")

        editors = work.parent.editors.map { |a| a.custom_name || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }.to_sentence

        parent_publisher_name = work.parent.publisher.name
        parent_year = work.parent.year_of_publication
        page = quote.page

        result = "#{author_names}, “#{title_and_subtitle},” in _#{parent_title_and_subtitle}_, ed. #{editors} (#{parent_publisher_name}, #{parent_year}), #{page}."
        return result
      end
    end

    def citation?
      quote.page.present? &&
      quote.work.citation?
    end
  end
end