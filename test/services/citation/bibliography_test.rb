require "test_helper"
require_relative "citation_test_subjects"

class BibliographyTest < ActiveSupport::TestCase
  include ::CitationTestSubjects

  test "book bibliography entry" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, Charles. _Interior Chinatown_. Pantheon Books, 2020."
    result = Citation::Bibliography.new(book1).entry
    assert_equal expected, result
  end

  test "book bibliography entry multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder, Amy J., and Jeffrey L. Kidder. _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_. University of Chicago Press, 2022."

    result = Citation::Bibliography.new(book2).entry

    assert_equal expected, result
  end

  test "book with translator bibliography" do
    expected = "Smith, John. _The Wedding Party_. Translated by Jeremy Tiang. Amazon Crossing, 2021."
    result = Citation::Bibliography.new(book3).entry

    assert_equal(expected, result)
  end

  test "chapter bibliography" do
    expected = "Doyle, Kathleen. “The Queen Mary Psalter.” In _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, edited by P. J. M. Marks and Stephen Parkin. University of Chicago Press, 2023."

    result = Citation::Bibliography.new(book4_child).entry

    assert_equal expected, result
  end

  test "chapter bibliography for parent work with 2 translators" do
    hackett = Publisher.find_or_create_by({
      name: "Hacket Publishing Company, Inc."
    })
    sophocles = Producer.find_or_create_by({
      custom_name: "Sophocles",
      year_of_birth: -495,
      year_of_death: -405
    })
    meineck = Producer.create({
      full_name: "Peter Meineck"
    })
    woodruff = Producer.create({
      full_name: "Paul Woodruff"
    })
    theban_plays = Work.create({
      title: "Theban Plays",
      year_of_composition: 135,
      year_of_publication: 2003,
      language: "English",
      original_language: "Greek",
      tags: ["Classics", "Tragedy", "Drama"],
      publishing_format: :book,
      date_of_accession: Date.new(2024,6,1),
      accession_note: "Bought used from Changing Hands in Tempe",
      publisher: hackett,

      children: [
        Work.new({
          title: "Antigone",
          year_of_composition: -441,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          publishing_format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            }),
            WorkProducer.new({
              role: :translator,
              producer: meineck
            }),
            WorkProducer.new({
              role: :translator,
              producer: woodruff
            })
          ]
        }),
        Work.new({
          title: "Oedipus Tyrannus",
          year_of_composition: -428,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          publishing_format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            }),
            WorkProducer.new({
              role: :translator,
              producer: meineck
            }),
            WorkProducer.new({
              role: :translator,
              producer: woodruff
            })
          ]
        }),
        Work.new({
          title: "Oedipus at Colonus",
          year_of_composition: -411,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          publishing_format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            }),
            WorkProducer.new({
              role: :translator,
              producer: meineck
            }),
            WorkProducer.new({
              role: :translator,
              producer: woodruff
            })
          ]
        }),
      ],

      work_producers: [
        WorkProducer.new({
          role: :editor,
          producer: meineck
        }),
        WorkProducer.new({
          role: :editor,
          producer: woodruff
        })
      ]
    })
    antigone = theban_plays.children.first
    
    # confusing, close enough for government work? TODO: look this up with real library cataloging standards.
    expected = "Sophocles. “Antigone.” Translated by Peter Meineck and Paul Woodruff. In _Theban Plays_, edited by Peter Meineck and Paul Woodruff. Hacket Publishing Company, Inc., 2003."

    result = Citation::Bibliography.new(antigone).entry

    assert_equal expected, result
  end

  test "compilation bibiography" do
    expected = "P. J. M. Marks and Stephen Parkin, eds., _The Book by Design: The Remarkable Story of the World’s Greatest Invention_ (University of Chicago Press, 2023)."

    result = Citation::Bibliography.new(book4).entry

    assert_equal expected, result
  end
end