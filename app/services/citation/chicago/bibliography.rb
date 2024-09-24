module Citation
  module Chicago
    class Bibliography < Citation::Chicago::Base
      attr_reader :work

      def initialize(work)
        @work = work
      end

      def entry
        if work.publishing_format_book?
          if work.children.any? && work.editors.any?
            return unless work.publisher && work.year_of_publication
    
            editor_names = work.reference.producer_names(:editor)
    
            editor_status = work.editors.count > 1 ? "eds." : "ed."
            title = work.reference.long_title
            publisher = work.publisher.name
            year = work.year_of_publication
    
            result = "#{editor_names}, #{editor_status}, #{italicize(title)} (#{publisher}, #{year})."
            greedy_quote(result)
          else
            return unless work.producers.any? && work.publisher && work.year_of_publication
  
            title = work.reference.long_title
            publisher = work.publisher.name
            year = work.year_of_publication
    
            result = if work.translators.any?
              translator_names = work.reference.producer_names(:translator)
              strict_author_names = work.reference.alpha_producer_names(:author)
              "#{strict_author_names}. #{italicize(title)}. Translated by #{translator_names}. #{publisher}, #{year}."
            else
              strict_author_names = work.reference.alpha_producer_names(:author)
              "#{strict_author_names}. #{italicize(title)}. #{publisher}, #{year}."
            end

            greedy_quote(result)
          end
        elsif work.publishing_format_chapter?
          return unless work.producers.any? && work.reference.year_of_publication
          
          title = work.reference.long_title
          
          parent_editor_names = work.parent.reference.producer_names(:editors)
          
          parent_title = work.parent.reference.long_title
          parent_publisher = work.parent.publisher.name
          parent_year = work.parent.year_of_publication
          
          result = if work.translators.any?
            translator_names = work.reference.producer_names(:translators)
            strict_author_names = work.reference.alpha_producer_names(:author)
            "#{strict_author_names}. #{inverted_commas(title)}. Translated by #{translator_names}. In #{italicize(parent_title)}, edited by #{parent_editor_names}. #{parent_publisher}, #{parent_year}."
          else
            "#{work.reference.alpha_producer_names}. #{inverted_commas(title)}. In #{italicize(parent_title)}, edited by #{parent_editor_names}. #{parent_publisher}, #{parent_year}."
          end

          greedy_quote(result)
        elsif work.publishing_format_ebook?
          name_and_role = [
            work.reference.alpha_producer_names,
            work.reference.short_producer_roles
          ].map(&:presence).compact.join(", ")
          
          italic_title = italicize(work.reference.long_title)
          publishing = "#{work.publisher.name}, #{work.year_of_publication}"
          source = work.digital_source

          result = [
            name_and_role,
            italic_title,
            publishing,
            source
          ].join(". ").concat(".")
          return result
        elsif work.publishing_format_journal_article?

          translator_names = work.reference.producer_names(:translator)
          strict_author_names = work.reference.alpha_producer_names(:author)

          result = ""
          result << strict_author_names
          result << ". "
          result << "#{inverted_commas(work.reference.long_title)}. " # TODO: use inverted-commas helper
          result << ". Translated by #{translator_names}. " if translator_names.present?
          result << "#{italicize(work.journal_name)} " # TODO: use Publisher model?  self join for the whole journal issue?
          result << "#{work.journal_volume}, no. #{work.journal_issue} (#{work.year_of_publication}): #{work.journal_page_span}."
          result << " #{work.digital_source}." if work.digital_source.present?

          result = greedy_quote(result)
          result
        else
          ""
        end
      end
    end
  end
end