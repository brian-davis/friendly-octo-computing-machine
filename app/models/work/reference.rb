# app/models/post/publisher.rb
class Work::Reference < ActiveRecord::AssociatedObject

  # # > w.reference._test_feature
  # # => "MEDITATIONS"
  # def _test_feature
  #   work.title.upcase
  # end

  def short_title
    work.title.sub("The ", "")
  end

  def long_title
    [work.supertitle, work.title, work.subtitle].map(&:presence).compact.join(": ")
  end
end