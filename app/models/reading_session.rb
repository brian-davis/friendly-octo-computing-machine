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
