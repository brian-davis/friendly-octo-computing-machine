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
    work.reference.long_title
  end

  # :index
  def full_title_line(work)
    byline_result = byline(work)
    return work.title if byline_result.blank?
    "#{title_line(work)} (#{byline_result})"
  end

  # quotes general index
  def short_title_line(work)
    byline_result = byline(work)
    return work.reference.short_title if byline_result.blank?
    "#{work.reference.short_title} (#{byline_result})"
  end
end
