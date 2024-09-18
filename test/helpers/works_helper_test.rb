require "test_helper"
require_relative "../models/work/reference_test_fixtures"

class WorksHelperTest < ActiveSupport::TestCase
  include ApplicationHelper
  include WorksHelper
  include ActionView::Helpers::TagHelper
  include ReferenceTestFixtures

  test "byline includes various producers" do
    work = theban_plays
    result = byline(work)
    expected = "Meineck and Woodruff, 135 CE"
    assert_equal expected, result
  end

  test "byline includes relevant dates" do
    work = logic_vsi
    result = byline(work)
    expected = "Priest, 2017"
    assert_equal expected, result
  end

  test "full_title_line with date" do
    subject = logic_vsi
    result = full_title_line(subject)
    expected = "Logic: A Very Short Introduction (Priest, 2017)"
    assert_equal(expected, result)
  end

  test "full_title_line without date" do
    subject = Work.create({
      title: "No Date",
      producers: [
        Producer.new({
          full_name: "John Doe"
        })
      ]
    })
    result = full_title_line(subject)
    expected = "No Date (Doe)"
    assert_equal(expected, result)
  end

  test "full_title_line without author or date" do
    subject = Work.create({
      title: "No Date or Author"
    })
    result = full_title_line(subject)
    expected = "No Date or Author"
    assert_equal(expected, result)
  end
end