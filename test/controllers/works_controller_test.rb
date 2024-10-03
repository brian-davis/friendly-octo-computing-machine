require "test_helper"

class WorksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # before each
  setup do
    sign_in users(:one)

    # refactor
    @work = fixture_works_history_of_jazz
    @reading_session = @work.reading_sessions.first
  end

  teardown do
    sign_out users(:one)
  end

  test "should get index" do
    get works_url
    assert_response :success
  end

  test "should get new" do
    get new_work_url
    assert_response :success
  end

  test "should create work" do
    assert_difference("Work.count") do
      post works_url, params: { work: { title: @work.title } }
    end

    assert_redirected_to work_url(Work.last)
  end

  test "should show work" do
    get work_url(@work)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_url(@work)
    assert_response :success
  end

  test "should update work" do
    patch work_url(@work), params: { work: { title: @work.title } }
    assert_redirected_to work_url(@work)
  end

  test "should destroy work" do
    assert_difference("Work.count", -1) do
      delete work_url(@work)
    end

    assert_redirected_to works_url
  end
end
