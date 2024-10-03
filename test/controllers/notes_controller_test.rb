require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # before each
  setup do
    sign_in users(:one)

    # refactor
    @work = fixture_works_the_baltic_origins
    @wnote = @work.notes.first 
    @producer = fixture_producers_herge
    @pnote = @producer.notes.first
  end

  teardown do
    sign_out users(:one)
  end

  test "should get index work" do
    get work_notes_url(@work)
    assert_response :success
  end

  test "should get index producer" do
    get producer_notes_url(@producer)
    assert_response :success
  end

  test "should get new work" do
    get new_work_note_url(@work)
    assert_response :success
  end

  test "should get new producer" do
    get new_producer_note_url(@producer)
    assert_response :success
  end

  test "should create note work" do
    assert_difference("Note.count") do
      post work_notes_url(@work), params: { note: { text: @wnote.text } }
    end
    @work.reload
    note = @work.notes.last
    assert_redirected_to work_note_url(@work, note)
  end

  test "should create note producer" do
    new_text_value = "NEW NOTE TEXT"
    assert_difference("Note.count") do
      post producer_notes_url(@producer), params: { note: { text: new_text_value } }
    end
    @producer.reload
    note = @producer.notes.last
    assert_equal new_text_value, note.text
    assert_redirected_to producer_note_url(@producer, note)
  end

  test "should show note work" do
    get work_note_url(@work, @wnote)
    assert_response :success
  end

  test "should show note producer" do
    get producer_note_url(@producer, @pnote)
    assert_response :success
  end

  test "should get edit work" do
    get edit_work_note_url(@work, @wnote)
    assert_response :success
  end

  test "should get edit producer" do
    get edit_producer_note_url(@producer, @pnote)
    assert_response :success
  end

  test "should update note work" do
    patch work_note_url(@work, @wnote), params: { note: { text: @wnote.text } }
    assert_redirected_to work_note_url(@work, @wnote)
  end

  test "should update note producer" do
    patch producer_note_url(@producer, @pnote), params: { note: { text: @pnote.text } }
    assert_redirected_to producer_note_url(@producer, @pnote)
  end

  test "should destroy note work" do
    assert_difference("Note.count", -1) do
      delete work_note_url(@work, @wnote)
    end
    assert_redirected_to work_notes_url(@work)
  end

  test "should destroy note producer" do
    assert_difference("Note.count", -1) do
      delete producer_note_url(@producer, @pnote)
    end
    assert_redirected_to producer_notes_url(@producer)
  end
end
