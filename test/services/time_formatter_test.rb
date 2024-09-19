require "test_helper"

class BaseTest < ActiveSupport::TestCase
  include TimeFormatter

  test "common_era_year CE or BC" do
    assert_equal("1000 CE", common_era_year(1000))
    assert_equal("1066", common_era_year(1066))
    assert_equal("1200 BCE", common_era_year(-1200))

    assert_equal("1000CE", common_era_year(1000, spaces: false))
    assert_equal("1066", common_era_year(1066, spaces: false))
    assert_equal("1200BCE", common_era_year(-1200, spaces: false))

    assert_equal("1000 C.E.", common_era_year(1000, periods: true))
    assert_equal("1066", common_era_year(1066, periods: true))
    assert_equal("1200 B.C.E.", common_era_year(-1200, periods: true))

    assert_equal("1000 CE", common_era_year(1000, scheme: :ce))
    assert_equal("1066", common_era_year(1066, scheme: :ce))
    assert_equal("1200 BCE", common_era_year(-1200, scheme: :ce))

    assert_equal("1000 AD", common_era_year(1000, scheme: :bc))
    assert_equal("1066", common_era_year(1066, scheme: :bc))
    assert_equal("1200 BC", common_era_year(-1200, scheme: :bc))
  end

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

    result = common_era_span(producer3.year_of_birth, producer3.year_of_death, { scheme: :bc })
    expected = "(50 BC - 50 AD)"
    assert_equal expected, result

    result = common_era_span(producer3.year_of_birth, producer3.year_of_death, { scheme: :bc, spaces: false })
    expected = "(50BC-50AD)"
    assert_equal expected, result
  
    producer4 = producers(:six)
    result = common_era_span(producer4.year_of_birth, producer4.year_of_death)
    expected = "(1980 - )"
    assert_equal expected, result
  end

  test ":human_duration expects minutes precision" do
    result = human_duration(10)
    expected = "10 minutes"
    assert_equal(expected, result)

    result = human_duration(100)
    expected = "about 2 hours"
    assert_equal(expected, result)

    result = human_duration(10000)
    expected = "7 days"
    assert_equal(expected, result)
  end
end