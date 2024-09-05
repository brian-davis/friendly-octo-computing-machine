module ApplicationHelper
  def common_era_year(year)
    return if year.blank?
    return "#{year}" if year > 1000
    year.negative? ? "#{year.abs} BCE" : "#{year.abs} CE"
  end


  def common_era_span(early_year, late_year)
    return if early_year.blank? && late_year.blank?
    bc_early_year = common_era_year(early_year)
    bc_late_year = common_era_year(late_year)
    span = [bc_early_year, bc_late_year].map(&:presence).join(" - ")
    "(#{span})"
  end

  def markdown
    # https://github.com/vmg/redcarpet
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

  def human_time_for(timestamp)
    timestamp.strftime("%A, %B #{timestamp.day.ordinalize}, %Y @ %l:%M %p")
  end

  def human_updated_at(object)
    human_time_for(object.updated_at)
  end

  def human_duration(int)
    from_time = Time.now
    to_time = from_time + int.minutes
    distance_of_time_in_words(from_time, to_time)
  end
end
