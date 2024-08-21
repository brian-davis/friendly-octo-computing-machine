module ApplicationHelper
  def common_era_year(year)
    return if year.blank?
    return "#{year}" if year > 1000
    year.negative? ? "#{year.abs} BCE" : "#{year.abs} CE"
  end

  def markdown
    # https://github.com/vmg/redcarpet
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end
end
