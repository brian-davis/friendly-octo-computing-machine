require "test_helper"

class  BookshelfMetricsTest < ActiveSupport::TestCase
  test "summary return object is an array of hashes" do
    result = BookshelfMetrics.summary
    assert result.is_a?(Array)
    assert(result.all? { |el| el.is_a?(Hash) })
    assert(result.all? { |el| el.key?(:label) && el.key?(:result) })
  end

  test "wishlist items are not included in metrics" do
    p1 = Producer.create({
      full_name: "Mark Twain"
    })
    pb1 = Publisher.create(name: "Penguin")
    Work.create({
      title: "one",
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: p1
        })
      ],
      publisher: pb1
    })
    Work.create({
      title: "two",
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: p1
        })
      ],
      publisher: pb1
    })
    Work.create({
      title: "three",
      wishlist: true,
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: p1
        })
      ],
      publisher: pb1
    })
    Work.create({
      title: "four",
      wishlist: true,
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "William Shakespeare"
          })
        })
      ],
      publisher: Publisher.new({
        name: "Doubleday"
      })
    })
    result = BookshelfMetrics.summary
    assert_equal 2, result.detect { |e| e[:label] == "Total Books" }[:result]  
    assert_equal 1, result.detect { |e| e[:label] == "Total Authors" }[:result]
    assert_equal 1, result.detect { |e| e[:label] == "Total Publishers" }[:result]
    
    assert_equal "Mark Twain, 2 works", result.detect { |e| e[:label] == "Top Author" }[:result]
    assert_equal "Penguin, 2 works", result.detect { |e| e[:label] == "Top Publisher" }[:result]
  end
end