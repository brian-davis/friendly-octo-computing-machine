require "test_helper"

class WorkTest < ActiveSupport::TestCase
  test "building associated models" do
    # part 1
    params1 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            name: "Producer1" # new
          }
        }
      }
    }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])
    new_work = Work.create(params1)
    assert new_work.persisted?
    assert_equal 1, new_work.work_producers.count
    assert_equal 1, new_work.producers.count
    producer1 = new_work.producers.first
    assert_equal "Producer1", producer1.name
    assert_equal 1, Producer.where(name: "Producer1").count

    # part 2
    params2 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            id: producer1.id, # ignore
            name: producer1.name
          },
          "1" => {
            name: "Producer2" # new
          }
        }
      }
    }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

    new_work.update(params2)

    assert_equal 2, new_work.work_producers.count
    assert_equal 2, new_work.producers.count
    assert_equal "Producer2", new_work.producers.second.name
    assert_equal 1, Producer.where(name: "Producer1").count
    assert_equal 1, Producer.where(name: "Producer2").count
  end

  test "attaching existing associated models by id" do
    # no existing .work_producer
    existing_producer = Producer.create(name: "existing")

    params = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            id: existing_producer.id,
            "name" => existing_producer.name,
          },
          "1" => {
            name: "Producer2" # new
          }
        }
      }
    }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

    new_work = Work.create(params)

    assert_equal 2, new_work.work_producers.count
    assert_equal 2, new_work.producers.count
    assert_equal "existing", new_work.producers.first.name
    assert_equal "Producer2", new_work.producers.second.name

    assert_equal 1, Producer.where(name: "existing").count
    assert_equal 1, Producer.where(name: "Producer2").count
  end

  test "building and destroying associated models" do
    # part 1
    params1 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            name: "Producer1" # new
          }
        }
      }
    }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])
    new_work = Work.create(params1)

    producer1 = new_work.producers.find_by(name: "Producer1")

    # part 2
    params2 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            id: producer1.id,
            name: producer1.name # ignore
          },
          "1" => {
            name: "Producer2" # new
          }
        }
      }
    }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

    new_work.update(params2)

    producer2 = new_work.producers.find_by(name: "Producer2")

    # part 3
    params3 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            "id" => producer1.id,
            "name" => producer1.name,
            "_destroy" => "1"
          },
          "1" => {
            id: producer2.id, # ignore
            "name" => producer2.name,
          },
          "2" => {
            name: "Producer3" # new
          }
        }
      }
    }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

    new_work.update(params3)

    assert_equal 2, new_work.work_producers.count
    assert_equal 2, new_work.producers.count
    assert_equal ["Producer2", "Producer3"], new_work.producers.pluck(:name).sort
    assert_equal 1, Producer.where(name: "Producer1").count # producer record not destroyed
    assert_equal 1, Producer.where(name: "Producer2").count
    assert_equal 1, Producer.where(name: "Producer3").count
  end
end
