module WorksHelper
  def title_line(work)
    Titleize.titleize(
      [work.title, work.subtitle].map(&:presence).compact.join(": ")
    )
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
    authors = work.authors
    author_names = authors.pluck(:custom_name, :family_name).map do |custom_name, family_name|
      custom_name.presence || family_name
    end.to_sentence
    year = common_era_year(work.year_of_composition) # ApplicationHelper

    [
      author_names,
      year
    ].compact.join(", ")
  end

  def full_title_line(work)
    byline = byline(work)
    return work.title if byline.blank?
    "#{work.title} (#{byline})"
  end

  def publishing_line(work)
    return "" unless work && work.publisher

    html = [
      link_to(work.publisher&.name, work.publisher, class: "index-link").to_s,
      work.year_of_publication
    ].compact.join(", ")
    html.html_safe
  end

  def language_line(work)
    if work.original_language.present? && work.language.present?
      "#{work.language}, translated from #{work.original_language}"
    elsif work.original_language.present? || work.language.present?
      "#{work.original_language.presence || work.language.presence} language"
    end
  end

  def rating_stars(work)
    return "" if work.rating.nil?
    tag.span(("★" * work.rating), class: "stars")
  end
end
