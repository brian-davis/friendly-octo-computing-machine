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
  end
end