require "test_helper"

class WorkProducerTest < ActiveSupport::TestCase
  test "role enum" do
    assert work_producers(:one).author?
    assert work_producers(:two).editor?
  end

  test "required references" do
    wp1 = WorkProducer.new(role: :author)
    refute wp1.valid?
    assert_equal ["Work must exist", "Producer must exist"], wp1.errors.full_messages
  end
end
