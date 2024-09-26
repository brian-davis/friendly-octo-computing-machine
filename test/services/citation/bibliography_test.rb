require "test_helper"
require_relative "../../_factories/factory_helper_citations"

class BibliographyTest < ActiveSupport::TestCase
  include FactoryHelperCitations  

  test "work bibliography citations bad data" do
    formats = Work.publishing_formats.keys
    formats.each do |k|
      subject = Work.new({
        title: "Missing Data #{k}",
        publishing_format: k
      })

      result1 = subject.reference.chicago_bibliography
      assert result1.blank?
  
      result2 = subject.reference.chicago_bibliography
      assert result2.blank?
    end
  end

  test "book bibliography entry" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, Charles. _Interior Chinatown_. Pantheon Books, 2020."
    result = fixture_citation_interior_chinatown.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "book bibliography entry multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder, Amy J., and Jeffrey L. Kidder. _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_. University of Chicago Press, 2022."

    result = fixture_citation_channels.reference.chicago_bibliography

    assert_equal expected, result
  end

  test "book with translator bibliography" do
    expected = "Smith, John. _The Wedding Party_. Translated by Jeremy Tiang. Amazon Crossing, 2021."
    result = fixture_citation_wedding_party.reference.chicago_bibliography
    assert_equal(expected, result)
  end

  test "chapter bibliography" do
    expected = "Doyle, Kathleen. “The Queen Mary Psalter.” In _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, edited by P. J. M. Marks and Stephen Parkin. University of Chicago Press, 2023."

    result = fixture_citation_book_by_design_child.reference.chicago_bibliography

    assert_equal expected, result
  end

  test "chapter bibliography for parent work with 2 translators" do
    antigone = fixture_works_antigone
    
    # confusing, close enough for government work? TODO: look this up with real library cataloging standards.
    expected = "Sophocles. “Antigone.” Translated by Peter Meineck and Paul Woodruff. In _Theban Plays_, edited by Peter Meineck and Paul Woodruff. Hacket Publishing Company, Inc., 2003."

    result = antigone.reference.chicago_bibliography

    assert_equal expected, result
  end

  test "compilation bibiography" do
    expected = "P. J. M. Marks and Stephen Parkin, eds., _The Book by Design: The Remarkable Story of the World’s Greatest Invention_ (University of Chicago Press, 2023)."

    result = fixture_citation_book_by_design.reference.chicago_bibliography

    assert_equal expected, result
  end

  test "ebook with url bibliography" do
    subject = fixture_citation_ebook_url
    expected = "Kurland, Philip B., and Ralph Lerner, eds. _The Founders’ Constitution_. University of Chicago Press, 1987. https://press-pubs.uchicago.edu/founders/."
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "ebook without url bibliography" do
    subject = fixture_citation_ebook_no_url
    expected = "Roy, Arundhati. _The God of Small Things_. Random House, 2008. Kindle."
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "journal article" do
    subject = fixture_citation_journal1
    expected = "Dittmar, Emily L., and Douglas W. Schemske. “Temporal Variation in Selection Influences Microgeographic Local Adaptation.” _American Naturalist_ 202, no. 4 (2023): 471–85. https://doi.org/10.1086/725865."
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "news_article" do
    expected = "Pegoraro, Rob. “Apple’s iPhone Is Sleek, Smart and Simple.” _Washington Post_, July 5, 2007. LexisNexis Academic."
    subject = fixture_citation_news_article
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "book_review" do
    expected = "Jacobs, Alexandra. “The Muchness of Madonna.” Review of _Madonna: A Rebel Life_, by Mary Gabriel. _New York Times_, October 8, 2023."
    subject = fixture_citation_book_review
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "interview" do
    expected = "Buolamwini, Joy. “‘If You Have a Face, You Have a Place in the Conversation About AI,’ Expert Says.” Interview by Tonya Mosley. _Fresh Air_, NPR, November 28, 2023. Audio, 37:58. https://www.npr.org/2023/11/28/1215529902/unmasking-ai-facial-recognition-technology-joy-buolamwini."
    subject = fixture_citation_interview
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "thesis" do
    expected = "Blajer de la Garza, Yuna. “A House Is Not a Home: Citizenship and Belonging in Contemporary Democracies.” PhD diss., University of Chicago, 2019. ProQuest (13865986)."
    subject = fixture_citation_thesis
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "web_page" do
    expected = "Yale University. “About Yale: Yale Facts.” Accessed March 8, 2022. https://www.yale.edu/about-yale/yale-facts."
    subject = fixture_citation_web_page
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "social_media" do
    expected = "Chicago Manual of Style. “Is the world ready for singular they? We thought so back in 1993.” Facebook, April 17, 2015. https://www.facebook.com/ChicagoManual/posts/10152906193679151."
    subject = fixture_citation_social_media
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "video" do
    expected = "Cowan, Vaitea. “How Green Hydrogen Could End the Fossil Fuel Era.” TED Talk, Vancouver, BC, April 2022. Video, 9 min., 15 sec. https://www.ted.com/talks/vaitea_cowan_how_green_hydrogen_could_end_the_fossil_fuel_era."
    subject = fixture_citation_video
    result = subject.reference.chicago_bibliography
    assert_equal expected, result
  end

  test "personal" do
    subject = fixture_citation_personal
    result = subject.reference.chicago_bibliography
    assert_nil result
  end
end