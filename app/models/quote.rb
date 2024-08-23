# == Schema Information
#
# Table name: quotes
#
#  id              :bigint           not null, primary key
#  text            :text
#  page            :string
#  custom_citation :string
#  work_id         :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  searchable      :tsvector
#
class Quote < ApplicationRecord
  include PgSearch::Model
  include Citable

  belongs_to :work
  validates :text, presence: true

  # Quote.search_text("a famous quote")
  pg_search_scope(
    :search_text,
    {
      against: :text,
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
end
