require "test_helper"

class ProducerFullNameTest < ActiveSupport::TestCase
  test "full_name virtual attribute getter" do
    # forename:, surname:
    subject1 = fixture_producers_graham_priest
    assert_equal "Graham Priest", subject1.full_name
  end

  test "full_name virtual attribute setter" do
    # full_name:
    subject1 = fixture_producers_paul_woodruff
    assert_equal "Paul", subject1.forename
    assert_equal "Woodruff", subject1.surname
  end

  test "where full name is only an exact match" do
    subject = fixture_producers_mark_twain
    result = Producer.where_full_name("Mark Twain")
    assert subject.in?(result)
  end

  test "order by full name" do
    subject1 = fixture_producers_mark_twain
    subject2 = fixture_producers_paul_woodruff
    result = Producer.order_by_full_name.ids
    assert result.index(subject1.id) < result.index(subject2.id)
  end

  test "where_full_name array arg" do
    subject1 = fixture_producers_mark_twain
    subject2 = fixture_producers_paul_woodruff
    subject3 = fixture_producers_peter_meineck

    result = Producer.where_full_name(["Mark Twain", "Paul Woodruff"])

    assert subject1.in?(result)
    assert subject2.in?(result)
    refute subject3.in?(result)
  end

  test "surname scopes" do
    _subject1 = fixture_producers_paul_woodruff
    _subject2 = fixture_producers_peter_meineck
    result = Producer.order_by_full_surname.pluck_full_surname
    expected = ["Meineck, Peter", "Woodruff, Paul"]
    assert_equal expected, result
  end
end

# TODO: more testing on these scopes

# irb(#<ProducerFullNameTest:0x0000...):003> Producer.pluck_full_name
# => ["Mark Twain", "Paul Woodruff", "Peter Meineck"]
# irb(#<ProducerFullNameTest:0x0000...):004> Producer.pluck_last_name
# => ["Mark Twain", "Woodruff", "Meineck"]
# irb(#<ProducerFullNameTest:0x0000...):005> Producer.pluck_alpha_name
# => ["Mark Twain", "Woodruff, Paul", "Meineck, Peter"]
# irb(#<ProducerFullNameTest:0x0000...):006> Producer.pluck_full_surname
# => ["Mark Twain", "Woodruff, Paul", "Meineck, Peter"]