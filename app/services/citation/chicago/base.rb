module Citation
  module Chicago
    class Base

      private

      # punctuation goes inside closing quotation mark
      def greedy_quote(str)
        str.gsub("”.", ".”").gsub("”,", ",”")
      end

      # for markdown parser
      alias_method :italicise, def italicize(str)
        "_#{str}_"
      end

      # special character quotation marks, not ""
      def inverted_commas(str)
        "“#{str}”"
      end
    end
  end
end