require "test_helper"
require_relative "../../_factories/factory_helper_citations"

class BibliographyTest < ActiveSupport::TestCase
  include FactoryHelperCitations  

  test "book bibliography entry" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, Charles. _Interior Chinatown_. Pantheon Books, 2020."
    result = Citation::Bibliography.new(fixture_citation_interior_chinatown).entry
    assert_equal expected, result
  end

  test "book bibliography entry multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder, Amy J., and Jeffrey L. Kidder. _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_. University of Chicago Press, 2022."

    result = Citation::Bibliography.new(fixture_citation_channels).entry

    assert_equal expected, result
  end

  test "book with translator bibliography" do
    expected = "Smith, John. _The Wedding Party_. Translated by Jeremy Tiang. Amazon Crossing, 2021."
    result = Citation::Bibliography.new(fixture_citation_wedding_party).entry

    assert_equal(expected, result)
  end

  test "chapter bibliography" do
    expected = "Doyle, Kathleen. “The Queen Mary Psalter.” In _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, edited by P. J. M. Marks and Stephen Parkin. University of Chicago Press, 2023."

    result = Citation::Bibliography.new(fixture_citation_book_by_design_child).entry

    assert_equal expected, result
  end

  test "chapter bibliography for parent work with 2 translators" do
    antigone = fixture_works_antigone
    
    # confusing, close enough for government work? TODO: look this up with real library cataloging standards.
    expected = "Sophocles. “Antigone.” Translated by Peter Meineck and Paul Woodruff. In _Theban Plays_, edited by Peter Meineck and Paul Woodruff. Hacket Publishing Company, Inc., 2003."

    result = Citation::Bibliography.new(antigone).entry

    assert_equal expected, result
  end

  test "compilation bibiography" do
    expected = "P. J. M. Marks and Stephen Parkin, eds., _The Book by Design: The Remarkable Story of the World’s Greatest Invention_ (University of Chicago Press, 2023)."

    result = Citation::Bibliography.new(fixture_citation_book_by_design).entry

    assert_equal expected, result
  end
end