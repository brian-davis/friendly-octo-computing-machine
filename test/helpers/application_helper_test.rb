require "test_helper"

class ApplicationHelperTest < ActiveSupport::TestCase
  # these dependencies will be already loaded in development, production
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Context

  include ApplicationHelper

  test ":markdown_render renders markdown" do
    result = markdown_render("something **bold**")
    expected = "<p>something <strong>bold</strong></p>"
    assert_equal(expected, result)
  end

  test ":pipe_spacer" do
    result = pipe_spacer
    expected = "<span class=\"horizontal-spacer\"></span>"
    assert_equal expected, result
  end

  test ":pointer_link" do
    result = pointer_link("/foobar")
    expected = "<a class=\"index-link\" href=\"/foobar\">👉</a>"
    assert_equal expected, result
  end

  test ":strict_options" do
    arg = [["abraham_lincoln", 1], ["Calvin Coolidge", 2], ["", 3], ["", 4], ["Ronald Reagan Reagan REAGAN", 5]]

    result = strict_options(arg)
    expected = [["Abraham Lincoln", 1], ["Calvin Coolidge", 2], ["Ronald Reagan Reagan R...", 5]]
    assert_equal expected, result
  end

  test ":strict_datalist_options" do
    arg = ["abraham_lincoln","","","Ronald Reagan Reagan REAGAN", "Calvin Coolidge"]

    result = strict_datalist_options(arg)
    expected = ["abraham_lincoln","Calvin Coolidge","Ronald Reagan Reagan REAGAN"]
    assert_equal expected, result
  end

  test ":render_datalist_options" do
    arg1 = ["abraham_lincoln","","","Ronald Reagan Reagan REAGAN", "Calvin Coolidge"]
    arg2 = strict_datalist_options(arg1)
    result = render_datalist_options({
      list: "a_datalist_id",
      select_options: arg2
    })
    expected = "<datalist id=\"a_datalist_id\" data-autocomplete-input-target=\"datalist\"><option value=\"abraham_lincoln\" data-autocomplete-input-target=\"datalistOption\"></option><option value=\"Calvin Coolidge\" data-autocomplete-input-target=\"datalistOption\"></option><option value=\"Ronald Reagan Reagan REAGAN\" data-autocomplete-input-target=\"datalistOption\"></option></datalist>"
    assert_equal expected, result
  end
end