# == Schema Information
#
# Table name: producers
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Producer < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :work_producers, allow_destroy: true
  validates :name, presence: true
end
