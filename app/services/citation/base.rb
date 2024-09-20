# Builds citations for Chicago Style, as in:   # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book
module Citation
  # TODO: deprecate?
  class Base
    attr_reader :work

    def initialize(work)
      @work = work
    end

  protected

  end
end