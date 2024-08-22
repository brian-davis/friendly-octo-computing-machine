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
    if self.work.book?
      return "" unless work.publisher && work.authors.any?

      sections = []
      author_names = self.work.authors.pluck(:name).to_sentence # no alphabetizing by last name
      sections << author_names

      title_and_publication = "_#{self.work.title_and_subtitle}_ (#{self.work.publisher.name}, #{self.work.year_of_publication})" # no comma
      sections << title_and_publication

      page = self.page # TODO: String
      sections << page

      result = sections.join(", ") + "."
      return result
    elsif self.work.chapter?
      return "" unless work.parent.publisher && work.parent.editors.any? && work.authors.any?
      author_names = self.work.authors.pluck(:name).to_sentence # no alphabetizing by last name
      work_title = [work.title, work.subtitle].map(&:presence).compact.join(": ")
      parent_title = [work.parent.title, work.parent.subtitle].map(&:presence).compact.join(": ")
      editors = work.parent.editors.pluck(:name).to_sentence

      result = "#{author_names}, “#{work_title},” in _#{parent_title}_, ed. #{editors} (#{work.parent.publisher.name}, #{work.parent.year_of_publication}), #{self.page}."
      return result
    end
  end

  # "Yu, _Interior Chinatown_, 48."
  def short_citation_markdown
    if self.work.book?
      return "" unless work.authors.any?

      sections = []

      author_last_names = self.work.authors.pluck(:name).map { |name| name.split(/\s/).last }.to_sentence
      sections << author_last_names

      title = "_#{self.work.short_title}_"
      sections << title

      page = self.page # TODO: String
      sections << page

      result = sections.join(", ") + "."
      return result
    elsif self.work.chapter?
      return "" unless work.parent.publisher && work.parent.editors.any? && work.authors.any?
      author_last_names = self.work.authors.pluck(:name).map { |name| name.split(/\s/).last }.to_sentence # no alphabetizing by last name
      work_title = work.short_title
      result = "#{author_last_names}, “#{work_title},” #{self.page}."
      return result
    end
  end
end
