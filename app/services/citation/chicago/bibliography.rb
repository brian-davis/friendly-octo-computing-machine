module Citation
  module Chicago
    class Bibliography < Citation::Chicago::Base
      attr_reader :work, :reference

      def entry
        return unless reference.complete_data?
        helper = "#{work.publishing_format}_entry"
        send(helper) if respond_to?(helper, true) # NotImplemented
      end

      private

      def book_entry
        if reference.compilation?
          editor_names = reference.producer_names(:editor)
          editor_status = reference.short_producer_roles(true) # "eds."
          parts = [
            editor_names,
            editor_status,
            title_and_publishing # base
          ]
          build_from_parts(parts)
        else
          strict_author_names = reference.alpha_producer_names(:author)
          title = prep_title(reference.long_title, :italics)

          parts = [
            strict_author_names,
            title,
            translated_by, # base
            publishing # base
          ].compact # optional translation
          build_from_parts(parts, :period)
        end
      end

      def chapter_entry
        title = prep_title(reference.long_title, :quotes)

        strict_author_names = reference.alpha_producer_names(:author)

        parent_ref = "In #{prep_title(work.parent.reference.long_title, :italics)}, edited by #{work.parent.reference.producer_names(:editors)}"
        
        _publishing = publishing(parent: true)

        parts = [
          strict_author_names,
          title,
          translated_by, # base
          parent_ref,
          _publishing
        ].compact # optional translation
        build_from_parts(parts, :period)
      end

      def ebook_entry
        # with translation?

        name_and_role = [
          reference.alpha_producer_names,
          reference.short_producer_roles # ed
        ].map(&:presence).compact.join(", ")
        
        title = prep_title(reference.long_title, :italics)

        source = work.digital_source

        parts = [
          name_and_role,
          title,
          publishing, # base
          source
        ]

        build_from_parts(parts, :period)
      end

      def journal_article_entry
        strict_author_names = reference.alpha_producer_names(:author)
        title = prep_title(reference.long_title, :quotes)
        journal = journal_subreference(work.article_page_span)
        source = work.digital_source
        parts = [
          strict_author_names,
          title,
          translated_by, # base
          journal,
          source
        ].compact # optional translation
        build_from_parts(parts, :period)
      end

      def news_article_entry
        strict_author_names = reference.alpha_producer_names(:author)
        title = prep_title(reference.long_title, :quotes)
        journal = prep_title(work.journal_name, :italics) # TODO: rename?
        date = prep_date(work.article_date)
        journal_source = "#{journal}, #{date}"

        source = work.digital_source
        parts = [
          strict_author_names,
          title,
          journal_source,
          source
        ].compact # optional source
        build_from_parts(parts, :period)
      end

      def book_review_entry
        strict_author_names = reference.alpha_producer_names(:author)
        title = prep_title(reference.long_title, :quotes)
        journal = prep_title(work.journal_name, :italics) # TODO: rename?
        date = prep_date(work.article_date)
        journal_source = "#{journal}, #{date}"
        review_subreference = "Review of #{prep_title(work.review_title, :italics)}, by #{work.review_author}"
        source = work.digital_source
        parts = [
          strict_author_names,
          title,
          review_subreference,
          journal_source,
          source
        ].compact # optional source
        build_from_parts(parts, :period)
      end

      def interview_entry
        strict_author_names = reference.alpha_producer_names(:author)
        title = prep_title(reference.long_title, :quotes)
        
        interviewer = "Interview by #{work.interviewer_name}"
        interview_subreference = "#{prep_title(work.media_source, :italics)}, #{work.online_source}, #{prep_date(work.media_date)}"
        interview_format_time = "#{work.media_format}, #{work.media_timestamp}"
        source = work.digital_source # url

        parts = [
          strict_author_names,
          title,
          interviewer,
          interview_subreference,
          interview_format_time,
          source
        ].compact # optional source
        build_from_parts(parts, :period)
      end

      def thesis_entry
        strict_author_names = reference.alpha_producer_names(:author)
        title = "#{prep_title(reference.long_title, :quotes)}"
        journal_name = "#{work.media_format}, #{work.journal_name}, #{work.year_of_publication}"
        source = work.digital_source # online_source

        parts = [
          strict_author_names,
          title,
          journal_name,
          
          source
        ].compact # optional source
        build_from_parts(parts, :period)
      end

      def web_page_entry
        title = "#{prep_title(reference.long_title, :quotes)}"
        accessed_at = "Accessed #{prep_date(work.media_date)}"
        source = work.digital_source # url
        parts = [
          work.media_source,
          title,
          accessed_at,       
          source
        ].compact # optional source
        build_from_parts(parts, :period)
      end

      def social_media_entry
        account = reference.alpha_producer_names(:author)
        title = "#{prep_title(reference.long_title, :quotes)}"
        accessed_at = "#{work.media_source}, #{prep_date(work.media_date)}"
        source = work.digital_source # url
        parts = [
          account,
          title,
          accessed_at,       
          source
        ].compact # optional source
        build_from_parts(parts, :period)
      end

      def video_entry
        strict_author_names = reference.alpha_producer_names(:author)
        title = "#{prep_title(reference.long_title, :quotes)}"
        media_subreference = work.media_source # hack, TODO
        _format = "#{work.media_format}, #{work.media_timestamp}"
        source = work.digital_source # url

        parts = [
          strict_author_names,
          title,
          media_subreference,
          _format,
          source
        ].compact # optional source
        build_from_parts(parts, :period)
      end

      def personal_entry
      end
    end
  end
end