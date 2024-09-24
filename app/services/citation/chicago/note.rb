module Citation
  module Chicago
    class Note
      attr_reader :quote, :work
  
      def initialize(work, quote)
        @work = work
        @quote = quote
      end
  
      def short
        if work.publishing_format_book?
          return unless work.authors.any? && quote.page.present?
  
          author_last_names = work.reference.producer_last_names
          title = work.reference.short_title
          page = quote.page # String
          "#{author_last_names}, _#{title}_, #{page}."
        elsif work.publishing_format_chapter?
          return unless work.authors.any? && quote.page.present?
  
          author_last_names = work.reference.producer_last_names
          title = work.reference.short_title
          page = quote.page
          "#{author_last_names}, “#{title},” #{page}."
        end
      end
  
      def long
        if work.publishing_format_book?
          return unless work&.authors&.any? && work.year_of_publication && quote.page
  
          author_names = work.reference.producer_names
          title = work.reference.long_title
          page = quote.page
  
          publisher = work.publisher.name
          year = work.year_of_publication
          result = "#{author_names}, _#{title}_ (#{publisher}, #{year}), #{page}."
          return result
        elsif work.publishing_format_chapter?
          return unless work.authors.any? && work.parent && work.parent&.editors&.any? && work.parent&.publisher && work.parent&.year_of_publication && quote.page
  
          author_names = work.reference.producer_names
  
          title = work.reference.long_title
          parent_title = work.parent.reference.long_title
  
          editors = work.parent.reference.producer_names(:editor)
          parent_publisher_name = work.parent.publisher.name
          parent_year = work.parent.year_of_publication
          page = quote.custom_citation.presence || quote.page.presence
  
          result = "#{author_names}, “#{title},” in _#{parent_title}_, ed. #{editors} (#{parent_publisher_name}, #{parent_year}), #{page}."
          return result
        elsif work.publishing_format_ebook?
          name_and_role = [
            work.reference.producer_names,
            work.reference.short_producer_roles(true)
          ].map(&:presence).compact.join(", ")
          
          italic_title = "_#{work.reference.long_title}_"
          publishing = "(#{work.publisher.name}, #{work.year_of_publication})"
          title_and_publishing = italic_title + " " + publishing
          page = quote.custom_citation.presence || quote.page.presence
          result = [
            name_and_role,
            title_and_publishing,
            page,
            work.ebook_source
          ].join(", ").concat(".")
          return result
        else
        end
      end
    end
  end
end
