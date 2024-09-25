module Citation
  module Chicago
    class Note < Citation::Chicago::Base
      attr_reader :quote
  
      def initialize(work, quote)
        @quote = quote
        super(work)
      end

      private def guard_citation
        reference.complete_data? &&
        quote.citation_page.present?
      end

      def short
        return unless guard_citation
        case work.publishing_format
        when "book", "ebook"
          names = reference.producer_last_names
          title = prep_title(reference.short_title, :italics)
          page = quote.citation_page
          parts = [names, title, page]
          build_from_parts(parts, :comma)
        when "chapter", "journal_article"
          names = reference.producer_last_names
          title = prep_title(reference.short_title, :quotes)
          page = quote.citation_page
          parts = [names, title, page]
          build_from_parts(parts, :comma)
        end
      end
  
      def long
        return unless guard_citation
        helper = "#{work.publishing_format}_long"
        send(helper) if respond_to?(helper, true) # NotImplemented
      end

      private

      def book_long
        # TODO: use everywhere?
        name_and_role = [
          reference.producer_names,
          reference.short_producer_roles(true)
        ].map(&:presence).compact.join(", ")

        page = quote.citation_page

        parts = [
          name_and_role,
          title_and_publishing, # base
          page
        ]
        build_from_parts(parts, :comma)
      end

      def chapter_long
        author_names = reference.producer_names
        title = prep_title(reference.long_title, :quotes)
        parent_title = prep_title(work.parent.reference.long_title, :italics)
        editors = work.parent.reference.producer_names(:editor)
        parent_publisher_name = work.parent.publisher.name
        parent_year = work.parent.year_of_publication
        
        # REFACTOR
        parent_subreference = "in #{parent_title}, ed. #{editors} (#{publishing(parent: true)})"
        
        page = quote.citation_page
        parts = [
          author_names,
          title,
          parent_subreference,
          page
        ]

        build_from_parts(parts, :comma)
      end

      def ebook_long
        # TODO: use everywhere?
        name_and_role = [
          reference.producer_names,
          reference.short_producer_roles(true)
        ].map(&:presence).compact.join(", ")
        page = quote.citation_page
        source = work.digital_source
        parts = [
          name_and_role,
          title_and_publishing, # base
          page,
          source
        ]
        build_from_parts(parts, :comma)
      end

      def journal_article_long
        title = prep_title(reference.long_title, :quotes)      
        journal = journal_subreference(quote.citation_page)

        strict_author_names = reference.alpha_producer_names(:author)
        source = work.digital_source

        parts = [
          strict_author_names,
          title,
          translated_by, # base
          journal,
          source
        ].compact

        build_from_parts(parts, :period)
      end
    end
  end
end
