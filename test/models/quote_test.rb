# == Schema Information
#
# Table name: quotes
#
#  id              :bigint           not null, primary key
#  text            :text
#  page            :integer
#  custom_citation :string
#  work_id         :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  searchable      :tsvector
#
require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  test "validates text" do
    q1 = works(:one).quotes.build({
      text: "",
      custom_citation: "1a",
      page: 1
    })
    refute q1.valid?
    assert_equal ["Text can't be blank"], q1.errors.full_messages
  end

  test "full-text indexed search" do
    work = Work.create(title: "Sandwich")
    quote1 = work.quotes.create(text: "lettuce")
    quote2 = work.quotes.create(text: "lettuce and bacon and more lettuce")
    quote3 = work.quotes.create(text: "lettuce and bacon and tomato")

    search1 = Quote.search_text("tomato")
    assert (quote3).in?(search1)
    refute (quote2).in?(search1)
    refute (quote1).in?(search1)

    search2 = Quote.search_text("lettuce")
    assert (quote3).in?(search2)
    assert (quote2).in?(search2)
    assert (quote1).in?(search2)

    # ranking
    assert search2.index(quote2) < search2.index(quote1)
    assert search2.index(quote2) < search2.index(quote3)
  end

  test "full-text indexed search by prefix" do
    work = Work.create(title: "Sandwich")
    quote1 = work.quotes.create(text: "lettuce")
    quote2 = work.quotes.create(text: "don't let me down")

    search1 = Quote.search_text("lettuce")
    assert (quote1).in?(search1)
    refute (quote2).in?(search1)

    search2 = Quote.search_text("let")
    assert (quote1).in?(search2)
    assert (quote2).in?(search2)
  end

  test "full-text indexed search with negation" do
    work = Work.create(title: "Sandwich")
    quote1 = work.quotes.create(text: "lettuce and tomato")
    quote2 = work.quotes.create(text: "lettuce and salt")

    search1 = Quote.search_text("lettuce")
    assert (quote1).in?(search1)
    assert (quote2).in?(search1)

    search2 = Quote.search_text("lettuce !tomato")
    refute (quote1).in?(search2)
    assert (quote2).in?(search2)
  end

  test "full-text indexed search with stemming" do
    work = Work.create(title: "Doing something")
    quote1 = work.quotes.create(text: "He is sleeping.")
    quote2 = work.quotes.create(text: "He sleeps.")
    quote3 = work.quotes.create(text: "Sleep is very important")

    search1 = Quote.search_text("sleeping")
    assert (quote1).in?(search1)
    assert (quote2).in?(search1)
    assert (quote3).in?(search1)
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
            name: "Charles Yu"
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
            name: "Amy J. Binder"
          })
        }),
        WorkProducer.new({
          role: :co_author,
          producer: Producer.new({
            name: "Jeffrey L. Kidder"
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

  test "bibliography citation chapter in compilation" do
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
            name: "P. J. M. Marks"
          })
        }),
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            name: "Stephen Parkin"
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
            name: "Kathleen Doyle"
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
            name: "P. J. M. Marks"
          })
        }),
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            name: "Stephen Parkin"
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
            name: "Kathleen Doyle"
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
end
