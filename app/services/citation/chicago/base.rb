module Citation
  module Chicago
    class Base
      attr_reader :work, :reference

      def initialize(work)
        @work = work
        @reference = @work.reference
      end

      private

      def prep_title(str, format = :italics)
        case format
        when :italics, :italic
          "_#{str}_"
        when :inverted_commas, :inverted_comma, :quotes, :quote
          "“#{str}”"
        else
          str
        end
      end

      def translated_by
        names = reference.producer_names(:translator)
        "Translated by #{names}" if names.present?
      end

      def publishing(parent: false)
        if parent
          publisher = work.parent.reference.publisher_name
          year = work.parent.reference.year_of_publication
        else
          publisher = reference.publisher_name
          year = reference.year_of_publication
        end
        publishing = "#{publisher}, #{year}"
      end

      def title_and_publishing
        title = prep_title(reference.long_title, :italics)
        "#{title} (#{publishing})"
      end

      def journal_subreference(page)
        title = prep_title(work.journal_name, :italics)
        vol = work.journal_volume
        jno = jno = "no. #{ work.journal_issue }"
        year = "(#{reference.year_of_publication })"

        "#{title} #{vol}, #{jno} #{year}: #{page}"
      end

      def build_from_parts(parts, separator = :comma)
        joiner = {
          comma: ", ",
          period: ". "
        }[separator]
        parts
          .join(joiner)
          .concat(".")
          .gsub("”.", ".”")
          .gsub("”,", ",”")
          .gsub("..", ".") # paranoid
          .gsub(",,", ",") # paranoid
      end

      def prep_date(date)
        date.strftime("%B %-d, %Y")
      end
    end
  end
end