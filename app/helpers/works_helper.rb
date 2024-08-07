module WorksHelper
  def title_line(work)
    [work.title, work.subtitle].map(&:presence).compact.join(": ")
  end

  def alternate_title_line(work)
    [
      work.alternate_title,
      work.foreign_title
    ].map(&:presence).compact.map do |title|
      "<i>#{title}</i>"
    end.join(" or ")
  end

  def byline(work)
    authors = work.producers.merge(WorkProducer.where({ role: [:author, :co_author] })) # TODO: move to model
    author_names = authors.pluck(:name).to_sentence
    year = common_era_year(work.year_of_composition) # ApplicationHelper

    [
      author_names,
      year
    ].compact.join(", ")
  end
end
