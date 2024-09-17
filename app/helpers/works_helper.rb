module WorksHelper
  # TODO: DRY with alpha_producer_names
  def byline(work)
    # author_names = work.producers.pluck(Arel.sql "COALESCE(NULLIF(producers.custom_name, ''), NULLIF(producers.surname,''))")
    author_names = work.producers.map { |p| p.custom_name || p.surname }

    return "" if author_names.empty?

    author_names = author_names.to_sentence

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
