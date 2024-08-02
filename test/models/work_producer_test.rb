require "test_helper"

class WorkProducerTest < ActiveSupport::TestCase
  test "role enum" do
    assert work_producers(:one).author?
    assert work_producers(:two).editor?
  end
end
