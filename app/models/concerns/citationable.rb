module Citationable
  extend ActiveSupport::Concern

  included do

    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-chapter
    def bibliography_markdown
      return unless self.is_a?(Work)
      sections = []

      author_names = authors.pluck(:name) # order by WorkProducer create
      first_author = author_names.shift

      _split = first_author.split(/\s/)
      last_name = _split.pop
      rest = _split.join(" ") # "Amy J."
      reversed_first_author = [last_name, rest].join(", ")

      author_names.unshift(reversed_first_author)
      formatted_authors = author_names.to_sentence

      # first "and" needs a comma too
      formatted_authors.sub!(" and", ", and")

      sections << formatted_authors

      if self.translators.any?
        formatted_translators = "Translated by #{self.translators.pluck(:name).to_sentence}"
        sections << formatted_translators
      end

      if self.format == "book"
        formatted_title = "_#{self.title_and_subtitle}_"
        sections << formatted_title

        formatted_publishing = "#{self.publisher.name}, #{self.year_of_publication}"
        sections << formatted_publishing

        "#{sections.join(". ")}."
      elsif self.format == "chapter"
        self_title = self.title_and_subtitle
        parent_title = parent.title_and_subtitle
        formatted_title = "“#{self_title}.” In _#{parent_title}_"
        editor_names = parent.editors.pluck(:name).to_sentence
        formatted_title += ", edited by #{editor_names}"

        sections << formatted_title

        formatted_publishing = "#{parent.publisher.name}, #{parent.year_of_publication}"
        sections << formatted_publishing

        "#{sections.join(". ")}."
      end
    end

    # Charles Yu, _Interior Chinatown_ (Pantheon Books, 2020), 45.
    def long_citation_markdown
      if work.book?
        author_names = work.authors.pluck(:name).to_sentence # no alphabetizing by last name
        title_and_publication = "_#{}_ ()" # no comma
        result = "#{author_names}, _#{work.title_and_subtitle}_ (#{work.publisher.name}, #{work.year_of_publication}), #{self.page}."
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
        sections = []

        author_last_names = work.authors.pluck(:name).map { |name| name.split(/\s/).last }.to_sentence
        sections << author_last_names

        short_title = work.title.sub("The ", "")
        title = "_#{short_title}_"
        sections << title

        page = self.page # String
        sections << page

        result = sections.join(", ") + "."
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
          producers.any? &&
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