require "test_helper"
require_relative "../../_factories/factory_helper_citations"

class NoteTest < ActiveSupport::TestCase
  include FactoryHelperCitations

  test "book long citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Charles Yu, _Interior Chinatown_ (Pantheon Books, 2020), 45."
    subject = fixture_citation_interior_chinatown.quotes.first
    result = subject.reference.chicago_note(subject, :long)

    assert_equal expected, result
  end

  test "book short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book
    subject = fixture_citation_interior_chinatown.quotes.first
    expected = "Yu, _Interior Chinatown_, 45."
    result = subject.reference.chicago_note(subject, :short)

    assert_equal expected, result
  end

  test "book long citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Amy J. Binder and Jeffrey L. Kidder, _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_ (University of Chicago Press, 2022), 117–18."
    subject = fixture_citation_channels.quotes.first
    result = subject.reference.chicago_note(subject, :long)

    assert_equal expected, result
  end

  test "short citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder and Kidder, _Channels of Student Activism_, 117–18."
    subject = fixture_citation_channels.quotes.first
    result = subject.reference.chicago_note(subject, :short)

    assert_equal expected, result
  end

  test "chapter short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book
    expected = "Doyle, “Queen Mary Psalter,” 64."
    subject = fixture_citation_book_by_design_child.quotes.first
    result = subject.reference.chicago_note(subject, :short)
    assert_equal expected, result
  end

  test "chapter long citation" do
    # # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Kathleen Doyle, “The Queen Mary Psalter,” in _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, ed. P. J. M. Marks and Stephen Parkin (University of Chicago Press, 2023), 64."

    subject = fixture_citation_book_by_design_child.quotes.first
    result = subject.reference.chicago_note(subject, :long)
    assert_equal expected, result
  end

  test "ebook with url note quote, long" do
    subject = fixture_citation_ebook_url.quotes.first
    expected = "Philip B. Kurland and Ralph Lerner, eds., _The Founders’ Constitution_ (University of Chicago Press, 1987), chap. 10, doc. 19, https://press-pubs.uchicago.edu/founders/."
    result = subject.reference.chicago_note(subject, :long)
    assert_equal expected, result
  end

  test "ebook without url note quote, long" do
    subject = fixture_citation_ebook_no_url.quotes.first
    expected = "Arundhati Roy, _The God of Small Things_ (Random House, 2008), chap. 6, Kindle."
    result = subject.reference.chicago_note(subject, :long)
    assert_equal expected, result
  end

  test "ebook with url note quote, short" do
    subject = fixture_citation_ebook_url.quotes.first
    expected = "Kurland and Lerner, _Founders’ Constitution_, chap. 10, doc. 19."
    result = subject.reference.chicago_note(subject, :short)
    assert_equal expected, result
  end

  test "ebook without url note quote, short" do
    subject = fixture_citation_ebook_no_url.quotes.first
    expected = "Roy, _God of Small Things_, chap. 6."
    result = subject.reference.chicago_note(subject, :short)
    assert_equal expected, result
  end
end
