# app/models/post/publisher.rb
class Work::Reference < ActiveRecord::AssociatedObject
  include TimeFormatter

  def short_title
    work.title.sub("The ", "")
  end

  def long_title
    [work.supertitle, work.title, work.subtitle].map(&:presence).compact.join(": ")
  end

  def publisher_name
    work.publisher&.name.presence || work.parent&.publisher&.name
  end

  # TODO: research self-join SQL fallback
  def year_of_publication
    work.year_of_publication || work.parent&.year_of_publication
  end

  def year_of_composition
    work.year_of_composition || work.parent&.year_of_composition
  end

  def language_or_translation
    [work.language, work.original_language].map(&:presence).compact.join(", translated from ")
  end

  # TODO: DRY with alpha_producer_names
  def byline
    # author_names = work.producers.pluck(Arel.sql "COALESCE(NULLIF(producers.custom_name, ''), NULLIF(producers.surname,''))")
    author_names = work.producers.map { |p| p.custom_name || p.surname }

    return "" if author_names.empty?

    author_names = author_names.to_sentence

    year_source = work.year_of_publication.presence ||
                  work.year_of_composition.presence ||
                  work.parent&.year_of_publication.presence ||
                  work.parent&.year_of_composition.presence

    year = common_era_year(year_source) # ApplicationHelper
    [
      author_names,
      year
    ].compact.join(", ")
  end
 
  # :index
  def full_title_line
    byline_result = work.reference.byline
    return work.title if byline_result.blank?
    "#{work.reference.long_title} (#{byline_result})"
  end

  # quotes general index
  def short_title_line
    byline_result = work.reference.byline
    return work.reference.short_title if byline_result.blank?
    "#{work.reference.short_title} (#{byline_result})"
  end
end