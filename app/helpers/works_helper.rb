module WorksHelper
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
    author_names = work.authors.pluck(:custom_name, :family_name)

    # partial n + 1
    if author_names.empty?
      author_names = work.editors.pluck(:custom_name, :family_name)
    end

    # partial n + 1
    if author_names.empty?
      author_names = work.translators.pluck(:custom_name, :family_name)
    end

    return "" if author_names.empty?

    author_names = author_names.map do |custom_name, family_name|
      custom_name.presence || family_name
    end.to_sentence

    year_source = work.year_of_composition.presence || work.year_of_publication.presence ||
                  work.parent&.year_of_composition.presence || work.parent&.year_of_publication.presence

    year = common_era_year(year_source) # ApplicationHelper

    [
      author_names,
      year
    ].compact.join(", ")
  end

  def title_line(work)
    Titleize.titleize(
      [work.supertitle, work.title, work.subtitle].map(&:presence).compact.join(": ")
    )
  end

  def full_title_line(work)
    byline = byline(work)
    return work.title if byline.blank?
    "#{title_line(work)} (#{byline})"
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
    empty = "☆"
    full =  "★"
    stars = []
    work.rating.to_i.times { stars << full }
    until stars.length == 5
      stars << empty
    end
    result = stars.join()
    tag.span(result, class: "stars")
  end
end
