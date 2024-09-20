require "test_helper"
require_relative "../../_factories/factory_helper_citations"

class NoteTest < ActiveSupport::TestCase
  include FactoryHelperCitations

  test "book long citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Charles Yu, _Interior Chinatown_ (Pantheon Books, 2020), 45."
    result = Citation::Note.new(fixture_citation_interior_chinatown.quotes.first).long

    assert_equal expected, result
  end

  test "book short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, _Interior Chinatown_, 45."
    result = Citation::Note.new(fixture_citation_interior_chinatown.quotes.first).short

    assert_equal expected, result
  end

  test "book long citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Amy J. Binder and Jeffrey L. Kidder, _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_ (University of Chicago Press, 2022), 117–18."

    result = Citation::Note.new(fixture_citation_channels.quotes.first).long

    assert_equal expected, result
  end

  test "short citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder and Kidder, _Channels of Student Activism_, 117–18."
    result = Citation::Note.new(fixture_citation_channels.quotes.first).short

    assert_equal expected, result
  end

  test "chapter short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Doyle, “Queen Mary Psalter,” 64."
    result = Citation::Note.new(fixture_citation_book_by_design_child.quotes.first).short
    assert_equal expected, result
  end

  test "chapter long citation" do
    # # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Kathleen Doyle, “The Queen Mary Psalter,” in _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, ed. P. J. M. Marks and Stephen Parkin (University of Chicago Press, 2023), 64."

    result = Citation::Note.new(fixture_citation_book_by_design_child.quotes.first).long

    assert_equal expected, result
  end
end
