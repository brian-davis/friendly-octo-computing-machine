module Citation
  class Note < Citation::Base
    attr_reader :quote
    attr_reader :work

    def initialize(quote)
      @quote = quote
      @work = @quote.work
    end

    def short
      if work.publishing_format_book?
        return unless work.authors.any? && quote.page.present?

        author_last_names = Citation::Base.new(work).producer_last_names
        title = work.reference.short_title
        page = quote.page # String
        "#{author_last_names}, _#{title}_, #{page}."
      elsif work.publishing_format_chapter?
        return unless work.authors.any? && quote.page.present?

        author_last_names = Citation::Base.new(work).producer_last_names
        title = work.reference.short_title
        page = quote.page
        "#{author_last_names}, “#{title},” #{page}."
      end
    end

    def long
      if work.publishing_format_book?
        return unless work&.authors&.any? && work.year_of_publication && quote.page

        author_names = producer_names
        title = work.reference.long_title
        page = quote.page

        publisher = work.publisher.name
        year = work.year_of_publication
        result = "#{author_names}, _#{title}_ (#{publisher}, #{year}), #{page}."
        return result
      elsif work.publishing_format_chapter?
        return unless work.authors.any? && work.parent && work.parent&.editors&.any? && work.parent&.publisher && work.parent&.year_of_publication && quote.page

        author_names = producer_names

        title = work.reference.long_title
        parent_title = work.parent.reference.long_title

        editors = Citation::Base.new(work.parent).producer_names(:editor)
        parent_publisher_name = work.parent.publisher.name
        parent_year = work.parent.year_of_publication
        page = quote.page

        result = "#{author_names}, “#{title},” in _#{parent_title}_, ed. #{editors} (#{parent_publisher_name}, #{parent_year}), #{page}."
        return result
      end
    end
  end
end
