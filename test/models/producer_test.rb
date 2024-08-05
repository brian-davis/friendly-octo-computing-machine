require "test_helper"

class ProducerTest < ActiveSupport::TestCase
  test "attribute validation" do
    pr1 = Producer.new({
      # empty
    })
    refute pr1.valid?
    assert_equal ["Name can't be blank"], pr1.errors.full_messages
    pr1.name = ""
    refute pr1.valid?
    assert_equal ["Name can't be blank"], pr1.errors.full_messagesa
  end

  test "build a new work_producer and link to existing work" do
    producer = producers(:one)
    work = works(:two)

    params1 = ActionController::Parameters.new({
      producer: {
        name: producer.name,
        work_producers_attributes: {
          "0" => {
            role: "translator",
            work_id: work.id
          }
        }
      }
    }).require(:producer).permit(:name, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :work_id,
      work_attributes: [:title]
    ])

    refute producer.works.include?(work)
    producer.update(params1)

    assert producer.works.include?(work)
    assert_equal "translator", producer.work_producers.find_by(work: work).role
  end

  test "remove existing work_producer" do
    producer = producers(:one)
    work = works(:one)

    assert producer.works.include?(work) # fixture
    work_producer = producer.work_producers.find_by(work: work)

    params = ActionController::Parameters.new({
      producer: {
        name: producer.name,
        work_producers_attributes: {
          "0" => {
            :id => work_producer.id,
            :_destroy => true
          }
        }
      }
    }).require(:producer).permit(:name, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :work_id,
      work_attributes: [:title]
    ])

    producer.update(params)
    refute producer.works.include?(work)
    assert Work.where(id: work.id).exists?
  end

  test "add similar work_producer" do
    producer = producers(:one)
    work = works(:one)
    assert producer.works.include?(work) # fixture
    work_producer = producer.work_producers.find_by(work: work)

    params = ActionController::Parameters.new({
      producer: {
        name: producer.name,
        work_producers_attributes: {
          "0" => {
            # no id
            role: "translator", # not author
            work_id: work.id
          }
        }
      }
    }).require(:producer).permit(:name, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :work_id,
      work_attributes: [:title]
    ])

    producer.update(params)
    assert_equal 2, producer.work_producers.where(work_id: work.id).count
  end

  test "create a work through work_producer" do
    producer = producers(:one)
    new_title_param = "New Work"
    params = ActionController::Parameters.new({
      producer: {
        name: producer.name,
        work_producers_attributes: {
          "0" => {
            role: "editor",
            work_attributes: { # only one
              title: new_title_param
            }
          }
        }
      }
    }).require(:producer).permit(:name, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :work_id,
      work_attributes: [:title]
    ])

    refute Work.where(title: new_title_param).exists?
    producer.update(params)
    assert Work.where(title: new_title_param).exists?
    assert producer.works.pluck(:title).include?(new_title_param)
  end

  test "validation on associated work_producer" do
    p1 = Producer.new({
      name: "New Producer",
      work_producers: [
        WorkProducer.new({
          role: :author
        })
      ]
    })

    refute p1.valid?
    assert_equal ["Work producers work must exist"], p1.errors.full_messages
  end

  test "validation on associated work" do
    p1 = Producer.new({
      name: "New Producer",
      work_producers: [
        WorkProducer.new({
          role: :author,
          work: Work.new({
            # empty
          })
        })
      ]
    })

    refute p1.valid?
    assert_equal ["Work producers work title can't be blank"], p1.errors.full_messages
  end
end