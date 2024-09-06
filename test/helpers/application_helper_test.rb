require "test_helper"

class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "common era span" do
    producer = producers(:seven)
    result = common_era_span(producer.year_of_birth, producer.year_of_death)
    expected = "(1599 - 1661)"
    assert_equal expected, result

    producer2 = producers(:eight)
    result = common_era_span(producer2.year_of_birth, producer2.year_of_death)
    expected = "(199 BCE - 51 BCE)"
    assert_equal expected, result

    producer3 = producers(:nine)
    result = common_era_span(producer3.year_of_birth, producer3.year_of_death)
    expected = "(50 BCE - 50 CE)"
    assert_equal expected, result

    producer4 = producers(:six)
    result = common_era_span(producer4.year_of_birth, producer4.year_of_death)
    expected = "(1980 - )"
    assert_equal expected, result
  end
end