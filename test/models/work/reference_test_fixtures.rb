module ReferenceTestFixtures
  def sophocles
    @sophocles ||= Producer.new({
      custom_name: "Sophocles",
      year_of_birth: -495,
      year_of_death: -405
    })
  end

  def theban_plays
    @theban_plays ||=  Work.create({
      title: "Theban Plays",
      year_of_composition: 135,
      year_of_publication: 2003,
      language: "English",
      original_language: "Greek",
      tags: ["Classics", "Tragedy", "Drama"],

      publisher: Publisher.new({
        name: "Hacket Publishing Company, Inc."
      }),

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
  end

  def logic_vsi
    @logic_vsi ||= Work.create({
      title: "Logic",
      subtitle: "A Very Short Introduction",
      year_of_publication: 2017,
      rating: 3,
      language: "English",
      tags: ["Philosophy", "Logic", "Oxford VSI"],

      publisher: Publisher.create({
        name: "Oxford University Press"
      }),

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Graham Priest"
          })
        })
      ]
    })
  end
end