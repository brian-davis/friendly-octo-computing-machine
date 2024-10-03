require "test_helper"

class PublishersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # before each
  setup do
    sign_in users(:one)

    # refactor
    @publisher = fixture_publishers_penguin
  end

  teardown do
    sign_out users(:one)
  end

  test "should get index" do
    get publishers_url
    assert_response :success
  end

  test "should get new" do
    get new_publisher_url
    assert_response :success
  end

  test "should create publisher" do
    assert_difference("Publisher.count") do
      post publishers_url, params: { publisher: { name: Faker::Company.name } }
    end

    assert_redirected_to publisher_url(Publisher.last)
  end

  test "should show publisher" do
    get publisher_url(@publisher)
    assert_response :success
  end

  test "should get edit" do
    get edit_publisher_url(@publisher)
    assert_response :success
  end

  test "should update publisher" do
    patch publisher_url(@publisher), params: { publisher: { name: @publisher.name } }
    assert_redirected_to publisher_url(@publisher)
  end

  test "should destroy publisher" do
    assert_difference("Publisher.count", -1) do
      delete publisher_url(@publisher)
    end

    assert_redirected_to publishers_url
  end
end
