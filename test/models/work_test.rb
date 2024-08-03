require "test_helper"

class WorkTest < ActiveSupport::TestCase
  test "build a new work_producer and link to existing producer" do
    work1 = works(:one)
    producer1 = producers(:two)

    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            role: "translator",
            producer_id: producer1.id
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])

    refute work1.producers.include?(producer1)
    work1.update(params1)

    assert work1.producers.include?(producer1)
    assert_equal "translator", work1.work_producers.find_by(producer: producer1).role
  end

  test "remove existing work_producer" do
    work1 = works(:one)
    producer1 = producers(:one)
    assert work1.producers.include?(producer1) # fixture
    work_producer1 = work1.work_producers.find_by(producer: producer1)

    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            :id => work_producer1.id,
            :_destroy => true
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])

    work1.update(params1)
    refute work1.producers.include?(producer1)
    assert Producer.where(id: producer1.id).exists?
  end

  test "add similar work_producer" do
    work1 = works(:one)
    producer1 = producers(:one)
    assert work1.producers.include?(producer1) # fixture
    work_producer1 = work1.work_producers.find_by(producer: producer1)

    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            # no id
            role: "translator", # not author
            producer_id: producer1.id
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])

    work1.update(params1)
    assert_equal 2, work1.work_producers.where(producer_id: producer1.id).count
  end

  test "create a producer through work_producer" do
    work1 = works(:one)
    new_name_param = "ProducerThree"
    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            role: "editor",
            producer_attributes: { # only one
              name: new_name_param
            }
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])

    refute Producer.where(name: new_name_param).exists?
    work1.update(params1)
    assert Producer.where(name: new_name_param).exists?
    assert work1.producers.pluck(:name).include?(new_name_param)
  end

  test "validation on associated work_producer" do
    w1 = Work.new({
      title: "New Work",
      work_producers: [
        WorkProducer.new({
          role: :author
        })
      ]
    })

    refute w1.valid?
    assert_equal ["Work producers producer must exist"], w1.errors.full_messages
  end

  test "validation on associated producer" do
    w1 = Work.new({
      title: "New Work",
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            # empty
          })
        })
      ]
    })

    refute w1.valid?
    assert_equal ["Work producers producer name can't be blank"], w1.errors.full_messages
  end

  test "attribute validation" do
    w1 = Work.new({
      # empty
    })
    refute w1.valid?
    assert_equal ["Title can't be blank"], w1.errors.full_messages
  end
end
