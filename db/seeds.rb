Producer.destroy_all
Work.destroy_all

Work.create({
  title: "First Work",
  work_producers: [
    WorkProducer.new({
      role: :author,
      producer: Producer.new({
        name: "First Producer"
      })
    })
  ]
})