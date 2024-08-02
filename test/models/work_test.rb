require "test_helper"

class WorkTest < ActiveSupport::TestCase
  # test "building associated models" do
  #   # part 1
  #   params1 = ActionController::Parameters.new({
  #     work: {
  #       title: "Work1",
  #       producers_attributes: {
  #         "0" => {
  #           name: "Producer1" # new
  #         }
  #       }
  #     }
  #   }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])
  #   new_work = Work.create(params1)
  #   assert new_work.persisted?
  #   assert_equal 1, new_work.work_producers.count
  #   assert_equal 1, new_work.producers.count
  #   producer1 = new_work.producers.first
  #   assert_equal "Producer1", producer1.name
  #   assert_equal 1, Producer.where(name: "Producer1").count

  #   # part 2
  #   params2 = ActionController::Parameters.new({
  #     work: {
  #       title: "Work1",
  #       producers_attributes: {
  #         "0" => {
  #           id: producer1.id, # ignore
  #           name: producer1.name
  #         },
  #         "1" => {
  #           name: "Producer2" # new
  #         }
  #       }
  #     }
  #   }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

  #   new_work.update(params2)

  #   assert_equal 2, new_work.work_producers.count
  #   assert_equal 2, new_work.producers.count
  #   assert_equal "Producer2", new_work.producers.second.name
  #   assert_equal 1, Producer.where(name: "Producer1").count
  #   assert_equal 1, Producer.where(name: "Producer2").count
  # end

  # test "attaching existing associated models by id" do
  #   # no existing .work_producer
  #   existing_producer = Producer.create(name: "existing")

  #   params = ActionController::Parameters.new({
  #     work: {
  #       title: "Work1",
  #       producers_attributes: {
  #         "0" => {
  #           id: existing_producer.id,
  #           "name" => existing_producer.name,
  #         },
  #         "1" => {
  #           name: "Producer2" # new
  #         }
  #       }
  #     }
  #   }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

  #   new_work = Work.create(params)

  #   assert_equal 2, new_work.work_producers.count
  #   assert_equal 2, new_work.producers.count
  #   assert_equal "existing", new_work.producers.first.name
  #   assert_equal "Producer2", new_work.producers.second.name

  #   assert_equal 1, Producer.where(name: "existing").count
  #   assert_equal 1, Producer.where(name: "Producer2").count
  # end

  # test "building and destroying associated models" do
  #   # part 1
  #   params1 = ActionController::Parameters.new({
  #     work: {
  #       title: "Work1",
  #       producers_attributes: {
  #         "0" => {
  #           name: "Producer1" # new
  #         }
  #       }
  #     }
  #   }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])
  #   new_work = Work.create(params1)

  #   producer1 = new_work.producers.find_by(name: "Producer1")

  #   # part 2
  #   params2 = ActionController::Parameters.new({
  #     work: {
  #       title: "Work1",
  #       producers_attributes: {
  #         "0" => {
  #           id: producer1.id,
  #           name: producer1.name # ignore
  #         },
  #         "1" => {
  #           name: "Producer2" # new
  #         }
  #       }
  #     }
  #   }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

  #   new_work.update(params2)

  #   producer2 = new_work.producers.find_by(name: "Producer2")

  #   # part 3
  #   params3 = ActionController::Parameters.new({
  #     work: {
  #       title: "Work1",
  #       producers_attributes: {
  #         "0" => {
  #           "id" => producer1.id,
  #           "name" => producer1.name,
  #           "_destroy" => "1"
  #         },
  #         "1" => {
  #           id: producer2.id, # ignore
  #           "name" => producer2.name,
  #         },
  #         "2" => {
  #           name: "Producer3" # new
  #         }
  #       }
  #     }
  #   }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

  #   new_work.update(params3)

  #   assert_equal 2, new_work.work_producers.count
  #   assert_equal 2, new_work.producers.count
  #   assert_equal ["Producer2", "Producer3"], new_work.producers.pluck(:name).sort
  #   assert_equal 1, Producer.where(name: "Producer1").count # producer record not destroyed
  #   assert_equal 1, Producer.where(name: "Producer2").count
  #   assert_equal 1, Producer.where(name: "Producer3").count
  # end

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
end
