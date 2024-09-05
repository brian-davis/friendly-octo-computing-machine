require "test_helper"

class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "common era span" do
    producer = producers(:seven)
    result = common_era_span(producer.birth_year, producer.death_year)
    expected = "(1599 - 1661)"
    assert_equal expected, result

    producer2 = producers(:eight)
    result = common_era_span(producer2.birth_year, producer2.death_year)
    expected = "(199 BCE - 51 BCE)"
    assert_equal expected, result

    producer3 = producers(:nine)
    result = common_era_span(producer3.birth_year, producer3.death_year)
    expected = "(50 BCE - 50 CE)"
    assert_equal expected, result

    producer4 = producers(:six)
    result = common_era_span(producer4.birth_year, producer4.death_year)
    expected = "(1980 - )"
    assert_equal expected, result
  end
end