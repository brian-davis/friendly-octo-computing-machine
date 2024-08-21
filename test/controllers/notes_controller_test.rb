require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note = notes(:one)
    @work = @note.work
  end

  test "should get index" do
    get work_notes_url(@work)
    assert_response :success
  end

  test "should get new" do
    get new_work_note_url(@work)
    assert_response :success
  end

  test "should create note" do
    assert_difference("Note.count") do
      post work_notes_url(@work), params: { note: { text: @note.text } }
    end

    note = @work.notes.last
    assert_redirected_to work_note_url(@work, note)
  end

  test "should show note" do
    get work_note_url(@work, @note)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_note_url(@work, @note)
    assert_response :success
  end

  test "should update note" do
    patch work_note_url(@work, @note), params: { note: { text: @note.text } }
    assert_redirected_to work_note_url(@work, @note)
  end

  test "should destroy note" do
    assert_difference("Note.count", -1) do
      delete work_note_url(@work, @note)
    end

    assert_redirected_to work_notes_url(@work)
  end
end
