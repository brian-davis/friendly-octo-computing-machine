module WorksHelper
  # TODO: DRY with alpha_producer_names
  def byline(work)
    author_names = work.authors.pluck(:custom_name, :surname)

    # TODO: sql fallbacks
    # partial n + 1
    if author_names.empty?
      author_names = work.editors.pluck(:custom_name, :surname)
    end

    # partial n + 1
    if author_names.empty?
      author_names = work.translators.pluck(:custom_name, :surname)
    end

    return "" if author_names.empty?

    author_names = author_names.map do |custom_name, surname|
      custom_name.presence || surname
    end.to_sentence

    year_source = work.year_of_composition.presence || work.year_of_publication.presence ||
                  work.parent&.year_of_composition.presence || work.parent&.year_of_publication.presence

    year = common_era_year(year_source) # ApplicationHelper

    [
      author_names,
      year
    ].compact.join(", ")
  end

  # :show
  def title_line(work)
    Titleize.titleize(
      work.reference.long_title
    )
  end

  # :index
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

  # :show
  def language_line(work)
    [work.language, work.original_language].map(&:presence).compact.join(", translated from ")
  end

  # :show, :index
  def rating_stars(work)
    rating = work.rating.to_i
    result = (1..5).to_a.map { |i| i <= rating ? "★" : "☆" }.join
    tag.span(result, class: "quantity")
  end
end
