require "test_helper"

class ProducerFullNameTest < ActiveSupport::TestCase
  test "full_name virtual attribute getter" do
    subject1 = producers(:four)
    assert_equal "Samuel Clemens", subject1.full_name

    subject2 = Producer.new({
      given_name: "Joe",
      family_name: "Shmo"
    })
    assert_equal "Joe Shmo", subject2.full_name

    subject3 = Producer.new()
    subject3.given_name = "Joe2"
    subject3.family_name = "Shmo2"

    assert_equal "Joe2 Shmo2", subject3.full_name
  end

  test "full_name virtual attribute setter" do
    subject1 = Producer.new({
      full_name: "Joe Shmo"
    })

    assert_equal "Joe", subject1.given_name
    assert_equal "Shmo", subject1.family_name

    subject2 = Producer.new()
    subject2.full_name = "Joe2 Shmo2"
    assert_equal "Joe2", subject2.given_name
    assert_equal "Shmo2", subject2.family_name
  end

  test "where full name" do
    result = Producer.where_full_name(["Mark Twain", "Samuel Clemens"]).map(&:full_name)
    assert "Samuel Clemens".in?(result)
    assert "Mark Twain".in?(result)
  end

  test "order by full name" do
    expected = ["Mark Twain", "Samuel Clemens"]
    result = Producer.where_full_name(["Mark Twain", "Samuel Clemens"]).order_by_full_name.pluck_full_name

    assert_equal expected, result
  end

  test "where_full_nam single arg" do
    assert Producer.where_full_name("Mark Twain").any?
  end

  test "order by last name" do
    expected = ["Clemens, Samuel", "Twain, Mark"]
    result = Producer.where_full_name(["Mark Twain", "Samuel Clemens"]).order_by_full_surname.pluck_full_surname
    assert_equal expected, result
  end

  test "order by full name desc" do
    expected = ["Samuel Clemens", "Mark Twain"]
    result = Producer.where_full_name(["Mark Twain", "Samuel Clemens"]).order_by_full_name({ full_name: :desc }).pluck_full_name

    assert_equal expected, result
  end

  test "order by full name desc with second column" do
    # works_count overrides name
    expected = ["Mark Twain", "Samuel Clemens"]
    result = Producer.where_full_name(["Mark Twain", "Samuel Clemens"]).order_by_full_name({ works_count: :desc, full_name: :desc }).pluck_full_name

    assert_equal expected, result
  end

  test "order works with joins" do
    w = works(:one)
    result = w.producers.order_by_full_name.pluck_full_name
    assert_equal(result, result.sort)
  end

  test "order works with joins and merge" do
    w = works(:one)

    # DEBUG:
    # joins works, .include doesn't
    result = w.work_producers.joins(:producer).merge(Producer.order_by_full_name).to_a
    assert result.first.producer.is_a?(Producer)
  end
end