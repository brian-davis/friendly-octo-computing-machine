# == Schema Information
#
# Table name: works
#
#  id                  :bigint           not null, primary key
#  accession_note      :text
#  alternate_title     :string
#  article_date        :date
#  article_page_span   :string
#  condition           :integer
#  cover               :integer
#  custom_citation     :string
#  date_of_accession   :date
#  date_of_completion  :date
#  foreign_title       :string
#  interviewer_name    :string
#  journal_issue       :integer
#  journal_name        :string
#  journal_volume      :integer
#  language            :string
#  media_date          :date
#  media_format        :string
#  media_source        :string
#  media_timestamp     :string
#  online_source       :string
#  original_language   :string
#  publishing_format   :enum             default("book")
#  rating              :integer
#  review_author       :string
#  review_title        :string
#  searchable          :tsvector
#  series_ordinal      :integer
#  subtitle            :string
#  supertitle          :string
#  tags                :string           default([]), is an Array
#  title               :string
#  url                 :string
#  wishlist            :boolean          default(FALSE)
#  year_of_composition :integer
#  year_of_publication :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  parent_id           :bigint
#  publisher_id        :bigint
#
# Indexes
#
#  index_works_on_parent_id          (parent_id)
#  index_works_on_publisher_id       (publisher_id)
#  index_works_on_publishing_format  (publishing_format)
#  index_works_on_searchable         (searchable) USING gin
#  index_works_on_tags               (tags) USING gin
#  index_works_on_wishlist           (wishlist)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => works.id)
#  fk_rails_...  (publisher_id => publishers.id)
#
class Work < ApplicationRecord
  include WorkSql
  include PgSearch::Model

  has_object :reference

  belongs_to :publisher, optional: true, counter_cache: true

  belongs_to :parent, class_name: "Work", optional: true # self join
  has_many :children, class_name: "Work", foreign_key: "parent_id", dependent: :destroy # self join
  
  has_many :work_producers, dependent: :destroy
  has_many :producers, -> {
    merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :notes, as: :notable, dependent: :destroy
  
  has_many :quotes, dependent: :destroy
  has_many :reading_sessions, dependent: :destroy

  has_many :authors, -> { merge(WorkProducer.role_author).merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :editors, -> { merge(WorkProducer.role_editor).merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :translators, -> { merge(WorkProducer.role_translator).merge(WorkProducer.order(:created_at)) }, **{
    through: :work_producers,
    source: :producer
  }

  # authors_or_editors_or_translators

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
    left_outer_joins(:parent).where(
      "COALESCE(works.wishlist, parents_works.wishlist) IS NOT ?", true
    )
  }

  scope :wishlist, -> {
    left_outer_joins(:parent).where(
      "COALESCE(works.wishlist, parents_works.wishlist) IS ?", true
    )
  }

  scope :read, -> {
    left_outer_joins(:parent).where(
      "COALESCE(works.date_of_completion, parents_works.date_of_completion) IS NOT NULL"
    )
  }

  scope :unread, -> {
    left_outer_joins(:parent).where(
      "COALESCE(works.date_of_completion, parents_works.date_of_completion) IS NULL"
    )
  }

  scope :compilations, -> {
    joins(:children).distinct
  }

  # cf. WorkFilter
  scope :order_by_title, ->(dir = "ASC") {
    return unless %w[ASC DESC].include?(dir.upcase)
    
    # Workaround for postgres case-sensitive ordering.
    # TODO: research alternate db collations.
    order(Arel.sql("UPPER(#{FULL_TITLE_SQL}) #{dir.upcase}"))
  }

  enum :cover, %i[paperback hardcover large_paperback large_hardcover], prefix: :cover
  enum :condition, %i[poor fair good very_good excellent mint], prefix: :condition

  # postgresql enum
  enum :publishing_format, {
    :book            => "book",
    :chapter         => "chapter",
    :ebook           => "ebook",
    :journal_article => "journal_article",
    :news_article    => "news_article",
    :book_review     => "book_review",
    :interview       => "interview",
    :thesis          => "thesis",
    :web_page        => "web_page",
    :social_media    => "social_media",
    :video           => "video",
    :personal        => "personal"
  }, prefix: :publishing_format

  scope :pluck_full_title, ->(*args) {
    pluck(Arel.sql(FULL_TITLE_SQL), *args)
  }

  class << self
    # pseudo-enum
    def language_options(unspecified: false)
      saved_values = pluck(:language, :original_language).flatten.map(&:presence).compact.uniq.sort
      unspecified ? (saved_values + ["[unspecified]"]) : saved_values
    end

    def parent_options(work)
      compilations.where.not(id: [work.id, work.parent&.id]).order(:title).pluck(:title, :id)
    end

    def tag_options
      all_tags.sort
    end

    def publishing_format_options
      if Flipper.enabled?(:all_work_formats)
        publishing_formats.keys.sort
      else
        hash1 = Work.publishing_formats
        keep_keys = %i[book chapter]
        kept = hash1.slice(*keep_keys)
        kept.keys.sort
      end
    end

    # Producer form associations
    # Work form clone
    alias_method :clone_options, def title_options
      order("UPPER(works.title)").pluck(:title, :id)
    end

    def extended_tags_cloud
      custom_tags = [
        ["all", all.count, "alt"],
        ["untagged", untagged.count, "alt"]
      ]

      # most popular first
      standard_tags = tags_cloud.sort_by { |k, v| v * -1 }

      custom_tags + standard_tags
    end
  end

  def reading_sessions_minutes
    reading_sessions.sum(:duration)
  end

  alias_method :complete?, def finished?
    date_of_completion.present?
  end

  def rating_stars
    (1..5).to_a.map { |i| i <= self.rating.to_i ? "★" : "☆" }.join
  end

  def digital_source
    url.presence || online_source
  end

  def series_title
    return unless self.series_ordinal.present?

    self.supertitle.presence || self.subtitle.presence
  end

  def series?
    self.series_ordinal.present? && self.series_title.present?
  end

  def series_parts
    return self.class.none unless self.series?

    search_term = if self.supertitle.present?
                    { supertitle: self.supertitle }
                  elsif self.subtitle.present?
                    { subtitle: self.subtitle }
                  end

    self.class.where(search_term).order(:series_ordinal)
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
