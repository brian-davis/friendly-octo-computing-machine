require "test_helper"

class NotesHelperTest < ActiveSupport::TestCase
  # these dependencies will be already loaded in development, production
  include ActionView::Helpers::UrlHelper
  include NotesHelper

  test ":notable_new_note_path for work" do
    subject = fixture_works_the_baltic_origins
    result = notable_new_note_path(subject)
    expected = "/works/#{subject.id}/notes/new"
    assert_equal expected, result
  end

  test ":notable_new_note_path for producer" do
    subject = fixture_producers_herge
    result = notable_new_note_path(subject)
    expected = "/producers/#{subject.id}/notes/new"
    assert_equal expected, result
  end

  test ":notable_notes_path for work" do
    subject = fixture_works_the_baltic_origins
    result = notable_notes_path(subject)
    expected = "/works/#{subject.id}/notes"
    assert_equal expected, result
  end

  test ":notable_notes_path for producer" do
    subject = fixture_producers_herge
    result = notable_notes_path(subject)
    expected = "/producers/#{subject.id}/notes"
    assert_equal expected, result
  end

  test ":notable_edit_note_path for work" do
    subject = fixture_works_the_baltic_origins
    nsubject = subject.notes.first
    result = notable_edit_note_path([subject, nsubject])
    expected = "/works/#{subject.id}/notes/#{nsubject.id}/edit"
    assert_equal expected, result
  end

  test ":notable_edit_note_path for producer" do
    subject = fixture_producers_herge
    nsubject = subject.notes.first
    result = notable_edit_note_path([subject, nsubject])
    expected = "/producers/#{subject.id}/notes/#{nsubject.id}/edit"
    assert_equal expected, result
  end
end