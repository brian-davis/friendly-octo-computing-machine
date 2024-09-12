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
#  format              :integer          default(0)
#  custom_citation     :string
#  parent_id           :integer
#  supertitle          :string
#  date_of_accession   :date
#  accession_note      :text
#  finished            :boolean
#  date_of_completion  :date
#
class Work < ApplicationRecord
  include PgSearch::Model

  belongs_to :publisher, optional: true, counter_cache: true

  belongs_to :parent, class_name: "Work", optional: true # self join
  has_many :children, class_name: "Work", foreign_key: "parent_id" # self join
  
  has_many :work_producers, dependent: :destroy
  has_many :producers, -> {
    merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :quotes, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :reading_sessions, dependent: :destroy

  has_many :authors, -> { merge(WorkProducer.where_role(:author)).merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :editors, -> { merge(WorkProducer.where_role(:editor)).merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :translators, -> { merge(WorkProducer.where_role(:translator)).merge(WorkProducer.order(:created_at)) }, **{
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

  pg_search_scope(
    :search_title, {
      against: {
        :title => "A",
        :subtitle => "B",
        :supertitle => "C",
        :foreign_title => "D"
      },
      using: {
        tsearch: {
          prefix: true, # sl => sleep
          negation: true, # !sleep
          dictionary: "english", # sleep/sleeps/sleeping

          tsvector_column: "searchable"
        }
      },
      ignoring: :accents
    }
  )

  scope :untagged, -> { where({ tags: [] }) }

  scope :collection, -> {
    left_outer_joins(:parent).where("COALESCE(works.date_of_accession, parents_works.date_of_accession) IS NOT NULL")
  }

  scope :wishlist, -> {
    left_outer_joins(:parent).where("COALESCE(works.date_of_accession, parents_works.date_of_accession) IS NULL")
  }

  scope :read, -> {
    left_outer_joins(:parent).where("COALESCE(works.date_of_completion, parents_works.date_of_completion) IS NOT NULL")
  }

  scope :unread, -> {
    left_outer_joins(:parent).where("COALESCE(works.date_of_completion, parents_works.date_of_completion) IS NULL")
  }

  scope :compilations, -> {
    joins(:children).distinct
  }

  # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book
  enum_accessor :format, [
    :book,            # Book
    :chapter,         # Chapter or other part of an edited book
    :translated_book, # Translated book
    :ebook,           # Book consulted in an electronic format
    :journal_article, # Journal article
    :news_article,    # News or magazine article
    :book_review,     # Book review
    :interview,       # Interview
    :thesis,          # Thesis or dissertation
    :web_page,        # Web page
    :social_media,    # Social media content
    :video,           # Video or podcast
    :personal         # Personal communication
  ]

  class << self
    # pseudo-enum
    def language_options(unspecified: false)
      saved_values = pluck(:language, :original_language).flatten.map(&:presence).compact.uniq.sort
      unspecified ? (saved_values + ["[unspecified]"]) : saved_values
    end

    def parent_options(work)
      compilations.where.not(id: [work.id, work.parent&.id]).pluck(:title, :id)
    end

    def tag_options
      all_tags.sort
    end

    def format_options
      # formats.keys.map { |k| [k.titleize, k] }

      formats.keys.map { |k| [k.humanize, k] }
    end

    def title_options
      order(:title).pluck(:title, :id).uniq.map do |title, id|
        [title.truncate(25), id]
      end
    end
  end

  def reading_sessions_minutes
    reading_sessions.sum(:duration)
  end

  alias_method :complete?, def finished?
    date_of_completion.present?
  end

  def short_title
    title.sub("The ", "")
  end

  def long_title
    [supertitle, title, subtitle].map(&:presence).compact.join(": ")
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