# Use this file to build fixtures without the stupid .yml API
# similar to seeds
module FactoryHelper
  private

  # PUBLISHERS
  def fixture_publishers_little_brown
    @fixture_publishers_little_brown ||= Publisher.create({
      name: "Little, Brown And Company"
    })
  end

  def fixture_publishers_oup
    @fixture_publishers_oup ||= Publisher.create({
      name: "Oxford University Press"
    })
  end

  def fixture_publishers_casterman
    @fixture_publishers_casterman ||= Publisher.create({
      name: "Casterman"
    })
  end

  def fixture_publishers_hackett
    @fixture_publishers_hackett ||= Publisher.create({
      name: "Hacket Publishing Company, Inc."
    })
  end

  # PRODUCERS
  def fixture_producers_graham_priest
    @fixture_producers_graham_priest ||= Producer.create({
      # full_name: "Graham Priest"
      forename: "Graham",
      surname: "Priest"
    })
  end

  def fixture_producers_sophocles
    @fixture_producers_sophocles ||= Producer.create({
      custom_name: "Sophocles",
      year_of_birth: -495,
      year_of_death: -405
    })
  end

  def fixture_producers_epictetus
    @fixture_producers_epictetus ||= Producer.create({
      custom_name: "Epictetus"
    })
  end

  def fixture_producers_plato
    @fixture_producers_plato ||= Producer.create({
      custom_name: "Plato"
    })
  end

  def fixture_producers_voltaire
    @fixture_producers_voltaire ||= Producer.create({
      custom_name: "Voltaire"
    })
  end

  def fixture_producers_paul_woodruff
    @fixture_producers_paul_woodruff ||= Producer.create({
      full_name: "Paul Woodruff"
    })
  end

  def fixture_producers_mark_twain
    @fixture_producers_mark_twain ||= Producer.create({
      full_name: "Samuel Clemens",
      custom_name: "Mark Twain",
      year_of_birth: 1835,
      year_of_death: 1910
    })
  end

  def fixture_producers_peter_meineck
    @fixture_producers_peter_meineck ||= Producer.create({
      full_name: "Peter Meineck",
      notes: [
        Note.new({
          text: "This is a demo note for a Producer"
        })
      ]
    })
  end

  # WORKS
  def fixture_works_logic_vsi
    @fixture_works_logic_vsi ||= Work.create({
      title: "Logic",
      subtitle: "A Very Short Introduction",
      year_of_publication: 2017,
      rating: 3,
      language: "English",
      tags: ["Philosophy", "Logic", "Oxford VSI"],

      publisher: fixture_publishers_oup,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: fixture_producers_graham_priest
        })
      ]
    })
  end

  def fixture_producers_john_searle
    @fixture_producers_john_searle ||= Producer.create({
      full_name: "John Searle",
      year_of_birth: 1932,
      nationality: "American"
    })
  end

  def fixture_works_information_vsi
    @fixture_works_information_vsi ||= Work.create({
      title: "Information",
      subtitle: "A Very Short Introduction",
      year_of_publication: 2010,
      language: "English",
      tags: ["Philosophy", "Information Theory", "Oxford VSI"],
      date_of_accession: Date.new(2024,6,10),
      accession_note: "Bought new from Amazon",

      publisher: fixture_publishers_oup,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Luciano Fioridi"
          })
        })
      ]
    })
  end

  def fixture_producers_herge
    @fixture_producers_herge ||= Producer.create({
      custom_name: "Hergé",
      notes: [
        Note.new({
          text: "I love the Ligne Claire style"
        })
      ]
    })
  end

  def fixture_producers_aristotle
    @fixture_producers_aristotle ||= Producer.create({
      custom_name: "Aristotle"
    })
  end

  def fixture_works_politics
    @fixture_works_politics ||= Work.create({
      title: "Politics",
      producers: [fixture_producers_aristotle]
    })
  end

  def fixture_works_tintin_king_ottokar
    @fixture_works_tintin_king_ottokar ||= Work.create({
      supertitle: "The Adventures Of Tintin",
      title: "King Ottokar's Sceptre",
      year_of_publication: 1947,
      language: "English",
      original_language: "French",
      tags: ["Comics"],
      publishing_format: :book,
      date_of_accession: Date.new(2010,8,1),
      accession_note: "Don't remember when I bought this, but it was a long time ago.  Didn't read it until recently.",

      publisher: fixture_publishers_little_brown,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: fixture_producers_herge
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
  end

  def fixture_works_theban_plays
    @fixture_works_theban_plays ||= Work.create({
      title: "Theban Plays",
      year_of_publication: 2003,
      language: "English",
      original_language: "Greek",
      tags: ["Classics", "Tragedy", "Drama"],

      publisher: fixture_publishers_hackett,

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
              producer: fixture_producers_sophocles
            }),
            WorkProducer.new({
              role: :translator,
              producer: fixture_producers_peter_meineck
            }),
            WorkProducer.new({
              role: :translator,
              producer: fixture_producers_paul_woodruff
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
              producer: fixture_producers_sophocles
            }),
            WorkProducer.new({
              role: :translator,
              producer: fixture_producers_peter_meineck
            }),
            WorkProducer.new({
              role: :translator,
              producer: fixture_producers_paul_woodruff
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
              producer: fixture_producers_sophocles
            }),
            WorkProducer.new({
              role: :translator,
              producer: fixture_producers_peter_meineck
            }),
            WorkProducer.new({
              role: :translator,
              producer: fixture_producers_paul_woodruff
            })
          ]
        }),
      ],

      work_producers: [
        WorkProducer.new({
          role: :editor,
          producer: fixture_producers_peter_meineck
        }),
        WorkProducer.new({
          role: :editor,
          producer: fixture_producers_paul_woodruff
        })
      ]
    })
  end

  def fixture_works_antigone
    @fixture_works_antigone ||= fixture_works_theban_plays.children.find_by(title: "Antigone")
  end

  def fixture_works_oedipus_tyrannus
    @fixture_works_oedipus_tyrannus ||= fixture_works_theban_plays.children.find_by(title: "Oedipus Tyrannus")
  end

  def fixture_works_oedipus_at_colonus
    @fixture_works_oedipus_at_colonus ||= fixture_works_theban_plays.children.find_by(title: "Oedipus at Colonus")
  end

  def fixture_works_the_baltic_origins
    Work.create({
      title: "The Baltic Origins Of Homer's Epic Tales",
      subtitle: "the Iliad, the Odyssey, and the migration of myth",
      year_of_publication: 2006,
      language: "English",
      original_language: "Italian",
      foreign_title: "Omero nel Baltico",
      tags: ["Classics", "Mythology", "Homer"],
      date_of_accession: Date.new(2010,1,1),
      accession_note: "Purchased new from Amazon, to re-read after having first read this from the library in 2010 or so.",
      publisher: Publisher.new({
        name: "Inner Traditions"
      }),
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Felice Vinci"
          })
        }),
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Amalia Di Francesco"
          })
        })
      ],
      notes: [
        Note.new({
          text: "A radical re-interpretation of Homer"
        })
      ]
    })
  end

  def fixture_works_after_the_ice
    @fixture_works_after_the_ice ||= Work.create({
      title: "After The Ice",
      subtitle: "A Global Human History 20,000-5,000 BC",
      year_of_publication: 2003,
      language: "English",
      tags: ["Science", "Archaeology", "Prehistory", "History"],
      date_of_accession: Date.new(2010,8,1),
      accession_note: "Purchased, disposed of multiple times.",

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
  end

  def fixture_works_tintin_au_tibet
    @fixture_works_tintin_au_tibet ||= Work.create({
      supertitle: "Les Aventures De Tintin",
      title: "Tintin au Tibet",
      year_of_publication: 1960,
      language: "French",
      tags: ["Comics"],
      date_of_accession: Date.new(2024,8,1),
      accession_note: "Bought new from European Books online",

      publisher: fixture_publishers_casterman,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: fixture_producers_herge
        })
      ]
    })
  end

  # TODO: more detail
  def fixture_works_asterix_the_gaul
    @fixture_works_asterix_the_gaul ||= Work.create({
      title: "Asterix The Gaul",
      language: "English",
      original_language: "French",
      tags: ["Comics"],
      publishing_format: :book
    })
  end

  # TODO: more detail
  def fixture_works_asterix_le_gaulois
    @fixture_works_asterix_le_gaulois ||= Work.create({
      title: "Astérix Le Gaulois",
      language: "French",
      tags: ["Comics"],
      publishing_format: :book
    })
  end

  # using this work as example for incomplete information
  def fixture_works_asterix_in_egypt
    @fixture_works_asterix_in_egypt ||= Work.create({
      title: "Asterix in Egypt",
      language: "English",
      tags: ["Comics"],
      publishing_format: :book
    })
  end

  def fixture_works_meet_me_in_atlantis
    @fixture_works_meet_me_in_atlantis ||= Work.create({
      title: "Meet Me In Atlantis",
      subtitle: "Across Three Continents In Search Of The Legendary Sunken City",
      year_of_publication: 2015,
      rating: 3,
      language: "English",
      tags: ["Classics", "Mythology", "Atlantis"],

      publisher: Publisher.new({
        name: "Dutton"
      }),

      notes: [
        Note.new({
          text: "This was a fun read."
        })
      ],
   
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Mark Adams"
          })
        })
      ],

      reading_sessions: [
        ReadingSession.new({
          started_at: 1.year.ago,
          ended_at: (1.year.ago + 10.minutes),
          pages: 1
        })
      ]
    })
  end

  def fixture_producers_matthew_chrisman
    @fixture_producers_matthew_chrisman ||= Producer.create({
      full_name: "Matthew Chrisman"
    })
  end

  def fixture_producers_duncan_pritchard
    @fixture_producers_duncan_pritchard ||= Producer.create({
      full_name: "Duncan Pritchard"
    })
  end

  def fixture_producers_alisdair_richmond
    @fixture_producers_alisdair_richmond ||= Producer.create({
      full_name: "Alisdair Richmond"
    })
  end

  def fixture_works_philosophy_for_everyone
    @fixture_works_philosophy_for_everyone ||= Work.create({
      title: "Philosophy For Everyone",
      year_of_publication: 2017,
      language: "English",
      tags: ["Philosophy", "Modern"],
      date_of_accession: Date.new(2024,2,1),
      accession_note: "Bought direct from publisher for Coursera course.  Terrible customer service.",
  
      publisher: Publisher.new({
        name: "Routledge"
      }),
  
      children: [
        Work.new({
          title: "What is philosophy?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          publishing_format: :chapter,
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
          publishing_format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: fixture_producers_matthew_chrisman
            })
          ]
        }),
  
        Work.new({
          title: "Do we have an obligation to obey the law?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          publishing_format: :chapter,
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
          publishing_format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: fixture_producers_duncan_pritchard
            })
          ]
        }),
  
        Work.new({
          title: "Should you believe what you hear?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          publishing_format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: fixture_producers_matthew_chrisman
            }),
            WorkProducer.new({
              role: :author,
              producer: fixture_producers_duncan_pritchard
            }),
            WorkProducer.new({
              role: :author,
              producer: fixture_producers_alisdair_richmond
            }),
          ]
        }),
  
        Work.new({
          title: "What is it to have a mind?",
          language: "English",
          tags: ["Philosophy", "Modern"],
          publishing_format: :chapter,
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
          publishing_format: :chapter,
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
          publishing_format: :chapter,
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
          publishing_format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: fixture_producers_alisdair_richmond
            })
          ]
        }),
      ],
  
      work_producers: [
        WorkProducer.new({
          role: :editor,
          producer: fixture_producers_matthew_chrisman
        }),
        WorkProducer.new({
          role: :editor,
          producer: fixture_producers_duncan_pritchard
        })
      ],

      quotes: [
        Quote.new({
          page: 1,
          text: "Philosophy, philosophy, philosophy."
        })
      ]
    })
  end

  def fixture_publishers_penguin
    @fixture_publishers_penguin ||= Publisher.create({
      name: "Penguin Books"
    })
  end

  def fixture_works_meditations
    @fixture_works_meditations ||= Work.create({
      title: "Meditations",
      year_of_composition: 180,
      year_of_publication: 2006,
      language: "English",
      original_language: "Greek",
      publishing_format: :book,
      date_of_accession: Date.new(2024,4,1),
      accession_note: "bought new from Barnes & Noble",

      tags: ["Classics", "Philosophy", "Ancient Rome", "Stoicism", "Penguin Classics"],

      publisher: fixture_publishers_penguin,

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
  end

  def fixture_works_the_twelve_caesars
    @fixture_works_the_twelve_caesars ||= Work.create({
      title: "The Twelve Caesars",
      year_of_composition: 130,
      year_of_publication: 2007,
      language: "English",
      original_language: "Latin",
      publishing_format: :book,
      tags: ["Classics", "History", "Ancient Rome", "Penguin Classics"],
      date_of_accession: Date.new(2024,4,1),
      accession_note: "bought new from Barnes & Noble",

      publisher: fixture_publishers_penguin,

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
  end

  def fixture_works_discourses
    @fixture_works_discourses ||= Work.create({
      title: "Discourses",
      subtitle: "And Selected Writings",
      year_of_composition: 135,
      year_of_publication: 2008,
      language: "English",
      original_language: "Greek",
      publishing_format: :book,
      date_of_accession: Date.new(2024,5,1),
      accession_note: "bought new from Barnes & Noble",

      tags: ["Classics", "Philosophy", "Ancient Rome", "Stoicism", "Penguin Classics"],

      publisher: fixture_publishers_penguin,

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
  end

  def fixture_works_history_of_jazz
    @fixture_works_history_of_jazz ||= Work.create({
      title: "The History Of Jazz",
      subtitle: "Second Edition",
      year_of_publication: 2011,
      language: "English",
      tags: ["Musicology", "History"],
      date_of_accession: Date.new(2017,1,1),
      accession_note: "Bought new from Amazon",

      publisher: fixture_publishers_oup,

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Ted Gioia"
          })
        })
      ]
    })
  end
end