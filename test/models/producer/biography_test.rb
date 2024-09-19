require "test_helper"

class Producer::BiographyTest < ActiveSupport::TestCase
  setup do
    # @producer = producers(:TODO_fixture_name)
    # @biography = @producer.biography
  end

  test "context" do
    producer = producers(:six)
    result = producer.biography.context
    expected = "American, 1980 — "
    assert_equal(expected, result)
  end
end