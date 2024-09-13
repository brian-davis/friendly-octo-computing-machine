# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint           not null
#
# Indexes
#
#  index_notes_on_work_id  (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#
class Note < ApplicationRecord
  belongs_to :work
end
