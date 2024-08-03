require "test_helper"

class ProducerTest < ActiveSupport::TestCase
  test "attribute validation" do
    pr1 = Producer.new({
      # empty
    })
    refute pr1.valid?
    assert_equal ["Name can't be blank"], pr1.errors.full_messages
  end
end
