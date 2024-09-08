# == Schema Information
#
# Table name: producers
#
#  id            :bigint           not null, primary key
#  custom_name   :string
#  given_name    :string
#  middle_name   :string
#  family_name   :string
#  foreign_name  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  year_of_birth :integer
#  year_of_death :integer
#  bio_link      :string
#  nationality   :string
#  works_count   :integer          default(0)
#  searchable    :tsvector
#

# TODO: rename columns forename, surname;
class Producer < ApplicationRecord
  include PgSearch::Model

  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :work_producers, allow_destroy: true

  # TODO: uniqueness validations
  validates :custom_name, presence: true, unless: -> { given_name? && family_name? }
  validates :given_name, presence: true, unless: -> { custom_name? }
  validates :family_name, presence: true, unless: -> { custom_name? }

  validate :full_name_uniqueness

  FULL_NAME_SQL = <<~SQL.squish
    COALESCE(
      NULLIF(producers.custom_name, ''),
      CONCAT_WS(
        ' ',
        NULLIF(producers.given_name, ''),
        NULLIF(producers.middle_name, ''),
        NULLIF(producers.family_name, '')
      )
    )
  SQL

  FULL_SURNAME_SQL = <<~SQL.squish
    COALESCE(
      NULLIF(producers.custom_name, ''),
      CONCAT_WS(
        ', ',
        NULLIF(producers.family_name, ''),
        CONCAT_WS(
          ' ',
          NULLIF(producers.given_name, ''),
          NULLIF(producers.middle_name, '')
        )
      )
    )
  SQL

  SURNAME_SQL = <<~SQL.squish
    COALESCE(
      NULLIF(producers.custom_name, ''),
      NULLIF(producers.family_name, '')
    )
  SQL

  pg_search_scope(
    :search_name,
    {
      against: {
        custom_name: "A",
        given_name: "B",
        family_name: "C",
        foreign_name: "D"
      },
      using: {
        :dmetaphone => {},
        tsearch: {
          dictionary: "english", tsvector_column: "searchable"
        }
      }
    }
  )

  scope :order_by_full_name, -> (options = {}) {
    direction = options.delete(:full_name) || :asc
    valid_options = options.select { |k,v| k.to_s.in?(column_names) }

    # full_name always least precedence (default)
    # IMPROVE: use ordered array of tuples, not hash
    order(valid_options).order({ Arel.sql(FULL_NAME_SQL) => direction })
  }

  scope :pluck_full_name, -> (*args) {
    pluck(Arel.sql(FULL_NAME_SQL), *args)
  }

  scope :pluck_last_name, -> (*args) {
    pluck(Arel.sql(SURNAME_SQL), *args)
  }

  scope :pluck_alpha_name, -> (*args) {
    pluck(Arel.sql(FULL_SURNAME_SQL), *args)
  }

  scope :where_full_name, -> (query) {
    # TODO: use Arel for predicate & for in clause, not raw sql
    # TODO: sanitize: https://api.rubyonrails.org/classes/ActiveRecord/Sanitization/ClassMethods.html#method-i-sanitize_sql_for_conditions
    query_str = Array(query).map { |q| "'#{q}'" }.join(", ")

    sql = "SELECT id FROM producers WHERE #{Producer::FULL_NAME_SQL} IN (#{query_str})"

    ids = Producer.find_by_sql(sql)

    self.where(id: ids)
  }

  # TODO: use for surname-sorted index
  scope :order_by_full_surname, -> (options = {}) {
    direction = options[:direction] || :asc
    order({ Arel.sql(FULL_SURNAME_SQL) => direction })
  }

  # TODO: use for surname-sorted index
  scope :pluck_full_surname, -> () {
    pluck(Arel.sql(FULL_SURNAME_SQL))
  }

  class << self
    # pseudo-enum
    def nationality_options
      distinct.pluck(:nationality).compact.sort
    end

    # pseudo-enum, works/_form select_options for already-saved records
    def name_options
      order_by_full_name.pluck_full_name(:id)
    end
  end

  def full_name
    base_full_name = custom_name.presence || [given_name, middle_name, family_name].map(&:presence).compact.join(" ")
  end

  def full_name=(str)
    first, *middle, last = str.split(/\s/)
    middle = middle.join(" ")
    self.given_name = first if first.present?
    self.middle_name = middle if middle.present?
    self.family_name = last if last.present?
  end

private

  def full_name_uniqueness
    # If producer has been built by subform on the work form, most columns will be nil.
    # When submitting the producer update form, these columns may be "changed" from nil => ""
    is_relevant = self.new_record? ||
                  (self.given_name_previous_change && self.given_name_changed?) ||
                  (self.family_name_previous_change && self.family_name_changed?) ||
                  (self.year_of_birth_previous_change && self.year_of_birth_changed?)
    return unless is_relevant
    if Producer.where({ year_of_birth: self.year_of_birth })
               .where_full_name(self.full_name).exists?
      self.errors.add(:base, "Name and Birth Year must be unique")
    end
  end
end
