# == Schema Information
#
# Table name: reading_sessions
#
#  id         :bigint           not null, primary key
#  duration   :integer
#  ended_at   :datetime
#  pages      :integer
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint           not null
#
# Indexes
#
#  index_reading_sessions_on_work_id  (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#
require "test_helper"

class ReadingSessionTest < ActiveSupport::TestCase
  test "validation" do
    r = ReadingSession.new()
    refute r.valid?
    expected = [
      "Work must exist",
      "Started at can't be blank",
      "Ended at can't be blank"
    ]
    assert_equal expected, r.errors.full_messages
  end

  test "duration" do
    work = Work.create({ title: "aggregate counter" })

    _baseline = 1.year.ago

    rs1 = work.reading_sessions.create({
      pages: 10,
      started_at: _baseline,
      ended_at: _baseline + 10.minutes
    })

    assert_equal(10, rs1.duration)
  end
end
