# == Schema Information
#
# Table name: producers
#
#  id           :bigint           not null, primary key
#  custom_name  :string
#  given_name   :string
#  middle_name  :string
#  family_name  :string
#  foreign_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  birth_year   :integer
#  death_year   :integer
#  bio_link     :string
#  nationality  :string
#  works_count  :integer          default(0)
#  searchable   :tsvector
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

  scope :where_full_name, -> (query) {
    # TODO: use Arel for predicate & for in clause, not raw sql
    query_str = query.map { |q| "'#{q}'" }.join(", ") # not safe
    sql = "SELECT id FROM producers WHERE #{Producer::FULL_NAME_SQL} IN (#{query_str})"

    ids = Producer.find_by_sql(sql)
    Producer.where(id: ids)
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
    custom_name.presence || [given_name, middle_name, family_name].map(&:presence).compact.join(" ")
  end

  def full_name=(str)
    first, *middle, last = str.split(/\s/)
    middle = middle.join(" ")
    self.given_name = first if first.present?
    self.middle_name = middle if middle.present?
    self.family_name = last if last.present?
  end
end