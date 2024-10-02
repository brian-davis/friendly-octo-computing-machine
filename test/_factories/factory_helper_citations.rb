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

  def fixture_citation_ebook_url
    @fixture_citation_ebook_url ||= Work.create({
      title: "The Founders’ Constitution",
      publishing_format: :ebook,
      year_of_publication: 1987,
      publisher: Publisher.find_or_create_by(name: "University of Chicago Press"),
      url: "https://press-pubs.uchicago.edu/founders/",
      work_producers: [
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            full_name: "Philip B. Kurland"
          })
        }),
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            full_name: "Ralph Lerner"
          })
        })
      ],
      quotes: [
        Quote.new({
          custom_citation: "chap. 10, doc. 19",
          text: "Example quote"
        })
      ]
    })
  end

  def fixture_citation_ebook_no_url
    @fixture_citation_ebook_no_url ||= Work.create({
      title: "The God of Small Things",
      publishing_format: :ebook,
      year_of_publication: 2008,
      publisher: Publisher.find_or_create_by(name: "Random House"),
      online_source: "Kindle",
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Arundhati Roy"
          })
        })
      ],
      quotes: [
        Quote.new({
          custom_citation: "chap. 6",
          text: "Example quote"
        })
      ]
    })
  end

  def fixture_citation_journal1
    @fixture_citation_journal1 ||= Work.create({
      title: "Temporal Variation in Selection Influences Microgeographic Local Adaptation",
      year_of_publication: 2023,
      publishing_format: :journal_article,
      journal_name: "American Naturalist",
      journal_volume: 202,
      journal_issue: 4,
      article_page_span: "471–85",
      url: "https://doi.org/10.1086/725865",
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Emily L. Dittmar"
          })
        }),
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Douglas W. Schemske"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "480",
          text: "example quote"
        })
      ]
    })
  end

  def fixture_citation_news_article
    @fixture_citation_news_article ||= Work.create({
      title: "Apple’s iPhone Is Sleek, Smart and Simple",
      year_of_publication: 2007,
      publishing_format: :news_article,
      journal_name: "Washington Post", # TODO: use Producer model, :journal enum?
      article_date: Date.new(2007, 7, 5),
      online_source: "LexisNexis Academic", # TODO: use Producer model, :online enum?
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Rob Pegoraro"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "",
          text: "example quote"
        })
      ]
    })
  end

  def fixture_citation_book_review
    @fixture_citation_book_review ||= Work.create({
      title: "The Muchness of Madonna",
      year_of_publication: 2023,
      publishing_format: :book_review,
      journal_name: "New York Times", # TODO: use Producer model, :journal enum?
      article_date: Date.new(2023, 10, 8),

      review_title: "Madonna: A Rebel Life",
      review_author: "Mary Gabriel",

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Alexandra Jacobs"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "",
          text: "example quote"
        })
      ]
    })
  end

  def fixture_citation_interview
    @fixture_citation_interview ||= Work.create({
      title: "‘If You Have a Face, You Have a Place in the Conversation About AI,’ Expert Says",
      year_of_publication: 2023,
      publishing_format: :interview,
      media_source: "Fresh Air",
      media_format: "Audio",
      online_source: "NPR", # TODO: use Producer model, :journal enum?
      media_date: Date.new(2023, 11, 28),
      interviewer_name: "Tonya Mosley",
      media_timestamp: "37:58",
      url: "https://www.npr.org/2023/11/28/1215529902/unmasking-ai-facial-recognition-technology-joy-buolamwini",
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Joy Buolamwini"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "",
          text: "example quote"
        })
      ]
    })
  end

  def fixture_citation_thesis
    @fixture_citation_thesis ||= Work.create({
      title: "A House Is Not a Home",
      subtitle: "Citizenship and Belonging in Contemporary Democracies",
      year_of_publication: 2019,
      publishing_format: :thesis,
      journal_name: "University of Chicago",
      media_format: "PhD diss.",
      online_source: "ProQuest (13865986)",
      
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            forename: "Yuna",
            surname: "Blajer de la Garza"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "66–67",
          text: "example quote"
        })
      ]
    })
  end

  def fixture_citation_web_page
    @fixture_citation_web_page ||= Work.create({
      title: "About Yale",
      subtitle: "Yale Facts",
      publishing_format: :web_page,
      media_date: Date.new(2022,3,8),
      media_source: "Yale University",
      url: "https://www.yale.edu/about-yale/yale-facts",
      work_producers: [
      ],
      quotes: [
        Quote.new({
          page: "",
          text: "example quote"
        })
      ]
    })
  end

  def fixture_citation_social_media
    @fixture_citation_social_media ||= Work.create({
      title: "Is the world ready for singular they?",
      subtitle: "We thought so back in 1993",
      publishing_format: :social_media,
      media_date: Date.new(2015,4,17),
      media_source: "Facebook",
      url: "https://www.facebook.com/ChicagoManual/posts/10152906193679151",
      work_producers: [
        WorkProducer.new({
          role: :author, # TODO: flag for social_media/corporate account?,
          producer: Producer.new({
            custom_name: "Chicago Manual of Style"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "",
          text: "example quote"
        })
      ]
    })
  end

  def fixture_citation_video
    @fixture_citation_video ||= Work.create({
      title: "How Green Hydrogen Could End the Fossil Fuel Era",
      publishing_format: :video,

      media_source: "TED Talk, Vancouver, BC, April 2022", # hack
      url: "https://www.ted.com/talks/vaitea_cowan_how_green_hydrogen_could_end_the_fossil_fuel_era",
      media_format: "Video",
      media_timestamp: "9 min., 15 sec.", # alt.
      work_producers: [
        WorkProducer.new({
          role: :author, # TODO: flag for social_media/corporate account?,
          producer: Producer.new({
            full_name: "Vaitea Cowan"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "",
          text: "example quote"
        })
      ]
    })
  end

  def fixture_citation_personal
    @fixture_citation_personal ||= Work.create({
      title: "Facebook direct message to author", # hack
      publishing_format: :personal,
      media_date: Date.new(2024,8,1),
      media_source: "",
      work_producers: [
        WorkProducer.new({
          role: :author, # TODO: flag for social_media/corporate account?,
          producer: Producer.new({
            full_name: "Sam Gomez"
          })
        })
      ],
      quotes: [
        Quote.new({
          page: "",
          text: "example quote"
        })
      ]
    })
  end
end