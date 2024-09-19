require "test_helper"
require_relative "reference_test_fixtures"

class ReferenceTest < ActiveSupport::TestCase
  include ReferenceTestFixtures

  test "works have associated object" do
    w1 = works(:one)
    r1 = w1.try(:reference)
    assert r1.is_a?(Work::Reference)
    assert r1.respond_to?(:work)
    assert_equal w1, r1.try(:work)
  end
  
  def parent
    @parent ||= Work.create({
      title: "Parent",
      publisher: Publisher.create(name: "Publisher"),
      year_of_publication: 2001,
      year_of_composition: 2000
    })
  end

  def child
    @child ||= Work.create(title: "Child", parent: parent)
  end

  test "parent fallback on publisher_name" do
    assert_equal("Publisher", child.reference.publisher_name)
  end

  test "short_title" do
    w1 = Work.create(title: "The Legend of Sleepy Hollow")
    assert_equal "Legend of Sleepy Hollow", w1.reference.short_title
  end

  test "long_title" do
    w1 = Work.create({title: "My Simple Book"})
    w2 = Work.create({title: "My Pretentious Book", subtitle: "An Example"})
    w3 = Work.create({title: "My Annoying Book", subtitle: "An Example", supertitle: "The Great Books"})

    assert_equal "My Simple Book", w1.reference.long_title
    assert_equal "My Pretentious Book: An Example", w2.reference.long_title
    assert_equal "The Great Books: My Annoying Book: An Example", w3.reference.long_title
  end

  test "parent fallback on year_of_publication" do
    assert_equal(2001, parent.reference.year_of_publication)
    assert_equal(2001, child.reference.year_of_publication) 
  end

  test "parent falback on year_of_composition" do
    assert_equal(2000, parent.reference.year_of_composition)
    assert_equal(2000, child.reference.year_of_composition) 
  end

  test "language_or_translation with translation" do
    subject = theban_plays.children.first
    result = subject.reference.language_or_translation
    expected = "English, translated from Greek"
    assert_equal(expected, result)
  end

  test "language_or_translation without translation" do
    subject = logic_vsi
    result = subject.reference.language_or_translation
    expected = "English"
    assert_equal(expected, result)
  end

  test "byline includes various producers" do
    work = theban_plays
    result = work.reference.byline
    expected = "Meineck and Woodruff, 2003"
    assert_equal expected, result
  end

  test "byline falls back to year of composition before parent" do
    work = antigone
    result = work.reference.byline
    expected = "Sophocles, 441 BCE"
    assert_equal expected, result
  end

  test "byline includes relevant dates" do
    work = logic_vsi
    result = work.reference.byline
    expected = "Priest, 2017"
    assert_equal expected, result
  end

  test "full_title_line with date" do
    subject = logic_vsi
    result = subject.reference.full_title_line
    expected = "Logic: A Very Short Introduction (Priest, 2017)"
    assert_equal(expected, result)
  end

  test "full_title_line without date" do
    subject = Work.create({
      title: "No Date",
      producers: [
        Producer.new({
          full_name: "John Doe"
        })
      ]
    })
    result = subject.reference.full_title_line
    expected = "No Date (Doe)"
    assert_equal(expected, result)
  end

  test "full_title_line without author or date" do
    subject = Work.create({
      title: "No Date or Author"
    })
    result = subject.reference.full_title_line
    expected = "No Date or Author"
    assert_equal(expected, result)
  end

  test "short_title_line" do
    subject = Work.create({
      title: "The Book Of Kells",
      producers: [
        Producer.new({
          full_name: "Medieval Monk"
        })
      ]
    })
    result = subject.reference.short_title_line
    expected = "Book Of Kells (Monk)"
    assert_equal(expected, result)
  end
end