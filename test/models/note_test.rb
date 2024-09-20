# == Schema Information
#
# Table name: notes
#
#  id           :bigint           not null, primary key
#  notable_type :string           not null
#  text         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notable_id   :bigint           not null
#
# Indexes
#
#  index_notes_on_notable  (notable_type,notable_id)
#
require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "polymorphic to Work" do
    subject = fixture_works_meet_me_in_atlantis # save it
    note = subject.notes.first
    assert note.is_a?(Note)
    assert_equal subject, note.notable
  end

  test "polymorphic to Producer" do
    subject = fixture_producers_peter_meineck # save it
    note = subject.notes.first
    assert note.is_a?(Note)
    assert_equal subject, note.notable
  end
end
