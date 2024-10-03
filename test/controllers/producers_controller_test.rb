require "test_helper"

class ProducersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # before each
  setup do
    sign_in users(:one)
  end

  teardown do
    sign_out users(:one)
  end

  test "should get index" do
    get producers_url
    assert_response :success
  end

  test "should get new" do
    get new_producer_url
    assert_response :success
  end

  test "should create producer" do
    assert_difference("Producer.count") do
      post producers_url, params: { producer: { custom_name: Faker::Name.name } }
    end

    assert_redirected_to producer_url(Producer.last)
  end

  test "should show producer" do
    get producer_url(fixture_producers_herge)
    assert_response :success
  end

  test "should get edit" do
    get edit_producer_url(fixture_producers_herge)
    assert_response :success
  end

  test "should update producer" do
    patch producer_url(fixture_producers_herge), params: { producer: { custom_name: Faker::Name.name } }
    assert_redirected_to producer_url(fixture_producers_herge)
  end

  test "should destroy producer" do
    subject = fixture_producers_herge
    target = producer_url(subject)

    assert_difference("Producer.count", -1) do
      delete target
    end

    assert_redirected_to producers_url
  end
end
