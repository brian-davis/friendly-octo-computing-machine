# == Schema Information
#
# Table name: works
#
#  id                  :bigint           not null, primary key
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  publisher_id        :bigint
#  subtitle            :string
#  alternate_title     :string
#  foreign_title       :string
#  year_of_composition :integer
#  year_of_publication :integer
#  language            :string
#  original_language   :string
#
class Work < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :producers, through: :work_producers

  accepts_nested_attributes_for :work_producers, allow_destroy: true

  attr_accessor :_clear_publisher
  belongs_to :publisher, optional: true
  before_validation :clear_publisher
  before_save :deduplicate_tags
  accepts_nested_attributes_for :publisher # destroy false

  validates :title, presence: true

  taggable_array :tags

  scope :untagged, -> { where({ tags: [] }) }

  class << self
    # pseudo-enum
    def language_options
      distinct.pluck(:language).compact.sort
    end

    # pseudo-enum
    def original_language_options
      distinct.pluck(:original_language).compact.sort
    end
  end

private

  # remove association, not associated record
  def clear_publisher
    if self._clear_publisher == "1"
      self.publisher_id = nil
    end
  end

  # use empty array attr to clear tags (nil attr will be no-op/keep)
  def deduplicate_tags
    self.tags.delete("") # gem/db doesn't guard against this.
    self.tags.uniq!
  end
end
