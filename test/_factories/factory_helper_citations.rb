# Fixtures taken from examples at Chicago Manual of Sytle site.
module FactoryHelperCitations
  private

  def fixture_citation_interior_chinatown
    @fixture_citation_interior_chinatown ||= Work.create({
      title: "Interior Chinatown",
      publishing_format: "book",
      year_of_publication: 2020,
      publisher: Publisher.new({
        name: "Pantheon Books"
      }),
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            forename: "Charles",
            surname: "Yu"
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

  def fixture_citation_channels
    @fixture_citation_channels ||= Work.create({
      title: "The Channels of Student Activism",
      subtitle: "How the Left and Right Are Winning (and Losing) in Campus Politics Today",
      year_of_publication: 2022,
      publisher: Publisher.new({
        name: "University of Chicago Press"
      }),
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            forename: "Amy",
            middle_name: "J.",
            surname: "Binder"
          })
        }),
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            forename: "Jeffrey",
            middle_name: "L.",
            surname: "Kidder"
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

  def fixture_citation_wedding_party
    @fixture_citation_wedding_party ||= Work.create({
      title: "The Wedding Party",
      publishing_format: "book",
      year_of_publication: 2021,
      publisher: Publisher.new({
        name: "Amazon Crossing"
      }),
      work_producers: [
        WorkProducer.new({
          role: "translator",
          producer: Producer.new({
            forename: "Jeremy",
            surname: "Tiang"
          })
        }),
        WorkProducer.new({
          role: "author",
          producer: Producer.new({
            forename: "John",
            surname: "Smith"
          })
        })
      ]
    })
  end

  def fixture_citation_book_by_design
    @fixture_citation_book_by_design ||= Work.create({
      title: "The Book by Design",
      subtitle: "The Remarkable Story of the World’s Greatest Invention",
      year_of_publication: 2023,
      publishing_format: "book",

      publisher: Publisher.new({
        name: "University of Chicago Press"
      }),

      children: [
        Work.new({
          title: "Chapter 1"
        })
      ],

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
            forename: "Stephen",
            surname: "Parkin"
          })
        }),
      ]
    })
  end

  def fixture_citation_book_by_design_child
    @fixture_citation_book_by_design_child ||= Work.create({
      title: "The Queen Mary Psalter",
      publishing_format: "chapter",
      parent: fixture_citation_book_by_design,
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            forename: "Kathleen",
            surname: "Doyle"
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
end