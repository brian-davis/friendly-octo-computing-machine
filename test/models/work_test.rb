# == Schema Information
#
# Table name: works
#
#  id                  :bigint           not null, primary key
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  publisher_id        :bigint
#  subtitle            :string
#  alternate_title     :string
#  foreign_title       :string
#  year_of_composition :integer
#  year_of_publication :integer
#  language            :string
#  original_language   :string
#  tags                :string           default([]), is an Array
#  searchable          :tsvector
#  rating              :integer
#  format              :integer          default("book")
#  custom_citation     :string
#
require "test_helper"

class WorkTest < ActiveSupport::TestCase
  test "attribute validation" do
    w1 = Work.new({
      # empty
    })
    refute w1.valid?
    assert_equal ["Title can't be blank"], w1.errors.full_messages
  end

  test "build a new work_producer and link to existing producer" do
    work1 = works(:one)
    producer1 = producers(:two)

    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            role: "translator",
            producer_id: producer1.id
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])

    refute work1.producers.include?(producer1)
    work1.update(params1)

    assert work1.producers.include?(producer1)
    assert_equal "translator", work1.work_producers.find_by(producer: producer1).role
  end

  test "remove existing work_producer" do
    work1 = works(:one)
    producer1 = producers(:one)
    assert work1.producers.include?(producer1) # fixture
    work_producer1 = work1.work_producers.find_by(producer: producer1)

    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            :id => work_producer1.id,
            :_destroy => true
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])

    work1.update(params1)
    refute work1.producers.include?(producer1)
    assert Producer.where(id: producer1.id).exists?
  end

  test "add similar work_producer" do
    work1 = works(:one)
    producer1 = producers(:one)
    assert work1.producers.include?(producer1) # fixture
    work_producer1 = work1.work_producers.find_by(producer: producer1)

    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            # no id
            role: "translator", # not author
            producer_id: producer1.id
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])

    work1.update(params1)
    assert_equal 2, work1.work_producers.where(producer_id: producer1.id).count
  end

  test "create a producer through work_producer" do
    work1 = works(:one)
    new_name_param = "apoinvwljnawlk3tnq2l3kn"
    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            role: "editor",
            producer_attributes: { # only one
              name: new_name_param
            }
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])

    refute Producer.where(name: new_name_param).exists?
    work1.update(params1)
    assert Producer.where(name: new_name_param).exists?
    assert work1.producers.pluck(:name).include?(new_name_param)
  end

  test "validation on associated work_producer" do
    w1 = Work.new({
      title: "New Work",
      work_producers: [
        WorkProducer.new({
          role: :author
        })
      ]
    })

    refute w1.valid?
    assert_equal ["Work producers producer must exist"], w1.errors.full_messages
  end

  test "validation on associated producer" do
    w1 = Work.new({
      title: "New Work",
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            # empty
          })
        })
      ]
    })

    refute w1.valid?
    assert_equal ["Work producers producer name can't be blank"], w1.errors.full_messages
  end

  test "no duplicate producer on re-submit" do
    # Initial form submit
    params1 = ActionController::Parameters.new({
      work: {
        title: "First Work",
        work_producers_attributes: {
          "0" => {
            role: "author",
            producer_attributes: {
              name: "First Author"
            }
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])
    w1 = Work.new(params1)
    assert w1.save
    assert_equal 1, Work.where(title: "First Work").count
    assert_equal 1, Producer.where(name: "First Author").count
    assert_equal 1, w1.producers.count
    assert_equal 1, w1.work_producers.count

    p1 = w1.producers.first
    wp1 = w1.work_producers.first

    # 2nd form submit, adds a new author, re-submits old data (should ignore)

    params2 = ActionController::Parameters.new({
      work: {
        title: "First Work",
        work_producers_attributes: {
          "0" => {
            id: wp1.id,
            :_destroy => "0",
            :_producer_name => "First Producer" # display only, ignore
          },
          "1" => {
            role: "translator",
            producer_attributes: {
              name: "First Translator"
            }
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])
    assert w1.update(params2)

    assert_equal 1, Work.where(title: "First Work").count
    assert_equal 1, Producer.where(name: "First Author").count
    # binding.irb
    assert_equal 1, Producer.where(name: "First Translator").count
    assert_equal 2, w1.producers.count
    assert_equal 2, w1.work_producers.count
  end

  test "no duplicate work producers; unique by id and role" do
    # Initial form submit
    params1 = ActionController::Parameters.new({
      work: {
        title: "First Work",
        work_producers_attributes: {
          "0" => {
            role: "author",
            producer_attributes: {
              name: "First Author"
            }
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])
    w1 = Work.new(params1)
    assert w1.save
    assert_equal 1, Work.where(title: "First Work").count
    assert_equal 1, Producer.where(name: "First Author").count
    assert_equal 1, w1.producers.count
    assert_equal 1, w1.work_producers.count

    p1 = w1.producers.first
    wp1 = w1.work_producers.first

    # 2nd form submit, reselect the same author and role

    params2 = ActionController::Parameters.new({
      work: {
        title: "First Work",
        work_producers_attributes: {
          "0" => {
            id: wp1.id,
            :_destroy => "0",
            :_producer_name => "First Producer" # display only, ignore
          },
         "1" => { # same as before, should ignore
            role: "author",
            producer_id: p1.id,
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])
    refute w1.update(params2)
    assert_equal ["Work producers Must be unique by role"], w1.errors.full_messages

    assert_equal 1, Work.where(title: "First Work").count
    assert_equal 1, Producer.where(name: "First Author").count

    assert_equal 1, w1.producers.count
    assert_equal 1, w1.work_producers.count
  end

  test "build publisher with new work" do
    attrs = {
      title: "New Work",
      publisher: Publisher.new({
        name: "New Publisher"
      })
    }
    refute Work.exists?({ title: "New Work" })
    refute Publisher.exists?({ name: "New Publisher" })

    Work.create(attrs)

    assert Work.exists?({ title: "New Work" })
    assert Publisher.exists?({ name: "New Publisher" })

    w1 = Work.find_by({ title: "New Work" })
    assert_equal "New Publisher", w1.publisher.name
  end

  test "build quote with new work" do
    attrs = {
      title: "Fairy Tales",
      quotes: [Quote.new({
        text: "Once Upon A Time..."
      })]
    }
    refute Work.exists?({ title: "Fairy Tales" })
    refute Quote.exists?({ text: "Once Upon A Time..." })

    Work.create(attrs)

    assert Work.exists?({ title: "Fairy Tales" })
    assert Quote.exists?({ text: "Once Upon A Time..." })

    w1 = Work.find_by({ title: "Fairy Tales" })
    assert "Once Upon A Time...".in?(w1.quotes.pluck(:text))
  end

  test "build quote with nested params" do
    work1 = works(:one)

    params1 = ActionController::Parameters.new({
      work: {
        quotes_attributes: {
          "0" => {
            text: "Once Upon A Time...",
            page: 1,
            custom_citation: "1a"
          }
        }
      }
    }).require(:work).permit(:title, quotes_attributes: [
      :id,
      :_destroy,
      :text,
      :page,
      :custom_citation
    ])

    refute "Once Upon A Time...".in?(work1.quotes.pluck(:text))
    work1.update(params1)
    assert work1.quotes.any?
    assert "Once Upon A Time...".in?(work1.quotes.pluck(:text))
  end

  # https://github.com/Casecommons/pg_search?tab=readme-ov-file#pg_search_scope
  test "full-text indexed search" do
    work1 = Work.create(title: "Sandwiches are Delicious")
    work2 = Work.create(title: "The Sandwich and the Hare")
    work3 = Work.create(title: "The Sand In The Sallows")

    search1 = Work.search_title("Sand")

    assert work1.in?(search1)
    assert work2.in?(search1)
    assert work3.in?(search1)
  end

  test "authors are returned in the order the join model is created" do
    work = works(:no_authors)
    work.producers << producers(:three)
    work.producers << producers(:one)
    work.producers << producers(:two)

    work.save & work.reload

    assert_equal ["ProducerThree", "ProducerOne", "ProducerTwo"], work.producers.pluck(:name)
  end

  # no translators, editors, etc.
  test "authors scope" do
    work = works(:no_authors)
    work.work_producers.build producer: producers(:three), role: :author
    work.work_producers.build producer: producers(:two), role: :editor
    work.work_producers.build producer: producers(:one), role: :translator

    work.save & work.reload

    assert_equal ["ProducerThree"], work.authors.pluck(:name)
  end

  test "self-join" do
    parent = Work.create({
      format: "book",
      title: "A Compilation"
    })

    child1 = Work.create({
      format: "chapter",
      title: "Chapter 1",
      parent_id: parent.id
    })

    child2 = Work.create({
      format: "chapter",
      title: "Chapter 2",
      parent_id: parent.id
    })

    assert child1.in?(parent.children)
    assert_equal parent, child1.parent
    assert_equal parent, child2.parent
  end

  # CITATIONS

  def citation_work_fixture
    @citation_work_fixture ||= Work.create({
      title: "Interior Chinatown",
      format: "book",
      year_of_publication: 2020,
      publisher: Publisher.new({
        name: "Pantheon Books"
      }),
      work_producers: [
        WorkProducer.new({
          role: :author,
          producer: Producer.new({
            name: "Charles Yu"
          })
        })
      ]
    })
  end

  test "bibliography citation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Yu, Charles. _Interior Chinatown_. Pantheon Books, 2020."
    assert_equal expected, citation_work_fixture.bibliography_markdown
  end

  def citation_work_fixture2
    @citation_work_fixture2 ||= Work.create({
      title: "The Channels of Student Activism",
      subtitle: "How the Left and Right Are Winning (and Losing) in Campus Politics Today",
      year_of_publication: 2022,
      publisher: Publisher.new({
        name: "University of Chicago Press"
      }),
      work_producers: [
        WorkProducer.new({
          role: :co_author,
          producer: Producer.new({
            name: "Amy J. Binder"
          })
        }),
        WorkProducer.new({
          role: :co_author,
          producer: Producer.new({
            name: "Jeffrey L. Kidder"
          })
        })
      ]
    })
  end

  test "bibliography citation multiple authors" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-book

    expected = "Binder, Amy J., and Jeffrey L. Kidder. _The Channels of Student Activism: How the Left and Right Are Winning (and Losing) in Campus Politics Today_. University of Chicago Press, 2022."
    result = citation_work_fixture2.bibliography_markdown
    assert_equal expected, result
  end

  test "bibliography citation chapter in compilation" do
    # https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html#cg-chapter
    # In some cases, you may want to cite the collection as a whole instead.
    # P. J. M. Marks and Stephen Parkin, eds., The Book by Design: The Remarkable Story of the World’s Greatest Invention (University of Chicago Press, 2023).

    compilation = Work.create({
      title: "The Book by Design",
      subtitle: "The Remarkable Story of the World’s Greatest Invention",
      year_of_publication: 2023,
      format: :compilation,

      publisher: Publisher.new({
        name: "University of Chicago Press"
      }),

      work_producers: [
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            name: "P. J. M. Marks"
          })
        }),
        WorkProducer.new({
          role: :editor,
          producer: Producer.new({
            name: "Stephen Parkin"
          })
        }),
      ]
    })

    expected = "P. J. M. Marks and Stephen Parkin, eds., _The Book by Design: The Remarkable Story of the World’s Greatest Invention_ (University of Chicago Press, 2023)."

    result = compilation.bibliography_markdown

    assert_equal expected, result
  end

  test "bibliography for translated book (western name)" do
    work = Work.create({
      title: "The Wedding Party",
      format: "book",
      year_of_publication: 2021,
      publisher: Publisher.new({
        name: "Amazon Crossing"
      }),
      work_producers: [
        WorkProducer.new({
          role: "translator",
          producer: Producer.new({
            name: "Jeremy Tiang"
          })
        }),
        WorkProducer.new({
          role: "author",
          producer: Producer.new({
            name: "John Smith"
          })
        })
      ]
    })
    result = work.bibliography_markdown
    expected = "Smith, John. _The Wedding Party_. Translated by Jeremy Tiang. Amazon Crossing, 2021."
    assert_equal(expected, result)
  end
end
