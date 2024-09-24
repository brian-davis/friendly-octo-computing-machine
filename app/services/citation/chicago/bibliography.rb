module Citation
  module Chicago
    class Bibliography
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
    
            return "#{editor_names}, #{editor_status}, _#{title}_ (#{publisher}, #{year})."
          else
            return unless work.producers.any? && work.publisher && work.year_of_publication
  
            title = work.reference.long_title
            publisher = work.publisher.name
            year = work.year_of_publication
    
            if work.translators.any?
              translator_names = work.reference.producer_names(:translator)
              strict_author_names = work.reference.alpha_producer_names(:author)
              "#{strict_author_names}. _#{title}_. Translated by #{translator_names}. #{publisher}, #{year}."
            else
              strict_author_names = work.reference.alpha_producer_names(:author)
              "#{strict_author_names}. _#{title}_. #{publisher}, #{year}."
            end
          end
        elsif work.publishing_format_chapter?
          return unless work.producers.any? && work.reference.year_of_publication
          
          title = work.reference.long_title
          
          parent_editor_names = work.parent.reference.producer_names(:editors)
          
          parent_title = work.parent.reference.long_title
          parent_publisher = work.parent.publisher.name
          parent_year = work.parent.year_of_publication
          
          if work.translators.any?
            translator_names = work.reference.producer_names(:translators)
            strict_author_names = work.reference.alpha_producer_names(:author)
            "#{strict_author_names}. “#{title}.” Translated by #{translator_names}. In _#{parent_title}_, edited by #{parent_editor_names}. #{parent_publisher}, #{parent_year}."
          else
            "#{work.reference.alpha_producer_names}. “#{title}.” In _#{parent_title}_, edited by #{parent_editor_names}. #{parent_publisher}, #{parent_year}."
          end
        elsif work.publishing_format_ebook?
          name_and_role = [
            work.reference.alpha_producer_names,
            work.reference.short_producer_roles
          ].map(&:presence).compact.join(", ")
          
          italic_title = "_#{work.reference.long_title}_"
          publishing = "#{work.publisher.name}, #{work.year_of_publication}"
          result = [
            name_and_role,
            italic_title,
            publishing,
            work.ebook_source
          ].join(". ").concat(".")
          return result
        else
          ""
        end
      end
    end
  end
end