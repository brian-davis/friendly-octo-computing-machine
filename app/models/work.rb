class Work < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :producers, through: :work_producers

  accepts_nested_attributes_for :work_producers, allow_destroy: true

  validates :title, presence: true
end