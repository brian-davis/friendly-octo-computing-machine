# == Schema Information
#
# Table name: producers
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  birth_year  :integer
#  death_year  :integer
#  bio_link    :string
#  nationality :string
#
class Producer < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :work_producers, allow_destroy: true
  validates :name, presence: true

  class << self
    # pseudo-enum
    def nationality_options
      distinct.pluck(:nationality).compact.sort
    end
  end
end
