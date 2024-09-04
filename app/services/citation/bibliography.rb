module Citation
  class Bibliography < Citation::Base
    attr_reader :work

    def initialize(work)
      @work = work
    end

    def entry
      if work.children.any? && work.editors.any?
        return unless work.publisher && work.year_of_publication

        editor_names = producer_names(work, :editors).to_sentence

        editor_status = work.editors.count > 1 ? "eds." : "ed."
        title = long_title(work)
        publisher = work.publisher.name
        year = work.year_of_publication

        "#{editor_names}, #{editor_status}, _#{title}_ (#{publisher}, #{year})."
      elsif work.book?
        return unless work.authors.any? && work.publisher && work.year_of_publication

        author_names = alpha_producer_names(work)

        title = long_title(work)
        publisher = work.publisher.name
        year = work.year_of_publication

        if work.translators.any?
          translator_names = producer_names(work, :translators).to_sentence

          "#{author_names}. _#{title}_. Translated by #{translator_names}. #{publisher}, #{year}."
        else
          "#{author_names}. _#{title}_. #{publisher}, #{year}."
        end

      elsif work.chapter?
        return unless work.authors.any? && work.parent.publisher && work.parent.year_of_publication

        author_names = alpha_producer_names(work)

        title = long_title(work)

        parent_editor_names = producer_names(work.parent, :editors).to_sentence

        parent_title = long_title(work.parent)
        parent_publisher = work.parent.publisher.name
        parent_year = work.parent.year_of_publication

        if work.translators.any?
          translator_names = producer_names(work, :translators).to_sentence

          "#{formatted_authors}. “#{title}.” Translated by #{translator_names}. In _#{parent_title}_, edited by #{parent_editors}. #{parent_publisher}, #{parent_year}."
        else
          "#{author_names}. “#{title}.” In _#{parent_title}_, edited by #{parent_editor_names}. #{parent_publisher}, #{parent_year}."
        end
      else
        # TODO
        ""
      end
    end
  end
end