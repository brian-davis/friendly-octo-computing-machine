Producer.destroy_all
Work.destroy_all
Publisher.destroy_all

unless ENV["CLEAR"]
  if ENV["FAKER"]
    5.times {
      Producer.create({
        custom_name: Faker::Book.author
      })
    }

    10.times {
      Work.create({
        title: Faker::Book.title,
        rating: rand(1..5),
        format: (Work.formats.keys - ["article", "chapter", "compilation"]).sample,
        year_of_publication: (Time.now.year - rand(100)),

        language: ["English", "Spanish", "French", "German", "Latin", "Greek"].sample,

        publisher: Publisher.new({
          name: Faker::Book.publisher
        }),

        tags: [Faker::Book.genre],

        work_producers: [
          WorkProducer.new({
            role: (WorkProducer.roles.keys - ["translator"]).sample,
            producer_id: Producer.all.ids.sample
          })
        ],

        quotes: [
          Quote.new({
            page: rand(200),
            text: Faker::Quote.mitch_hedberg
          })
        ],

        notes: [
          Note.new({
            text: Faker::Lorem.paragraph(sentence_count: 20, supplemental: true)
          })
        ]
      })
    }

    parent = Work.create({
      title: Faker::Book.title,
      format: "book",
      rating: rand(1..5),
      year_of_publication: (Time.now.year - rand(100)),
      publisher: Publisher.new({
        name: Faker::Book.publisher
      }),
      work_producers: [
        WorkProducer.new({
          role: "editor",
          producer: Producer.new({
            custom_name: Faker::Book.author
          })
        })
      ]
    })

    5.times {
      Work.create({
        title: Faker::Book.title,
        format: "chapter",
        rating: rand(1..5),
        parent_id: parent.id,
        work_producers: [
          WorkProducer.new({
            role: "author",
            producer_id: Producer.all.ids.sample
          })
        ]
      })
    }

    1000.downto(1) do |i|
      ReadingSession.create({
        pages: rand(1..100),
        started_at: i.days.ago,
        ended_at: (i.days.ago + rand(180).minutes),
        work_id: Work.all.ids.sample
      })
    end
  else
    # real books

    penguin = Publisher.create({
      name: "Penguin Books"
    })

    hackett = Publisher.create({
      name: "Hacket Publishing Company, Inc."
    })

    oxford = Publisher.create({
      name: "Oxford University Press"
    })

    casterman = Publisher.create({
      name: "Casterman"
    })

    meditations = Work.create({
      title: "Meditations",
      year_of_composition: 180,
      year_of_publication: 2006,
      language: "English",
      original_language: "Greek",
      format: :translated_book,
      tags: ["Classics", "Philosophy", "Ancient Rome", "Stoicism", "Penguin Classics"],

      publisher: penguin,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            custom_name: "Marcus Aurelius",
            foreign_name: "Marcus Aurelius Antoninus",
            year_of_birth: 121,
            year_of_death: 180
          })
        }),
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Martin Hammond"
          })
        }),
        WorkProducer.new({
          role: :contributor,
          producer: Producer.new({
            full_name: "Diskin Clay"
          })
        }),
      ]
    })

    the_twelve_caesars = Work.create({
      title: "The Twelve Caesars",
      year_of_composition: 130,
      year_of_publication: 2007,
      language: "English",
      original_language: "Latin",
      format: :translated_book,
      tags: ["Classics", "History", "Ancient Rome", "Penguin Classics"],

      publisher: penguin,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            custom_name: "Suetonius",
            foreign_name: "Gaius Suetonius Tranquillus",
            year_of_birth: 70,
            year_of_death: 130
          })
        }),
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Robert Graves"
          })
        })
      ]
    })

    discourses = Work.create({
      title: "Discourses",
      subtitle: "And Selected Writings",
      year_of_composition: 135,
      year_of_publication: 2008,
      language: "English",
      original_language: "Greek",
      format: :translated_book,
      tags: ["Classics", "Philosophy", "Ancient Rome", "Stoicism", "Penguin Classics"],

      publisher: penguin,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            custom_name: "Epictetus",
            year_of_birth: 55,
            year_of_death: 135
          })
        }),
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Robert Dobbin"
          })
        })
      ]
    })

    sophocles = Producer.new({
      custom_name: "Sophocles",
      year_of_birth: -495,
      year_of_death: -405
    })

    theban_plays = Work.create({
      title: "Theban Plays",
      year_of_composition: 135,
      year_of_publication: 2003,
      language: "English",
      original_language: "Greek",
      tags: ["Classics", "Tragedy", "Drama"],
      format: :translated_book,

      publisher: hackett,

      children: [
        Work.new({
          title: "Antigone",
          year_of_composition: -441,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            })
          ]
        }),
        Work.new({
          title: "Oedipus Tyrannus",
          year_of_composition: -428,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            })
          ]
        }),
        Work.new({
          title: "Oedipus at Colonus",
          year_of_composition: -411,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            })
          ]
        }),
      ],

      work_producers: [
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Peter Meineck"
          })
        }),
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Paul Woodruff"
          })
        })
      ]
    })

    logic = Work.create({
      title: "Logic",
      subtitle: "A Very Short Introduction",
      year_of_publication: 2017,
      language: "English",
      tags: ["Philosophy", "Logic", "Oxford VSI"],

      publisher: oxford,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Graham Priest"
          })
        })
      ]
    })

    information = Work.create({
      title: "Information",
      subtitle: "A Very Short Introduction",
      year_of_publication: 2010,
      language: "English",
      tags: ["Philosophy", "Information Theory", "Oxford VSI"],

      publisher: oxford,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Luciano Fioridi"
          })
        })
      ]
    })

    tintin_au_tibet = Work.create({
      supertitle: "Les Aventures De Tintin",
      title: "Tintin au Tibet",
      year_of_publication: 1960,
      language: "French",
      tags: ["Comics"],

      publisher: casterman,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            custom_name: "Hergé"
          })
        })
      ]
    })

    tintin_king_ottokar = Work.create({
      supertitle: "The Adventures Of Tintin",
      title: "King Ottokar's Sceptre",
      year_of_publication: 1947,
      language: "English",
      original_language: "French",
      tags: ["Comics"],
      format: :translated_book,

      publisher: Publisher.new({
        name: "Little, Brown And Company"
      }),

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            custom_name: "Hergé"
          })
        }),
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Leslie Lonsdale-Cooper"
          })
        }),
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Michael Turner"
          })
        })
      ]
    })

    after_the_ice = Work.create({
      title: "After The Ice",
      subtitle: "A Global Human History 20,000-5,000 BC",
      year_of_publication: 2003,
      language: "English",
      tags: ["Science", "Archaeology", "Prehistory", "History"],

      publisher: Publisher.new({
        name: "Harvard University Press"
      }),

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Steven Mithen"
          })
        })
      ]
    })

    history_of_jazz = Work.create({
      title: "The History Of Jazz",
      subtitle: "Second Edition",
      year_of_publication: 2011,
      language: "English",
      tags: ["Musicology", "History"],

      publisher: oxford,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Ted Gioia"
          })
        })
      ]
    })

    dp = Producer.new({
      full_name: "Duncan Pritchard"
    })

    mc = Producer.new({
      full_name: "Matthew Chrisman"
    })

    ar = Producer.new({
      full_name: "Alisdair Richmond"
    })

    philosophy_for_everyone = Work.create({
      title: "Philosophy For Everyone",
      year_of_publication: 2017,
      language: "English",
      tags: ["Philosophy", "Modern"],

      publisher: Publisher.new({
        name: "Routledge"
      }),

      children: [
        Work.new({
          title: "What is philosophy?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: Producer.new({
                full_name: "Dave Ward"
              })
            })
          ]
        }),

        Work.new({
          title: "Morality: objective, relative or emotive?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: mc
            })
          ]
        }),

        Work.new({
          title: "Do we have an obligation to obey the law?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: Producer.new({
                full_name: "Guy Fletcher"
              })
            })
          ]
        }),

        Work.new({
          title: "What is Knowledge? Do we have any?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: dp
            })
          ]
        }),

        Work.new({
          title: "Should you believe what you hear?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: mc
            }),
            WorkProducer.new({
              role: :author,
              producer: dp
            }),
            WorkProducer.new({
              role: :author,
              producer: ar
            }),
          ]
        }),

        Work.new({
          title: "What is it to have a mind?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: Producer.new({
                full_name: "Jane Suilin Lavelle"
              })
            })
          ]
        }),

        Work.new({
          title: "Do we have free will? (And does it matter?)",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: Producer.new({
                full_name: "Elinor Mason"
              })
            })
          ]
        }),

        Work.new({
          title: "Are scientific theories true?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: Producer.new({
                full_name: "Michaela Massimi"
              })
            })
          ]
        }),

        Work.new({
          title: "Is time travel possible?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: ar
            })
          ]
        }),
      ],

      work_producers: [
        WorkProducer.new({
          role: :editor,
          producer: mc
        }),
        WorkProducer.new({
          role: :editor,
          producer: dp
        })
      ]
    })
  end
end