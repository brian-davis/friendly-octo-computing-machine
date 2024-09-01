require "test_helper"

class CitationableTest < ActiveSupport::TestCase
  def citation_work_fixture
    @citation_work_fixture ||= Work.create({
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
      ]
    })
  end

  test "bibliography citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, Charles. _Interior Chinatown_. Pantheon Books, 2020."
    assert_equal expected, citation_work_fixture.bibliography_markdown
  end

  def citation_work_fixture2
    @citation_work_fixture2 ||= Work.create({
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
      ]
    })
  end

  test "bibliography citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder, Amy J., and Jeffrey L. Kidder. _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_. University of Chicago Press, 2022."
    result = citation_work_fixture2.bibliography_markdown
    assert_equal expected, result
  end

  test "bibliography for translated book (western name)" do
    work = Work.create({
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
    result = work.bibliography_markdown
    expected = "Smith, John. _The Wedding Party_. Translated by Jeremy Tiang. Amazon Crossing, 2021."
    assert_equal(expected, result)
  end

  def citation_work_fixture
    @citation_work_fixture ||= Work.create({
      title: "Interior Chinatown",
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
      ]
    })
  end

  def citation_quote_fixture
    @citation_quote_fixture ||= citation_work_fixture.quotes.create({
      page: 45,
      text: "This is a quote."
    })
  end

  test "long citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Charles Yu, _Interior Chinatown_ (Pantheon Books, 2020), 45."
    assert_equal expected, citation_quote_fixture.long_citation_markdown
  end

  test "short citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, _Interior Chinatown_, 45."
    assert_equal expected, citation_quote_fixture.short_citation_markdown
  end

  def citation_work_fixture2
    @citation_work_fixture2 ||= Work.create({
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
      ]
    })
  end

  def citation_quote_fixture2
    @citation_quote_fixture2 ||= citation_work_fixture2.quotes.create({
      page: "117–18",
      text: "This is a quote."
    })
    # binding.irb
  end

  test "long citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Amy J. Binder and Jeffrey L. Kidder, _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_ (University of Chicago Press, 2022), 117–18."
    result = citation_quote_fixture2.long_citation_markdown
    assert_equal expected, result
  end

  test "short citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder and Kidder, _Channels of Student Activism_, 117–18."
    assert_equal expected, citation_quote_fixture2.short_citation_markdown
  end

  test "_bibliography citation chapter in compilation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    parent = Work.create({
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

    child = Work.create({
      title: "The Queen Mary Psalter",
      format: "chapter",
      parent: parent,
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            given_name: "Kathleen",
            family_name: "Doyle"
          })
        })
      ]
    })

    quote = child.quotes.create({
      page: "64",
      text: "A quote"
    })

    expected = "Kathleen Doyle, “The Queen Mary Psalter,” in _The Book by Design: The Remarkable Story of the World’s Greatest Invention_, ed. P. J. M. Marks and Stephen Parkin (University of Chicago Press, 2023), 64."

    result = quote.long_citation_markdown

    assert_equal expected, result
  end

  test "bibliography citation chapter in compilation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-chapter
    # In some cases, you may want to cite the collection as a whole instead.
    # P. J. M. Marks and Stephen Parkin, eds., The Book by Design: The Remarkable Story of the World’s Greatest Invention (University of Chicago Press, 2023).

    compilation = Work.create({
      title: "The Book by Design",
      subtitle: "The Remarkable Story of the World’s Greatest Invention",
      year_of_publication: 2023,
      format: :compilation,

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

    expected = "P. J. M. Marks and Stephen Parkin, eds., _The Book by Design: The Remarkable Story of the World’s Greatest Invention_ (University of Chicago Press, 2023)."

    result = compilation.bibliography_markdown

    assert_equal expected, result
  end

  test "short bibliography citation chapter in compilation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    parent = Work.create({
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

    child = Work.create({
      title: "The Queen Mary Psalter",
      format: "chapter",
      parent: parent,
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            given_name: "Kathleen",
            family_name: "Doyle"
          })
        })
      ]
    })

    quote = child.quotes.create({
      page: "64",
      text: "A quote"
    })

    expected = "Doyle, “Queen Mary Psalter,” 64."
    result = quote.short_citation_markdown
    assert_equal expected, result
  end

  test "bibliography for dictionary" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    work = Work.create({
      title: "French-English Dictionary",
      subtitle: "",
      alternate_title: "Merriam-Webster's French-English Dictionary",
      foreign_title: "Dictionnaire Anglais-Français",
      year_of_publication: 2005,
      format: "book", # nothing special

      publisher: Publisher.new({
        name: "Merriam-Webster, Incorporated"
      }),

      work_producers: [
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            given_name: "Eileen",
            middle_name: "M.",
            family_name: "Haraty"
          })
        })
      ]
    })

    expected = "Haraty, Eileen M.. _French-English Dictionary_. Merriam-Webster, Incorporated, 2005."
    result = work.bibliography_markdown
    assert_equal expected, result
  end
end
