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
end