class Work::Reference < ActiveRecord::AssociatedObject
  include TimeFormatter
  include ActionView::Helpers::TextHelper

  TITLE_INITIAL_STOPWORDS = ["a", "the", "how"].map { |word| [word, word.capitalize] }.flatten # TODO: more stopwords
  TITLE_INTERNAL_STOPWORDS = ["of", "in", "with", "is", "could"].map { |word| [word, word.capitalize] }.flatten

  def short_title
    init_regexp = %r{
    ^ # start of string
    #{Regexp.union(TITLE_INITIAL_STOPWORDS)} # helper for ANY
    \s # match trailing space, avoid match on Theatre, etc. 
    }x

    post_count_regexp = %r{
    \s # match leading space, avoid match on end of Within, etc.
    #{Regexp.union(TITLE_INTERNAL_STOPWORDS)}
    \s # match trailing space, avoid match on end of Inside, etc. 
    }x

    pre_keep_regexp = %r{
    \s
    #{Regexp.union(TITLE_INTERNAL_STOPWORDS)}
    \s
    .+ # greedy, .split will drop the rest
    }x

    @short_title ||= begin
      result = work.title.sub(init_regexp, "")
      result = if result.split(post_count_regexp)[1]&.split(/\s/)&.size.to_i > 2
        result.split(pre_keep_regexp).first
      else
        result
      end
      result
    end
  end

  def long_title
    @long_title ||= begin
      parts = [
        work.supertitle,
        work.title,
        work.subtitle
      ].map(&:presence)
      parts.compact.join(": ").gsub("?:", "?")
    end
  end

  def publisher_name
    @publisher_name ||= begin
      work.publisher&.name.presence ||
      work.parent&.publisher&.name ||
      work.journal_name ||
      work.media_source
    end
  end

  # TODO: research self-join SQL fallback
  def year_of_publication
    @year_of_publication ||= begin
      work.year_of_publication ||
      work.parent&.year_of_publication
    end
  end

  def year_of_composition
    @year_of_composition ||= begin
      work.year_of_composition ||
      work.parent&.year_of_composition
    end
  end

  def language_or_translation
    @language_or_translation ||= begin
      [
        work.language,
        work.original_language
      ].map(&:presence).compact.join(", translated from ")
    end
  end

  # TODO: DRY with alpha_producer_names
  def byline
    @byline ||= begin
      author_names = work.authors.pluck_last_name.presence ||
        work.producers.pluck_last_name

      return if author_names.empty?

      author_names = author_names.to_sentence

      year_source = work.year_of_composition || # e.g. Sophocles' Antigone 441 BC.
      work.year_of_publication || # don't use this for Antigone
      work.parent&.reference&.year_of_publication # e.g. Hackett edition, 2020

      year = common_era_year(year_source) # ApplicationHelper
      [
        author_names,
        year
      ].compact.join(", ")
    end
  end
 
  # :index
  def full_title_line
    @full_title_line ||= begin
      byline_result = work.reference.byline
      return work.title if byline_result.blank?
      "#{work.reference.long_title} (#{byline_result})"
    end
  end

  # quotes general index
  def short_title_line
    @short_title_line ||= begin
      byline_result = work.reference.byline
      return work.reference.short_title if byline_result.blank?
      "#{work.reference.short_title} (#{byline_result})"
    end
  end

  # full names
  # fallback to parent?
  def producer_names(role = nil)
    scope = role.present? ? role.to_s.pluralize : :producers
    cache_key = "@producer_names_#{scope}"
    instance_variable_get(cache_key) || begin
      result = work.send(scope).pluck_full_name.to_sentence
      instance_variable_set(cache_key, result)
    end
  end

  # last names only
  def producer_last_names(role = nil)
    scope = role.present? ? role.to_s.pluralize : :producers
    cache_key = "@producer_last_names_#{scope}"
    instance_variable_get(cache_key) || begin
      result = work.send(scope).pluck_last_name.to_sentence
      instance_variable_set(cache_key, result)
    end
  end

  # first result is 'last, first middle', rest are 'first middle last'
  def alpha_producer_names(role = nil)
    scope = role.present? ? role.to_s.pluralize : :producers
    cache_key = "@alpha_producer_names_#{scope}"
    instance_variable_get(cache_key) || begin
      sql_base = Work::ALPHA_FIRST
      sql = sql_base.gsub(":work_id", work.id.to_s)
      role_sub = role ? "AND wp.role = '#{role}'" : ""
      sql.gsub!(":role_sql", role_sub)
      results = Producer.connection.select_all(Arel.sql(sql))  
      result = results.rows.flatten.to_sentence({ two_words_connector: ", and "})
      instance_variable_set(cache_key, result)
    end
  end

  def short_producer_roles(period = false)
    cache_key = "@short_producer_roles_#{!!period}"
    instance_variable_get(cache_key) || begin
      # REFACTOR
      result = if work.work_producers.pluck(:role).all? { |r| r == "editor" }
        root = "ed"
        proot = pluralize(work.work_producers.size, root).split(" ").last
        proot.concat(".") if period
        proot
      else
        "" # TODO: anything else?
      end
      instance_variable_set(cache_key, result)
    end
  end

  # REFACTOR: bad pattern
  def chicago_bibliography
    @chicago_bibliography ||= Citation::Chicago::Bibliography.new(work).entry
  end

  # REFACTOR: bad pattern
  def chicago_note(quote, length = :long)
    case length
    when :long
      @chicago_note_long ||= Citation::Chicago::Note.new(work, quote).long
    when :short
      @chicago_note_short ||= Citation::Chicago::Note.new(work, quote).short
    end
  end

  def complete_data?
    if work.publishing_format_journal_article?
      work.publishing_format_journal_article? &&
      work.journal_name.present? &&
      work.journal_volume.present? &&
      work.journal_issue.present? &&
      work.article_page_span.present? &&

      producers? &&
      publisher_name.present? &&
      year_of_publication.present?
    elsif work.publishing_format_web_page? || work.publishing_format_social_media?
      work.title.present? &&
      work.media_date.present? &&
      work.media_source.present? &&
      work.url.present? 
    elsif work.publishing_format_video?
      producers? && work.title.present? && work.media_format.present? && work.digital_source.present?
    elsif work.publishing_format_personal?
      producers? && work.media_date.present?
    else
      producers? &&
      publisher_name.present? &&
      year_of_publication.present?
    end
  end

  def producers?
    work.producers.any? ||
    work.parent&.producers&.any?
  end

  def compilation?
    work.children.any? && work.editors.any?
  end
end