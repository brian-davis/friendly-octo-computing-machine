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
    assert_equal "Producer1", new_work.producers.first.name
    assert_equal 1, Producer.where(name: "Producer1").count

    # part 2
    params2 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            name: "Producer1" # ignore
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

    # part 3, redundant test
    params3 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            name: "Producer1" # ignore
          },
          "1" => {
            name: "Producer2" # ignore
          },
          "2" => {
            name: "Producer3" # new
          }
        }
      }
    }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

    new_work.update(params3)

    assert_equal 3, new_work.work_producers.count
    assert_equal 3, new_work.producers.count
    assert_equal "Producer3", new_work.producers.third.name
    assert_equal 1, Producer.where(name: "Producer1").count
    assert_equal 1, Producer.where(name: "Producer2").count
    assert_equal 1, Producer.where(name: "Producer3").count
  end

  test "attaching existing associated models" do
    # part 1
    existing_producer = Producer.create(name: "existing")

    params = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            name: existing_producer.name # TODO: use id
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

    # part 2
    params2 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            name: "Producer1" # ignore
          },
          "1" => {
            name: "Producer2" # new
          }
        }
      }
    }).require(:work).permit(:name, producers_attributes: [:name, :id, :_destroy])

    new_work.update(params2)

    # part 3
    params3 = ActionController::Parameters.new({
      work: {
        title: "Work1",
        producers_attributes: {
          "0" => {
            "id" => Producer.find_by(name: "Producer1").id.to_s,
            "_destroy" => "1"
          },
          "1" => {
            name: "Producer2" # ignore
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
