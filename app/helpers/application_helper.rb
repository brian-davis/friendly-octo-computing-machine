module ApplicationHelper
  include TimeFormatter

  private def markdown_renderer
    @markdown_renderer ||= begin
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML, autolink: true, tables: true
      )
    end
  end

  def markdown_render(md_text)
    raw(markdown_renderer.render(md_text).squish)
  end

  def pipe_spacer
    content_tag(:span, nil, class: "horizontal-spacer")
  end

  def pointer_link(path)
    link_to("👉", path, class: "index-link")
  end

  def strict_options(select_options, options = {})
    max_length = options[:max_length] || 25  
    # use SQL for ordering
    select_options
      .select { |a, _b| options[:blank] ? true : a.present? }
      .uniq
      .map { |name, value|
        display_text = options[:raw] ? name : name.humanize.titleize.truncate(max_length)
        param_value = (value || name) # not altered
        [display_text, param_value]
      }
  end

  # select_options is an array of single values (no tuples)
  def strict_datalist_options(select_options)
    # pseudo-enums, don't use SQL for ordering?
    select_options.map(&:presence).compact.uniq.sort_by { |str| str.upcase }
  end

  # <%= form.label :nationality %>
  # <%= form.text_field :nationality, { list: "producer_nationalities_datalist" } %>
  # <%=
  #   datalist_options({
  #     list: "producer_nationalities_datalist",
  #     select_options: @nationality_options
  #   })
  # %>
  def render_datalist_options(options = {})
    datalist_id = options[:list]
    select_options = options[:select_options]
    return unless datalist_id.present? && select_options.present?

    content_tag(:datalist, nil, {
      id: datalist_id,
      data: {
        :autocomplete_input_target => :datalist
      }
    }) do
      select_options.each do |select_option|
        concat(
          content_tag(:option, nil, {
            value: select_option,
            data: {
              autocomplete_input_target: 'datalistOption'
            }
          })
        )
      end
    end
  end
end