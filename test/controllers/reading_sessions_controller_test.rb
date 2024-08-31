require "test_helper"

class ReadingSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work = works(:one)
    @reading_session = reading_sessions(:one) # references @work
  end

  test "should get index" do
    get work_reading_sessions_url(@work)
    assert_response :success
  end

  test "should get new" do
    get new_work_reading_session_url(@work)
    assert_response :success
  end

  test "should create reading_session" do
    assert_difference("ReadingSession.count") do
      post work_reading_sessions_url(@work), params: { reading_session: { ended_at: @reading_session.ended_at, pages: @reading_session.pages, started_at: @reading_session.started_at, work_id: @reading_session.work_id } }
    end

    assert_redirected_to work_reading_session_url(@work, ReadingSession.last)
  end

  test "should show reading_session" do
    get work_reading_session_url(@work, @reading_session)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_reading_session_url(@work, @reading_session)
    assert_response :success
  end

  test "should update reading_session" do
    patch work_reading_session_url(@work, @reading_session), params: { reading_session: { ended_at: @reading_session.ended_at, pages: @reading_session.pages, started_at: @reading_session.started_at, work_id: @reading_session.work_id } }
    assert_redirected_to work_reading_session_url(@work, @reading_session)
  end

  test "should destroy reading_session" do
    assert_difference("ReadingSession.count", -1) do
      delete work_reading_session_url(@work, @reading_session)
    end

    assert_redirected_to work_reading_sessions_url(@work)
  end
end
