module Citationable
  extend ActiveSupport::Concern

  included do
    private def alpha_author_names
      author_names = authors.pluck(:name) # order by WorkProducer create
      first_author = author_names.shift
      _split = first_author.split(/\s/)
      last_name = _split.pop
      rest = _split.join(" ") # "Amy J."
      reversed_first_author = [last_name, rest].map(&:presence).compact.join(", ")
      author_names.unshift(reversed_first_author)
      formatted_authors = author_names.to_sentence
      # first "and" needs a comma too
      formatted_authors.sub!(" and", ", and")
      return formatted_authors
    end

    def bibliography_markdown
      return unless self.is_a?(Work)

      if self.compilation?
        editor_names = self.editors.pluck(:name).to_sentence
        editor_status = self.editors.count > 1 ? "eds." : "ed."
        title = self.title_and_subtitle
        publisher = self.publisher.name
        year = self.year_of_publication
        result = "#{editor_names}, #{editor_status}, _#{title}_ (#{publisher}, #{year})."
        return result
      elsif self.book?
        formatted_authors = self.alpha_author_names

        title = self.title_and_subtitle
        publisher = self.publisher.name
        year = self.year_of_publication

        result = if self.translators.any?
          translator_names = self.translators.pluck(:name).to_sentence
          "#{formatted_authors}. _#{title}_. Translated by #{translator_names}. #{publisher}, #{year}."
        else
          "#{formatted_authors}. _#{title}_. #{publisher}, #{year}."
        end
        return result
      elsif self.chapter?
        formatted_authors = self.alpha_author_names
        title = self.title_and_subtitle

        parent_year = self.parent.year_of_publication
        parent_title = self.parent.title_and_subtitle
        parent_editors = self.parent.editors.pluck(:name).to_sentence
        parent_publisher = self.parent.publisher.name

        result = if self.translators.any?
          translator_names = self.translators.pluck(:name).to_sentence

          "#{formatted_authors}. “#{title}.” Translated by #{translator_names}. In _#{parent_title}_, edited by #{parent_editors}. #{parent_publisher}, #{parent_year}."
        else
          "#{formatted_authors}. “#{title}.” In _#{parent_title}_, edited by #{parent_editors}. #{parent_publisher}, #{parent_year}."
        end

        return result
      end
    end

    # Charles Yu, _Interior Chinatown_ (Pantheon Books, 2020), 45.
    def long_citation_markdown
      if work.book?
        author_names = work.authors.pluck(:name).to_sentence
        work_title = work.title_and_subtitle
        publisher = work.publisher.name
        year = work.year_of_publication
        result = "#{author_names}, _#{work_title}_ (#{publisher}, #{year}), #{self.page}."
        return result
      elsif work.chapter?
        author_names = work.authors.pluck(:name).to_sentence # no alphabetizing by last name
        work_title = work.title_and_subtitle
        parent_title = work.parent.title_and_subtitle
        editors = work.parent.editors.pluck(:name).to_sentence

        result = "#{author_names}, “#{work_title},” in _#{parent_title}_, ed. #{editors} (#{work.parent.publisher.name}, #{work.parent.year_of_publication}), #{self.page}."
        return result
      end
    rescue => e
      Rails.logger.error { e.message }
      Rails.logger.debug { e.backtrace }
      return ""
    end

    # "Yu, _Interior Chinatown_, 48."
    def short_citation_markdown
      if work.book?
        author_last_names = work.authors.pluck(:name).map { |name| name.split(/\s/).last }.to_sentence
        short_title = work.title.sub("The ", "")
        page = self.page # String
        result = "#{author_last_names}, _#{short_title}_, #{page}."
        return result
      elsif work.chapter?
        author_last_names = work.authors.pluck(:name).map { |name| name.split(/\s/).last }.to_sentence # no alphabetizing by last name
        short_title = work.title.sub("The ", "")
        result = "#{author_last_names}, “#{short_title},” #{self.page}."
        return result
      end
    rescue => e
      Rails.logger.error { e.message }
      Rails.logger.debug { e.backtrace }
      return ""
    end

    def title_and_subtitle
      return unless self.is_a?(Work)
      [self.title, self.subtitle].map(&:presence).compact.join(": ")
    end

    # guard rendering view
    def citation?
      case self
      when Work
        if book?
          publisher &&
          authors.any? &&
          year_of_publication.present?
        elsif compilation?
          publisher &&
          editors.any? &&
          year_of_publication.present?
        elsif chapter?
          producers.any? &&
          parent &&
          parent.publisher &&
          parent.producers.any? &&
          parent.year_of_publication.present?
        end
      when Quote
        self.page.present? &&
        self.work.citation?
      end
    end
  end

  class_methods do
    # methods that you want to create as
    # class methods on the including class
  end
end