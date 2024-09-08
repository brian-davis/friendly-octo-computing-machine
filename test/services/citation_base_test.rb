require "test_helper"

class CitationBaseTest < ActiveSupport::TestCase
  def w1
    @w1 ||= begin
      w1 = Work.create({
        title: "Test Work",
        work_producers: [
          WorkProducer.new({
            role: :author,
            producer: producers(:nine)
          })
        ]
      })
      w1.authors << producers(:ten)
      w1
    end
  end

  def subject
    @subject ||= Citation::Base.new(w1)
  end

  test "producer_names" do
    expected = "Xilliam Xilliamson and Testy T. Testerson"
    assert_equal expected, subject.producer_names
  end

  test "producer_last_names" do
    expected = "Xilliamson and Testerson"
    assert_equal expected, subject.producer_last_names
  end

  test "alpha_producer_names" do
    expected = "Xilliamson, Xilliam, and Testy T. Testerson"
    assert_equal expected, subject.alpha_producer_names
  end
end