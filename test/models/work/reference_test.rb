require "test_helper"

class ReferenceTest < ActiveSupport::TestCase
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
end