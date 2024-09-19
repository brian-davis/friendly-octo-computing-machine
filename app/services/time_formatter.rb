module TimeFormatter
  include ActionView::Helpers::DateHelper

  def common_era_year(year, options = {})
    default_options = {
      scheme: :ce,
      spaces: true,
      periods: false
    }
    options = default_options.merge(options)

    return if year.blank?
    return "#{year}" if year > 1000
    scheme_labels = {
      bc: {
        negative: "BC",
        positive: "AD"
      },
      ce: {
        negative: "BCE",
        positive: "CE"
      }
    }
    scheme_label = scheme_labels[
      options[:scheme]
    ][
      (year.negative? ? :negative : :positive)
    ]
    if options[:periods]
      scheme_label = scheme_label.chars.map { |c| "#{c}." }.join
    end
    spacer = options[:spaces] ? " " : ""
    "#{year.abs}#{spacer}#{scheme_label}"
  end
  
  def common_era_span(early_year, late_year, options = {})
    default_options = {spaces:true}
    options = default_options.merge(options)

    return if early_year.blank? && late_year.blank?
    bc_early_year = common_era_year(early_year, options)
    bc_late_year = common_era_year(late_year, options)

    spacer = options[:spaces] ? " " : "" # re-use option
    span = [bc_early_year, bc_late_year].map(&:presence).join("#{spacer}-#{spacer}")
    "(#{span})"
  end

  def human_time_for(timestamp)
    case timestamp
    when Date
      timestamp.strftime("%B %e, %Y").squish
    when ActiveSupport::TimeWithZone
      timestamp.strftime("%A, %B #{timestamp.day.ordinalize}, %Y @ %l:%M %p")
    end
  end

  def human_duration(int_minutes)
    from_time = Time.now
    to_time = from_time + int_minutes.minutes
    distance_of_time_in_words(from_time, to_time)
  end
end