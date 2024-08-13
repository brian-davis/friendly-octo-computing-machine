class Quote < ApplicationRecord
  include PgSearch::Model

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
