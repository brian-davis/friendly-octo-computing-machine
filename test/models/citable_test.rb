require "test_helper"

class CitableTest < ActiveSupport::TestCase
  # BOOK, 1 AUTHOR
  def book1
    @book1 ||= begin
      work = Work.create({
        title: "Interior Chinatown",
        format: "book",
        year_of_publication: 2020,
        publisher: Publisher.new({
          name: "Pantheon Books"
        }),
        work_producers: [
          WorkProducer.new({
            role: :author,
            producer: Producer.new({
              given_name: "Charles",
              family_name: "Yu"
            })
          })
        ],
        quotes: [
          Quote.new({
            page: 45,
            text: "This is a quote."
          })
        ]
      })
    end
  end

  # BOOK, MULTIPLE AUTHORS
  def book2
    @book2 ||= Work.create({
      title: "The Channels of Student Activism",
      subtitle: "How the Left and Right Are Winning (and Losing) in Campus Politics Today",
      year_of_publication: 2022,
      publisher: Publisher.new({
        name: "University of Chicago Press"
      }),
      work_producers: [
        WorkProducer.new({
          role: :co_author,
          producer: Producer.new({
            given_name: "Amy",
            middle_name: "J.",
            family_name: "Binder"
          })
        }),
        WorkProducer.new({
          role: :co_author,
          producer: Producer.new({
            given_name: "Jeffrey",
            middle_name: "L.",
            family_name: "Kidder"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "117–18",
          text: "This is a quote."
        })
      ]
    })
  end

  # BOOK, TRANSLATED
  def book3
    @book3 ||= Work.create({
      title: "The Wedding Party",
      format: "book",
      year_of_publication: 2021,
      publisher: Publisher.new({
        name: "Amazon Crossing"
      }),
      work_producers: [
        WorkProducer.new({
          role: "translator",
          producer: Producer.new({
            given_name: "Jeremy",
            family_name: "Tiang"
          })
        }),
        WorkProducer.new({
          role: "author",
          producer: Producer.new({
            given_name: "John",
            family_name: "Smith"
          })
        })
      ]
    })
  end

  # COMPILATION PARENT
  def book4
    @book4 ||= Work.create({
      title: "The Book by Design",
      subtitle: "The Remarkable Story of the World’s Greatest Invention",
      year_of_publication: 2023,
      format: "compilation",

      publisher: Publisher.new({
        name: "University of Chicago Press"
      }),

      work_producers: [
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            custom_name: "P. J. M. Marks"
          })
        }),
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            given_name: "Stephen",
            family_name: "Parkin"
          })
        }),
      ]
    })
  end

  # COMPILATION CHILD

  def book4_child
    @book4_child ||= Work.create({
      title: "The Queen Mary Psalter",
      format: "chapter",
      parent: book4,
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            given_name: "Kathleen",
            family_name: "Doyle"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "64",
          text: "A quote"
        })
      ]
    })
  end

  test "book bibliography entry" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, Charles. _Interior Chinatown_. Pantheon Books, 2020."
    result = Citation::Bibliography.new(book1).entry

    assert_equal expected, result
  end

  test "book long citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Charles Yu, _Interior Chinatown_ (Pantheon Books, 2020), 45."
    result = Citation::Note.new(book1.quotes.first).long

    assert_equal expected, result
  end

  test "book short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, _Interior Chinatown_, 45."
    result = Citation::Note.new(book1.quotes.first).short

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

  test "book long citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Amy J. Binder and Jeffrey L. Kidder, _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_ (University of Chicago Press, 2022), 117–18."

    result = Citation::Note.new(book2.quotes.first).long

    assert_equal expected, result
  end

  test "short citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder and Kidder, _Channels of Student Activism_, 117–18."
    result = Citation::Note.new(book2.quotes.first).short

    assert_equal expected, result
  end

  test "chapter bibliography" do
    expected = "Doyle, Kathleen. “The Queen Mary Psalter.” In _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, edited by P. J. M. Marks and Stephen Parkin. University of Chicago Press, 2023."

    result = Citation::Bibliography.new(book4_child).entry

    assert_equal expected, result
  end

  test "compilation bibiography" do
    expected = "P. J. M. Marks and Stephen Parkin, eds., _The Book by Design: The Remarkable Story of the World’s Greatest Invention_ (University of Chicago Press, 2023)."

    result = Citation::Bibliography.new(book4).entry

    assert_equal expected, result
  end

  test "chapter short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Doyle, “Queen Mary Psalter,” 64."
    result = Citation::Note.new(book4_child.quotes.first).short
    assert_equal expected, result
  end

  test "chapter long citation" do
    # # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Kathleen Doyle, “The Queen Mary Psalter,” in _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, ed. P. J. M. Marks and Stephen Parkin (University of Chicago Press, 2023), 64."

    result = Citation::Note.new(book4_child.quotes.first).long

    assert_equal expected, result
  end
end
