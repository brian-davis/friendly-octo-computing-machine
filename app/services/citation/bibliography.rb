module Citation
  class Bibliography < Citation::Base
    def entry
      if work.children.any? && work.editors.any?
        return unless work.publisher && work.year_of_publication

        editor_names = producer_names(:editors)

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
          translator_names = producer_names(:translators)

          "#{alpha_producer_names}. _#{title}_. Translated by #{translator_names}. #{publisher}, #{year}."
        else
          "#{alpha_producer_names}. _#{title}_. #{publisher}, #{year}."
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
  end
end