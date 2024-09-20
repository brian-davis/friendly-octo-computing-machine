require "test_helper"

class ReferenceTest < ActiveSupport::TestCase
  test "works have associated object" do
    w1 = fixture_works_logic_vsi
    r1 = w1.try(:reference)
    assert r1.is_a?(Work::Reference)
    assert r1.respond_to?(:work)
    assert_equal w1, r1.try(:work)
  end
  
  test "parent fallback on publisher_name" do
    subject_parent = fixture_works_theban_plays
    subject_child = fixture_works_antigone

    # setup
    assert_equal("Hacket Publishing Company, Inc.", subject_parent.publisher.name) # attributes
    assert_nil(subject_child.publisher&.name) # attributes

    # test functionality
    assert_equal("Hacket Publishing Company, Inc.", subject_child.reference.publisher_name) # decorator
  end

  test "short_title" do
    w1 = fixture_works_the_baltic_origins
    assert_equal "Baltic Origins Of Homer's Epic Tales", w1.reference.short_title
  end

  test "long_title for subtitle" do
    subtitle_expected = "Information: A Very Short Introduction"
    subtitle_result = fixture_works_information_vsi.reference.long_title
    assert_equal subtitle_expected, subtitle_result 
  end

  test "long_title for supertitle" do
    supertitle_expected = "The Adventures Of Tintin: King Ottokar's Sceptre"
    supertitle_result = fixture_works_tintin_king_ottokar.reference.long_title
    assert_equal supertitle_expected, supertitle_result 
  end

  test "parent falback on year_of_publication" do
    subject_parent = fixture_works_theban_plays # publication 2003
    subject_child = fixture_works_antigone # composition -441

    # setup
    assert_nil(subject_parent.year_of_composition) # attributes
    assert_equal(2003, subject_parent.year_of_publication) # attributes
    assert_equal(-441, subject_child.year_of_composition) # attributes
    assert_nil(subject_child.year_of_publication) # attributes

    # test functionality
    assert_equal(2003, subject_child.reference.year_of_publication) # decorator
  end

  test "language_or_translation with translation" do
    subject = fixture_works_antigone
    result = subject.reference.language_or_translation
    expected = "English, translated from Greek"
    assert_equal(expected, result)
  end

  test "language_or_translation without translation" do
    subject = fixture_works_logic_vsi
    result = subject.reference.language_or_translation
    expected = "English"
    assert_equal(expected, result)
  end

  test "byline includes various producers" do
    work = fixture_works_theban_plays
    result = work.reference.byline
    expected = "Meineck and Woodruff, 2003"
    assert_equal expected, result
  end

  test "byline falls back to year of composition before parent" do
    work = fixture_works_antigone
    result = work.reference.byline
    expected = "Sophocles, 441 BCE"
    assert_equal expected, result
  end

  test "byline includes relevant dates" do
    work = fixture_works_logic_vsi
    result = work.reference.byline
    expected = "Priest, 2017"
    assert_equal expected, result
  end

  test "full_title_line with date" do
    subject = fixture_works_logic_vsi
    result = subject.reference.full_title_line
    expected = "Logic: A Very Short Introduction (Priest, 2017)"
    assert_equal(expected, result)
  end

  test "full_title_line without date" do
    subject = Work.new({
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
    subject = Work.new({
      title: "Generic Title"
    })
    result = subject.reference.full_title_line
    expected = "Generic Title"
    assert_equal(expected, result)
  end

  test "short_title_line" do
    subject = fixture_works_the_baltic_origins
    result = subject.reference.short_title_line
    expected = "Baltic Origins Of Homer's Epic Tales (Vinci and Francesco, 2006)"
    assert_equal(expected, result)
  end

  test "producer_names" do
    subject = fixture_works_theban_plays
    expected = "Peter Meineck and Paul Woodruff"
    result = subject.reference.producer_names(:editor)
    assert_equal(expected, result)
  end

  test "producer_last_names" do
    subject = fixture_works_theban_plays
    expected = "Meineck and Woodruff"
    result = subject.reference.producer_last_names(:editor)
    assert_equal(expected, result)
  end

  test "alpha_producer_names" do
    subject = fixture_works_theban_plays
    # with comma after first entry
    expected = "Meineck, Peter, and Paul Woodruff"
    result = subject.reference.alpha_producer_names(:editor)
    assert_equal(expected, result)
  end
end