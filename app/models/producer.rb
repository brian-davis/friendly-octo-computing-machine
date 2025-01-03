# == Schema Information
#
# Table name: producers
#
#  id            :bigint           not null, primary key
#  bio_link      :string
#  custom_name   :string
#  foreign_name  :string
#  forename      :string
#  middle_name   :string
#  nationality   :string
#  searchable    :tsvector
#  surname       :string
#  works_count   :integer          default(0)
#  year_of_birth :integer
#  year_of_death :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_producers_on_searchable                    (searchable) USING gin
#  producers_forename_surname_year_of_birth_unique  (forename,surname,year_of_birth) UNIQUE
#
class Producer < ApplicationRecord
  include ProducerSql

  has_object :biography
  include PgSearch::Model

  has_many :notes, as: :notable, dependent: :destroy

  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :work_producers, allow_destroy: true

  validate :full_name_presence
  validate :full_name_uniqueness

  pg_search_scope(
    :search_name,
    {
      against: {
        custom_name: "A",
        forename: "B",
        surname: "C",
        foreign_name: "D"
      },
      using: {
        :dmetaphone => {},
        tsearch: {
          prefix: true,
          dictionary: "english",
          tsvector_column: "searchable"
        }
      }
    }
  )

  scope :order_by_full_name, -> (options = {}) {
    direction = options.delete(:full_name) || :asc
    valid_options = options.select { |k,v| k.to_s.in?(column_names) }

    # full_name always least precedence (default)
    order(valid_options).order({ Arel.sql(FULL_NAME_SQL) => direction })
  }

  scope :pluck_full_name, -> (*args) {
    pluck(Arel.sql(FULL_NAME_SQL), *args)
  }

  scope :pluck_last_name, -> (*args) {
    pluck(Arel.sql(SURNAME_SQL), *args)
  }

  # TODO: use for surname-sorted index?
  scope :pluck_alpha_name, -> (*args) {
    pluck(Arel.sql(FULL_SURNAME_SQL), *args)
  }

  scope :where_full_name, -> (query) {
    where(Arel.sql("#{FULL_NAME_SQL} IN (:arr)"), arr: Array(query))
  }

  # TODO: use for surname-sorted index?
  scope :order_by_full_surname, -> (options = {}) {
    direction = options[:direction] || :asc
    order({ Arel.sql(FULL_SURNAME_SQL) => direction })
  }

  # TODO: use for surname-sorted index?
  scope :pluck_full_surname, -> () {
    pluck(Arel.sql(FULL_SURNAME_SQL))
  }

  class << self
    # pseudo-enum
    def nationality_options
      distinct.pluck(:nationality)
    end

    # pseudo-enum
    def name_options
      order_by_full_name.pluck_full_name(:id)
    end
  end

  def full_name
    custom_name.presence || [forename, middle_name, surname].map(&:presence).compact.join(" ")
  end

  def full_name=(str)
    first, *middle, last = str.split(/\s/)
    middle = middle.join(" ")
    self.forename = first if first.present?
    self.middle_name = middle if middle.present?
    self.surname = last if last.present?
  end

private
  def full_name_presence
    if full_name.blank?
      self.errors.add(:base, "Custom Name or Forename and Surname must be present.")
    end
  end

  def full_name_uniqueness
    # If producer has been built by subform on the work form, most columns will be nil.
    # When submitting the producer update form, these columns may be "changed" from nil => ""
    is_relevant = self.new_record? ||
                  (self.forename_previous_change && self.forename_changed?) ||
                  (self.surname_previous_change && self.surname_changed?) ||
                  (self.year_of_birth_previous_change && self.year_of_birth_changed?)
    return unless is_relevant
    if Producer.where({ year_of_birth: self.year_of_birth })
               .where_full_name(self.full_name).exists?
      self.errors.add(:base, "Name and Birth Year must be unique")
    end
  end
end
