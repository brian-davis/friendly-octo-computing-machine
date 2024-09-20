require "test_helper"

class QuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work = fixture_works_philosophy_for_everyone
    @quote = @work.quotes.first
  end

  test "should get index" do
    get work_quotes_url(@work)
    assert_response :success
  end

  test "should get new" do
    get new_work_quote_url(@work)
    assert_response :success
  end

  test "should create quote" do
    assert_difference("Quote.count") do
      post work_quotes_url(work_id: @work.id), params: { quote: { text: "new quote" } }
    end
    @work.reload
    quote = @work.quotes.last
    assert_redirected_to work_quote_url(@work, quote)
  end

  test "should show quote" do
    get work_quote_url(work_id: @work.id, id: @quote.id)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_quote_url(work_id: @work.id, id: @quote.id)
    assert_response :success
  end

  test "should update quote" do
    patch work_quote_url(work_id: @work.id, id: @quote.id), params: { quote: { text: "new text" } }
    assert_redirected_to work_quote_url(@work, @quote)
  end

  test "should destroy quote" do
    assert_difference("Quote.count", -1) do
      delete work_quote_url(work_id: @work.id, id: @quote.id)
    end

    assert_redirected_to work_quotes_url(work_id: @work.id)
  end
end
