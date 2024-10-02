require "test_helper"
require_relative "../../_factories/factory_helper_citations"

class NoteTest < ActiveSupport::TestCase
  include FactoryHelperCitations

  test "book long citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Charles Yu, _Interior Chinatown_ (Pantheon Books, 2020), 45."
    subject = fixture_citation_interior_chinatown.quotes.first
    result = subject.reference.chicago_note(:long)

    assert_equal expected, result
  end

  test "book short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book
    subject = fixture_citation_interior_chinatown.quotes.first
    expected = "Yu, _Interior Chinatown_, 45."
    result = subject.reference.chicago_note(:short)

    assert_equal expected, result
  end

  test "book long citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Amy J. Binder and Jeffrey L. Kidder, _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_ (University of Chicago Press, 2022), 117–18."
    subject = fixture_citation_channels.quotes.first
    result = subject.reference.chicago_note(:long)

    assert_equal expected, result
  end

  test "short citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder and Kidder, _Channels of Student Activism_, 117–18."
    subject = fixture_citation_channels.quotes.first
    result = subject.reference.chicago_note(:short)

    assert_equal expected, result
  end

  test "chapter short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book
    expected = "Doyle, “Queen Mary Psalter,” 64."
    subject = fixture_citation_book_by_design_child.quotes.first
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "chapter long citation" do
    # # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Kathleen Doyle, “The Queen Mary Psalter,” in _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, ed. P. J. M. Marks and Stephen Parkin (University of Chicago Press, 2023), 64."

    subject = fixture_citation_book_by_design_child.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "ebook with url note quote, long" do
    subject = fixture_citation_ebook_url.quotes.first
    expected = "Philip B. Kurland and Ralph Lerner, eds., _The Founders’ Constitution_ (University of Chicago Press, 1987), chap. 10, doc. 19, https://press-pubs.uchicago.edu/founders/."
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "ebook without url note quote, long" do
    subject = fixture_citation_ebook_no_url.quotes.first
    expected = "Arundhati Roy, _The God of Small Things_ (Random House, 2008), chap. 6, Kindle."
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "ebook with url note quote, short" do
    subject = fixture_citation_ebook_url.quotes.first
    expected = "Kurland and Lerner, _Founders’ Constitution_, chap. 10, doc. 19."
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "ebook without url note quote, short" do
    subject = fixture_citation_ebook_no_url.quotes.first
    expected = "Roy, _God of Small Things_, chap. 6."
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "journal article with url note quote, long" do
    subject = fixture_citation_journal1.quotes.first
    expected = "Dittmar, Emily L., and Douglas W. Schemske. “Temporal Variation in Selection Influences Microgeographic Local Adaptation.” _American Naturalist_ 202, no. 4 (2023): 480. https://doi.org/10.1086/725865."
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "journal article with url note quote, short" do
    subject = fixture_citation_journal1.quotes.first
    expected = "Dittmar and Schemske, “Temporal Variation,” 480."
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "news_article_long" do
    expected = "Rob Pegoraro, “Apple’s iPhone Is Sleek, Smart and Simple,” _Washington Post_, July 5, 2007, LexisNexis Academic."
    subject = fixture_citation_news_article.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "book_review_long" do
    expected = "Alexandra Jacobs, “The Muchness of Madonna,” review of _Madonna: A Rebel Life_, by Mary Gabriel, _New York Times_, October 8, 2023."

    subject = fixture_citation_book_review.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "interview_long" do
    expected = "Joy Buolamwini, “‘If You Have a Face, You Have a Place in the Conversation About AI,’ Expert Says,” interview by Tonya Mosley, _Fresh Air_, NPR, November 28, 2023, audio, 37:58, https://www.npr.org/2023/11/28/1215529902/unmasking-ai-facial-recognition-technology-joy-buolamwini."

    subject = fixture_citation_interview.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "thesis_long" do
    expected = "Yuna Blajer de la Garza, “A House Is Not a Home: Citizenship and Belonging in Contemporary Democracies” (PhD diss., University of Chicago, 2019), 66–67, ProQuest (13865986)."

    subject = fixture_citation_thesis.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "web_page_long" do
    expected = "“About Yale: Yale Facts,” Yale University, accessed March 8, 2022, https://www.yale.edu/about-yale/yale-facts."

    subject = fixture_citation_web_page.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "social_media_long" do
    expected = "Chicago Manual of Style, “Is the world ready for singular they? We thought so back in 1993,” Facebook, April 17, 2015, https://www.facebook.com/ChicagoManual/posts/10152906193679151."

    subject = fixture_citation_social_media.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "video_long" do
    expected = "Vaitea Cowan, “How Green Hydrogen Could End the Fossil Fuel Era,” TED Talk, Vancouver, BC, April 2022, 9 min., 15 sec., https://www.ted.com/talks/vaitea_cowan_how_green_hydrogen_could_end_the_fossil_fuel_era."

    subject = fixture_citation_video.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "personal_long" do
    expected = "Sam Gomez, Facebook direct message to author, August 1, 2024."
    subject = fixture_citation_personal.quotes.first
    result = subject.reference.chicago_note(:long)
    assert_equal expected, result
  end

  test "news_article_short" do
    expected = "Pegoraro, “Apple’s iPhone.”"
    subject = fixture_citation_news_article.quotes.first
    
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "book_review_short" do
    expected = "Jacobs, “Muchness of Madonna.”"
    subject = fixture_citation_book_review.quotes.first
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "interview_short" do
    expected = "Buolamwini, interview."
    
    subject = fixture_citation_interview.quotes.first
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "thesis_short" do
    expected = "Blajer de la Garza, “House,” 66–67."

    subject = fixture_citation_thesis.quotes.first
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "web_page_short" do
    expected = "“Yale Facts.”"

    subject = fixture_citation_web_page.quotes.first
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "social_media_short" do
    expected = "Michele Truty, April 17, 2015, 1:09 p.m., comment on Chicago Manual of Style, “singular they.”"

    subject = fixture_citation_social_media.quotes.create({
      custom_citation: "Michele Truty, April 17, 2015, 1:09 p.m., comment on Chicago Manual of Style, “singular they.”",
      page: "",
      text: "example with custom citation"
    })
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "video_short" do
    expected = "Cowan, “Green Hydrogen,” at 9 min., 15 sec."
    subject = fixture_citation_video.quotes.first
    result = subject.reference.chicago_note(:short)
    assert_equal expected, result
  end

  test "personal_short" do
    subject = fixture_citation_personal.quotes.first
    result = subject.reference.chicago_note(:short)
    expected = ""
    assert_equal "", result
  end
end