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
        (
          reference.work.publishing_format_news_article? ||
          reference.work.publishing_format_book_review? ||
          reference.work.publishing_format_interview? ||
          reference.work.publishing_format_web_page? ||
          reference.work.publishing_format_social_media? ||
          reference.work.publishing_format_video? ||
          reference.work.publishing_format_personal? ||
          quote.citation_page.present?
        ) # REFACTOR
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

      def news_article_long
        strict_author_names = reference.producer_names(:author)
        title = prep_title(reference.long_title, :quotes)      
        news = prep_title(work.journal_name, :italics)
        date = prep_date(work.article_date)
        source = work.digital_source

        parts = [
          strict_author_names,
          title,
          translated_by, # base
          news,
          date,
          source
        ].compact

        build_from_parts(parts, :comma)
      end

      def book_review_long
        strict_author_names = reference.producer_names(:author)
        title = prep_title(reference.long_title, :quotes)

        # REFACTOR: review_title, review_author is hacky.
        review_subreference = "review of #{prep_title(work.review_title, :italics)}, by #{work.review_author}"

        news = prep_title(work.journal_name, :italics)
        date = prep_date(work.article_date)
        source = work.digital_source

        parts = [
          strict_author_names,
          title,
          review_subreference,
          translated_by, # base
          news,
          date,
          source
        ].compact

        build_from_parts(parts, :comma)
      end

      def interview_long
        strict_author_names = reference.producer_names(:author)
        title = prep_title(reference.long_title, :quotes)

        # REFACTOR: interviewer_name, media_source, online_source is hacky.
        interview_subreference = "interview by #{work.interviewer_name}"
        interview_show = prep_title(work.media_source, :italics)
        interview_source = work.online_source
        date = prep_date(work.media_date)
        _format = work.media_format.downcase
        timestamp = work.media_timestamp 
        url = work.url.presence

        parts = [
          strict_author_names,
          title,
          interview_subreference,
          interview_show,
          interview_source,
          translated_by, # base
          date,
          _format,
          timestamp,
          url
        ].compact

        build_from_parts(parts, :comma)
      end

      def thesis_long
        strict_author_names = reference.producer_names(:author)
        
        # REFACTOR, hacky
        _format = "#{prep_title(reference.long_title, :quotes)} (#{work.media_format}, #{work.journal_name}, #{work.year_of_publication})"
        page = quote.citation_page # page
        source = work.online_source

        parts = [
          strict_author_names,
          translated_by, # base
          _format,
          page,
          source
        ].compact

        build_from_parts(parts, :comma)
      end

      def web_page_long
        title = prep_title(reference.long_title, :quotes)
        _date = "accessed #{prep_date(work.media_date)}"

        parts = [
          title,
          work.media_source, # REFACTOR, hacky
          _date,
          work.url
        ].compact

        build_from_parts(parts, :comma)
      end

      def social_media_long
        strict_author_names = reference.producer_names(:author)
        _title = prep_title(reference.long_title, :quotes)
        
        parts = [
          strict_author_names, # REFACTOR, hacky
          _title,
          work.media_source, # REFACTOR, hacky
          prep_date(work.media_date),
          work.url
        ].compact

        build_from_parts(parts, :comma)
      end

      def video_long
        strict_author_names = reference.producer_names(:author)
        _title = prep_title(reference.long_title, :quotes)
        
        parts = [
          strict_author_names, # REFACTOR, hacky
          _title,
          work.media_source, # REFACTOR, hacky
          work.media_timestamp,
          work.url
        ].compact

        build_from_parts(parts, :comma)
      end

      def personal_long
        strict_author_names = reference.producer_names(:author)
        _title = work.title # not prep, Refactor: hacky
        _date = prep_date(work.media_date) # hacky
   
        parts = [
          strict_author_names, # REFACTOR, hacky
          _title,
          _date
        ].compact

        build_from_parts(parts, :comma)
      end
    end
  end
end
