require "test_helper"

class ReadingSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reading_session = reading_sessions(:one)
  end

  test "should get index" do
    get reading_sessions_url
    assert_response :success
  end

  test "should get new" do
    get new_reading_session_url
    assert_response :success
  end

  test "should create reading_session" do
    assert_difference("ReadingSession.count") do
      post reading_sessions_url, params: { reading_session: { ended_at: @reading_session.ended_at, pages: @reading_session.pages, started_at: @reading_session.started_at, work_id: @reading_session.work_id } }
    end

    assert_redirected_to reading_session_url(ReadingSession.last)
  end

  test "should show reading_session" do
    get reading_session_url(@reading_session)
    assert_response :success
  end

  test "should get edit" do
    get edit_reading_session_url(@reading_session)
    assert_response :success
  end

  test "should update reading_session" do
    patch reading_session_url(@reading_session), params: { reading_session: { ended_at: @reading_session.ended_at, pages: @reading_session.pages, started_at: @reading_session.started_at, work_id: @reading_session.work_id } }
    assert_redirected_to reading_session_url(@reading_session)
  end

  test "should destroy reading_session" do
    assert_difference("ReadingSession.count", -1) do
      delete reading_session_url(@reading_session)
    end

    assert_redirected_to reading_sessions_url
  end
end
