# == Schema Information
#
# Table name: works
#
#  id           :bigint           not null, primary key
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  publisher_id :bigint
#
class Work < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :producers, through: :work_producers
  accepts_nested_attributes_for :work_producers, allow_destroy: true

  attr_accessor :_clear_publisher
  belongs_to :publisher, optional: true
  before_validation :clear_publisher
  accepts_nested_attributes_for :publisher # destroy false

  validates :title, presence: true

  private

  # remove association, not associated record
  def clear_publisher
    if self._clear_publisher
      self.publisher_id = nil
    end
  end
end
