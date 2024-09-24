module Citation
  module Chicago
    class Note < Citation::Chicago::Base
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
          page = quote.custom_citation.presence || quote.page.presence # String
          "#{author_last_names}, #{italicize(title)}, #{page}."
        elsif work.publishing_format_chapter?
          return unless work.authors.any? && quote.page.present?
  
          author_last_names = work.reference.producer_last_names
          title = work.reference.short_title
          page = quote.custom_citation.presence || quote.page.presence
          result = "#{author_last_names}, #{inverted_commas(title)}, #{page}."
          greedy_quote(result)
        elsif work.publishing_format_ebook?
          author_last_names = work.reference.producer_last_names
          title = work.reference.short_title
          page = quote.custom_citation.presence || quote.page.presence
          result = "#{author_last_names}, #{italicize(title)}, #{page}."
          greedy_quote(result)
        elsif work.publishing_format_journal_article?
          author_last_names = work.reference.producer_last_names
          title = work.reference.short_title
          page = quote.custom_citation.presence || quote.page.presence
          result = "#{author_last_names}, #{inverted_commas(title)}, #{page}."
          greedy_quote(result)
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
  
          result = "#{author_names}, #{inverted_commas(title)}, in #{italicize(parent_title)}, ed. #{editors} (#{parent_publisher_name}, #{parent_year}), #{page}."
          greedy_quote(result)
        elsif work.publishing_format_ebook?
          name_and_role = [
            work.reference.producer_names,
            work.reference.short_producer_roles(true)
          ].map(&:presence).compact.join(", ")
          
          italic_title = "#{italicize(work.reference.long_title)}"
          publishing = "(#{work.publisher.name}, #{work.year_of_publication})"
          title_and_publishing = italic_title + " " + publishing
          page = quote.custom_citation.presence || quote.page.presence
          source = work.digital_source

          result = [
            name_and_role,
            title_and_publishing,
            page,
            source
          ].join(", ").concat(".")
          greedy_quote(result)
        elsif work.publishing_format_journal_article?
          title = work.reference.long_title
          journal = "#{italicize(work.journal_name)} #{work.journal_volume}, no. #{work.journal_issue}"
          page = quote.custom_citation || quote.page
          year = work.year_of_publication

          # REFACTOR
          if work.translators.any?
            translator_names = work.reference.producer_names(:translator)
            strict_author_names = work.reference.alpha_producer_names(:author)

            result = "#{strict_author_names}. #{inverted_commas(title)}. Translated by #{translator_names}. #{journal} (#{year}): #{page}."

            result += " #{work.digital_source}." if work.digital_source.present?

            result = greedy_quote(result)
            result
          else
            strict_author_names = work.reference.alpha_producer_names(:author)

            result = "#{strict_author_names}. #{inverted_commas(title)}. #{journal} (#{year}): #{page}."

            result += " #{work.digital_source}." if work.digital_source.present?

            result = greedy_quote(result)
            result
          end
        else
        end
      end
    end
  end
end
