# == Schema Information
#
# Table name: quotes
#
#  id              :bigint           not null, primary key
#  custom_citation :string
#  page            :string
#  searchable      :tsvector
#  text            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  work_id         :bigint           not null
#
# Indexes
#
#  index_quotes_on_searchable  (searchable) USING gin
#  index_quotes_on_work_id     (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#
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
