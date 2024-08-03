class Producer < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :works

  validates :name, presence: true
end
