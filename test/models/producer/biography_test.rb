require "test_helper"

class Producer::BiographyTest < ActiveSupport::TestCase
  test "context with no year_of_death" do
    producer = fixture_producers_john_searle
    result = producer.biography.context
    expected = "American, 1932 — "
    assert_equal(expected, result)
  end

  # TODO: more testing
end