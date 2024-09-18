# fixtures for base_test, bibliography_test, note_test
module CitationTestSubjects
  # BOOK, 1 AUTHOR
  def book1
    @book1 ||= begin
      work = Work.create({
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

  # BOOK, TRANSLATED
  def book3
    @book3 ||= Work.create({
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

  # COMPILATION PARENT
  def book4
    @book4 ||= Work.create({
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

  # COMPILATION CHILD
  def book4_child
    @book4_child ||= Work.create({
      title: "The Queen Mary Psalter",
      publishing_format: "chapter",
      parent: book4,
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

  def base_w1
    @base_w1 ||= begin
      base_w1 = Work.create({
        title: "Test Work",
        work_producers: [
          WorkProducer.new({
            role: :author,
            producer: producers(:nine)
          })
        ]
      })
      base_w1.authors << producers(:ten) # force order
      base_w1
    end
  end

  def base_w2
    @base_w2 ||= begin
      base_w2 = Work.create({
        title: "Test Work2",
        work_producers: [
          WorkProducer.new({
            role: :translator,
            producer: Producer.new(full_name: "John Döe")
          })
        ]
      })
      base_w2.translators << Producer.new(full_name: "Jane D'Onofrio") # force order
      base_w2
    end
  end
end
