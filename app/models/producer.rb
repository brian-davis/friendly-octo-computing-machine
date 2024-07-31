class Producer < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :works

  # def works_attributes=(work_attributes)
  #   work_attributes.values.each do |work_attribute|
  #     work1 = Work.find_or_create_by(work_attribute)
  #   end
  # end
end
