module WorksHelper
  def title_line(work)
    [work.title, work.subtitle].map(&:presence).compact.join(": ")
  end

  def alternate_title_line(work)
    base = [
      work.alternate_title,
      work.foreign_title
    ].map(&:presence).compact.map do |title|
      "<i>#{title}</i>"
    end.join(" or ")
    return "" if base.empty?
    "Also known as #{base}".html_safe
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

  def publishing_line(work)
    html = [
      link_to(work.publisher&.name, work.publisher, class: "index-link").to_s,
      work.year_of_publication
    ].compact.join(", ")
    return "" if html.blank?
    html.html_safe
  end

  def language_line(work)
    if work.original_language.present? && work.language.present?
      "#{work.language}, translated from #{work.original_language}"
    elsif work.original_language.present? || work.language.present?
      "#{work.original_language.presence || work.language.presence} language"
    end
  end
end
