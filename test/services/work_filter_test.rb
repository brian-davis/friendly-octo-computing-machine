require "test_helper"

class WorkFilterTest < ActiveSupport::TestCase
  test "title asc" do
    w1 = Work.create(title: "The Fellowship Of The Ring", supertitle: "The Lord Of The Rings")
    w2 = Work.create(title: "The Two Towers", supertitle: "The Lord Of The Rings")
    w3 = Work.create(title: "The Return Of The King", supertitle: "The Lord Of The Rings")
    w4 = Work.create(title: "The Hobbit", subtitle: "Or There And Back Again")
    w5 = Work.create(title: "The Silmarilion")
    
    result = WorkFilter[{ "order" => "title", "dir" => "asc" }].pluck_full_title
    expected = ["The Hobbit: Or There And Back Again", "The Lord Of The Rings: The Fellowship Of The Ring", "The Lord Of The Rings: The Return Of The King", "The Lord Of The Rings: The Two Towers", "The Silmarilion"]
    assert_equal expected, result
  end

  test "title desc" do
    w1 = Work.create(title: "The Fellowship Of The Ring", supertitle: "The Lord Of The Rings")
    w2 = Work.create(title: "The Two Towers", supertitle: "The Lord Of The Rings")
    w3 = Work.create(title: "The Return Of The King", supertitle: "The Lord Of The Rings")
    w4 = Work.create(title: "The Hobbit", subtitle: "Or There And Back Again")
    w5 = Work.create(title: "The Silmarilion")
    
    result = WorkFilter[{ "order" => "title", "dir" => "desc" }].pluck_full_title
    expected = ["The Silmarilion", "The Lord Of The Rings: The Two Towers", "The Lord Of The Rings: The Return Of The King", "The Lord Of The Rings: The Fellowship Of The Ring", "The Hobbit: Or There And Back Again"]
    assert_equal expected, result
  end
end