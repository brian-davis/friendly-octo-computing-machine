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
class ReadingSession < ApplicationRecord
  belongs_to :work

  validates :started_at, presence: true
  validates :ended_at, presence: true

  before_save :set_duration

private

  def set_duration
    _duration = ((ended_at - started_at) / 60).to_i
    self.duration = _duration
  end
end
