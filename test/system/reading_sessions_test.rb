require "application_system_test_case"

class ReadingSessionsTest < ApplicationSystemTestCase
  setup do
    @reading_session = reading_sessions(:one)
  end

  test "visiting the index" do
    visit reading_sessions_url
    assert_selector "h1", text: "Reading sessions"
  end

  test "should create reading session" do
    visit reading_sessions_url
    click_on "New reading session"

    fill_in "Ended at", with: @reading_session.ended_at
    fill_in "Pages", with: @reading_session.pages
    fill_in "Started at", with: @reading_session.started_at
    fill_in "Work", with: @reading_session.work_id
    click_on "Create Reading session"

    assert_text "Reading session was successfully created"
    click_on "Back"
  end

  test "should update Reading session" do
    visit reading_session_url(@reading_session)
    click_on "Edit this reading session", match: :first

    fill_in "Ended at", with: @reading_session.ended_at
    fill_in "Pages", with: @reading_session.pages
    fill_in "Started at", with: @reading_session.started_at
    fill_in "Work", with: @reading_session.work_id
    click_on "Update Reading session"

    assert_text "Reading session was successfully updated"
    click_on "Back"
  end

  test "should destroy Reading session" do
    visit reading_session_url(@reading_session)
    click_on "Destroy this reading session", match: :first

    assert_text "Reading session was successfully destroyed"
  end
end
