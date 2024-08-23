# == Schema Information
#
# Table name: reading_sessions
#
#  id         :bigint           not null, primary key
#  started_at :datetime
#  ended_at   :datetime
#  work_id    :bigint           not null
#  pages      :integer
#  duration   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
