# == Schema Information
#
# Table name: quotes
#
#  id              :bigint           not null, primary key
#  text            :text
#  page            :integer
#  custom_citation :string
#  work_id         :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  searchable      :tsvector
#
class Quote < ApplicationRecord
  include PgSearch::Model

  # TODO: list, search by author
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

  # Charles Yu, _Interior Chinatown_ (Pantheon Books, 2020), 45.
  def long_citation_markdown
    return "" unless work.publisher && work.authors.any?

    sections = []
    author_names = self.work.authors.pluck(:name).to_sentence # no alphabetizing by last name
    sections << author_names

    title_and_publication = "_#{self.work.title_and_subtitle}_ (#{self.work.publisher.name}, #{self.work.year_of_publication})" # no comma
    sections << title_and_publication

    page = self.page # TODO: String
    sections << page

    result = sections.join(", ") + "."
    result
  end

  # "Yu, _Interior Chinatown_, 48."
  def short_citation_markdown
    return "" unless work.authors.any?

    sections = []

    author_last_names = self.work.authors.pluck(:name).map { |name| name.split(/\s/).last }.to_sentence
    sections << author_last_names

    title = "_#{self.work.short_title}_"
    sections << title

    page = self.page # TODO: String
    sections << page

    result = sections.join(", ") + "."
    result
  end
end
