require "test_helper"

class WorksHelperTest < ActiveSupport::TestCase
  include ApplicationHelper
  include WorksHelper
  include ActionView::Helpers::TagHelper

  test "byline includes various producers" do
    work = theban_plays
    result = byline(work)
    expected = "Meineck and Woodruff, 135 CE"
    assert_equal expected, result
  end

  test "byline includes relevant dates" do
    work = logic_vsi
    result = byline(work)
    expected = "Priest, 2017"
    assert_equal expected, result
  end

  test "rating_stars" do
    expected = "<span class=\"quantity\">★★★☆☆</span>"
    result = rating_stars(logic_vsi)
    assert_equal expected, result
  end

  test "language_line with translation" do
    subject = theban_plays.children.first
    result = language_line(subject)
    expected = "English, translated from Greek"
    assert_equal(expected, result)
  end

  test "language_line without translation" do
    subject = logic_vsi
    result = language_line(subject)
    expected = "English"
    assert_equal(expected, result)
  end

  test "full_title_line with date" do
    subject = logic_vsi
    result = full_title_line(subject)
    expected = "Logic: A Very Short Introduction (Priest, 2017)"
    assert_equal(expected, result)
  end

  test "full_title_line without date" do
    subject = Work.create({
      title: "No Date",
      authors: [Producer.new({
        full_name: "John Doe"
      })]
    })
    result = full_title_line(subject)
    expected = "No Date (Doe)"
    assert_equal(expected, result)
  end

  test "full_title_line without author or date" do
    subject = Work.create({
      title: "No Date or Author"
    })
    result = full_title_line(subject)
    expected = "No Date or Author"
    assert_equal(expected, result)
  end

  private

  def sophocles
    @sophocles ||= Producer.new({
      custom_name: "Sophocles",
      year_of_birth: -495,
      year_of_death: -405
    })
  end

  def theban_plays
    @theban_plays ||=  Work.create({
      title: "Theban Plays",
      year_of_composition: 135,
      year_of_publication: 2003,
      language: "English",
      original_language: "Greek",
      tags: ["Classics", "Tragedy", "Drama"],

      publisher: Publisher.new({
        name: "Hacket Publishing Company, Inc."
      }),

      children: [
        Work.new({
          title: "Antigone",
          year_of_composition: -441,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            })
          ]
        }),
        Work.new({
          title: "Oedipus Tyrannus",
          year_of_composition: -428,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            })
          ]
        }),
        Work.new({
          title: "Oedipus at Colonus",
          year_of_composition: -411,
          language: "English",
          original_language: "Greek",
          tags: ["Classics", "Tragedy", "Drama"],
          format: :chapter,
          work_producers: [
            WorkProducer.new({
              role: :author,
              producer: sophocles
            })
          ]
        }),
      ],

      work_producers: [
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Peter Meineck"
          })
        }),
        WorkProducer.new({
          role: :translator,
          producer: Producer.new({
            full_name: "Paul Woodruff"
          })
        })
      ]
    })
  end

  def logic_vsi
    @logic_vsi ||= Work.create({
      title: "Logic",
      subtitle: "A Very Short Introduction",
      year_of_publication: 2017,
      rating: 3,
      language: "English",
      tags: ["Philosophy", "Logic", "Oxford VSI"],

      publisher: Publisher.create({
        name: "Oxford University Press"
      }),

      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            full_name: "Graham Priest"
          })
        })
      ]
    })
  end
end