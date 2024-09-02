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
class Producer < ApplicationRecord
  include PgSearch::Model

  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :work_producers, allow_destroy: true

  # TODO: uniqueness validations
  validates :custom_name, presence: true, unless: -> { given_name? && family_name? }
  validates :given_name, presence: true, unless: -> { custom_name? }
  validates :family_name, presence: true, unless: -> { custom_name? }

  before_save :set_name

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

  scope :select_names, -> () {
    select(:id, :custom_name, :given_name, :middle_name, :family_name)
  }

  class << self
    # pseudo-enum
    def nationality_options
      distinct.pluck(:nationality).compact.sort
    end

    def name_options
      # # avoid cache column
      # distinct.order(:name).pluck(:name, :id)

      ActiveRecord::Base.connection.select_all("SELECT DISTINCT COALESCE(NULLIF(custom_name, ''), CONCAT_WS(' ', NULLIF(given_name, ''), NULLIF(middle_name, ''), NULLIF(family_name, ''))) AS derived_name, id FROM producers ORDER BY derived_name").rows
    end
  end

private
  # TODO: avoid this
  # set a canonical name for sorting, searching convenience
  def set_name
    if self.given_name.present? && self.family_name.present?
      self.name = [self.given_name, self.middle_name, self.family_name].map(&:presence).compact.join(" ")
    elsif self.custom_name.present?
      self.name = self.custom_name
    else
      self.name = nil
    end
  end
end
