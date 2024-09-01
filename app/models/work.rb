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
#  tags                :string           default([]), is an Array
#  searchable          :tsvector
#  rating              :integer
#  format              :integer          default("book")
#  custom_citation     :string
#  parent_id           :integer
#
class Work < ApplicationRecord
  include PgSearch::Model
  include Citable

  belongs_to :publisher, optional: true, counter_cache: true
  belongs_to :parent, class_name: "Work", optional: true # self join

  has_many :children, class_name: "Work", foreign_key: "parent_id" # self join

  has_many :work_producers, dependent: :destroy
  has_many :producers, -> { merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :quotes, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :reading_sessions, dependent: :destroy

  has_many :authors, -> { merge(WorkProducer.authors).merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }
  has_many :editors, -> { merge(WorkProducer.editor).merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }
  has_many :translators, -> { merge(WorkProducer.translator).merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  attr_accessor :_clear_publisher
  attr_accessor :_clear_parent

  accepts_nested_attributes_for :work_producers, allow_destroy: true
  accepts_nested_attributes_for :quotes, allow_destroy: true
  accepts_nested_attributes_for :publisher # destroy false
  accepts_nested_attributes_for :parent # destroy false

  taggable_array :tags

  before_validation :clear_publisher
  before_validation :clear_parent

  before_validation :constrain_rating

  before_save :deduplicate_tags

  validates :title, presence: true

  # Quote.search_text("a famous quote")
  pg_search_scope(
    :search_title, {
      against: :title,
      using: {
        tsearch: {
          prefix: true, # sl => sleep
          negation: true, # !sleep
          dictionary: "english", # sleep/sleeps/sleeping

          tsvector_column: "searchable"
        }
      }
    }
  )

  scope :untagged, -> { where({ tags: [] }) }

  enum format: [:book, :article, :chapter, :compilation, :reference]

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

  def reading_sessions_minutes
    reading_sessions.sum(:duration)
  end

  private

  # remove association, not associated record
  def clear_publisher
    if self._clear_publisher == "1"
      self.publisher_id = nil
    end
  end

  # remove association, not associated record
  def clear_parent
    if self._clear_parent == "1"
      self.parent_id = nil
    end
  end

  # use empty array attr to clear tags (nil attr will be no-op/keep)
  def deduplicate_tags
    self.tags.delete("") # gem/db doesn't guard against this.
    self.tags.uniq!
  end

  def constrain_rating
    # set to -1 or 0 in form to mark unrated
    if rating_changed?
      self.rating = nil unless self.rating.in?(1..5)
    end
  end
end
