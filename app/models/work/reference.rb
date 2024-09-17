# app/models/post/publisher.rb
class Work::Reference < ActiveRecord::AssociatedObject
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
end