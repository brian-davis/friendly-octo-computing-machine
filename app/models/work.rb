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
#
class Work < ApplicationRecord
  include PgSearch::Model

  has_many :work_producers, dependent: :destroy
  has_many :producers, through: :work_producers

  has_many :quotes, dependent: :destroy
  has_many :notes, dependent: :destroy

  has_many :authors, -> { merge(WorkProducer.authors) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :editors, -> { merge(WorkProducer.editor) }, **{
    through: :work_producers,
    source: :producer
  }

  has_many :translators, -> { merge(WorkProducer.translator) }, **{
    through: :work_producers,
    source: :producer
  }

  belongs_to :publisher, optional: true, counter_cache: true

  has_many :children, class_name: "Work", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Work", optional: true

  attr_accessor :_clear_publisher
  attr_accessor :_clear_parent

  accepts_nested_attributes_for :work_producers, allow_destroy: true
  accepts_nested_attributes_for :quotes, allow_destroy: true
  accepts_nested_attributes_for :publisher # destroy false
  accepts_nested_attributes_for :parent # destroy false

  taggable_array :tags

  before_validation :clear_publisher
  before_validation :clear_parent

  before_validation :reset_rating

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

  enum format: [:book, :article, :chapter, :compilation]

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

  # guard rendering bibliography view
  def book_bibliography?
    publisher&.name &&
    producers.any? &&
    title.present? &&
    year_of_publication.present? &&
    book?
  end

  def translator?
    translators.any?
  end

  # TODO
  def editor_bibliography?
    # Doyle, Kathleen. “The Queen Mary Psalter.” In The Book by Design: The Remarkable Story of the World’s Greatest Invention, edited by P. J. M. Marks and Stephen Parkin. University of Chicago Press, 2023.
  end

  # TODO
  # # guard rendering bibliography view
  # def chapter_bibliography?
  #   publisher&.name &&
  #   producers.any? &&
  #   title.present? &&
  #   year_of_publication.present? &&
  #   chapter?
  # end

  def bibliography_markdown
    if self.format == "book"
      sections = []

      author_names = authors.pluck(:name) # order by WorkProducer create
      first_author = author_names.shift
      _split = first_author.split(/\s/)
      _split.unshift(_split.pop) # last name first
      reversed_first_author = _split.join(", ")
      author_names.unshift(reversed_first_author)
      formatted_authors = author_names.to_sentence
      sections << formatted_authors

      formatted_title = Titleize.titleize(
        [self.title, self.subtitle].map(&:presence).compact.join(": ")
      )
      formatted_title = "_#{formatted_title}_"
      sections << formatted_title

      if self.translator?
        formatted_translators = "Translated by #{self.translators.pluck(:name).to_sentence}"
        sections << formatted_translators
      end

      formatted_publishing = "#{self.publisher.name}, #{self.year_of_publication}"
      sections << formatted_publishing

      "#{sections.join(". ")}."
    else
      # TODO
    end
  end

  def title_and_subtitle
    return self.title unless self.subtitle.present?
    "#{self.title}: #{self.subtitle}"
  end

  # remove initial "The"
  def short_title
    title.sub("The ", "")
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

  def reset_rating
    # set to -1 or 0 in form to mark unrated
    if rating_changed?
      self.rating = nil unless self.rating.in?(1..5)
    end
  end
end
