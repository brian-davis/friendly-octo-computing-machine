require "test_helper"

class ApplicationHelperTest < ActiveSupport::TestCase
  # these dependencies will be already loaded in development, production
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper

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
end