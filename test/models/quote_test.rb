require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  test "validates text" do
    q1 = works(:one).quotes.build({
      text: "",
      section: "1a",
      page: 1
    })
    refute q1.valid?
    assert_equal ["Text can't be blank"], q1.errors.full_messages
  end
end
