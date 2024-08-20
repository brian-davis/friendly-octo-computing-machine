# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  text       :text
#  work_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Note < ApplicationRecord
  belongs_to :work
end
