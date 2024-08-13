# == Schema Information
#
# Table name: producers
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  birth_year  :integer
#  death_year  :integer
#  bio_link    :string
#  nationality :string
#  works_count :integer          default(0)
#
class Producer < ApplicationRecord
  include PgSearch::Model

  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :work_producers, allow_destroy: true
  validates :name, presence: true

  pg_search_scope(
    :search_name,
    {
      against: :name,
      using: {
        :dmetaphone => {},
        :tsearch => { dictionary: "english", tsvector_column: "searchable" }
      }
    }
  )

  class << self
    # pseudo-enum
    def nationality_options
      distinct.pluck(:nationality).compact.sort
    end
  end
end
