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
          translator_names = reference.producer_names(:translator)
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

        journal = journal_subreference(work.journal_page_span)
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
    end
  end
end