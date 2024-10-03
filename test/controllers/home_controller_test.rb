require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # before each
  setup do
    sign_in users(:one)
  end

  teardown do
    sign_out users(:one)
  end

  test "should get index" do
    get home_index_url
    assert_response :success
  end
end
