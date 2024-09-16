# == Schema Information
#
# Table name: works
#
#  id                  :bigint           not null, primary key
#  accession_note      :text
#  alternate_title     :string
#  custom_citation     :string
#  date_of_accession   :date
#  date_of_completion  :date
#  foreign_title       :string
#  format              :integer          default(0)
#  language            :string
#  original_language   :string
#  rating              :integer
#  searchable          :tsvector
#  subtitle            :string
#  supertitle          :string
#  tags                :string           default([]), is an Array
#  title               :string
#  year_of_composition :integer
#  year_of_publication :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  parent_id           :bigint
#  publisher_id        :bigint
#
# Indexes
#
#  index_works_on_format        (format)
#  index_works_on_parent_id     (parent_id)
#  index_works_on_publisher_id  (publisher_id)
#  index_works_on_searchable    (searchable) USING gin
#  index_works_on_tags          (tags) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => works.id)
#  fk_rails_...  (publisher_id => publishers.id)
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
              custom_name: new_name_param
            }
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:custom_name]
    ])

    refute Producer.where(custom_name: new_name_param).exists?
    work1.update(params1)
    assert Producer.where(custom_name: new_name_param).exists?
    assert work1.producers.pluck(:custom_name).include?(new_name_param)
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
    expected = ["Work producers producer Custom Name or Forename and Surname must be present."]
    assert_equal expected, w1.errors.full_messages
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
              custom_name: "First Author"
            }
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:custom_name]
    ])
    w1 = Work.new(params1)
    assert w1.save
    assert_equal 1, Work.where(title: "First Work").count
    assert_equal 1, Producer.where(custom_name: "First Author").count
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
              custom_name: "First Translator"
            }
          }
        }
      }
    }).require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:custom_name]
    ])
    assert w1.update(params2)

    assert_equal 1, Work.where(title: "First Work").count
    assert_equal 1, Producer.where(custom_name: "First Author").count
    assert_equal 1, Producer.where(custom_name: "First Translator").count
    assert_equal 2, w1.producers.count
    assert_equal 2, w1.work_producers.count
  end

  test "no duplicate work producers; unique by id and role" do
    w1 = Work.new({
      title: "First Work",
      work_producers: [WorkProducer.new({
        role: "author",
        producer: Producer.new({
          custom_name: "First Producer"
        })
      })]
    })
    assert w1.save
    assert_equal 1, Work.where(title: "First Work").count
    assert_equal 1, Producer.where(custom_name: "First Producer").count
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
      producer_attributes: [:custom_name]
    ])

    refute w1.update(params2)
    assert_equal ["Work producers Must be unique by role"], w1.errors.full_messages

    assert_equal 1, Work.where(title: "First Work").count
    assert_equal 1, Producer.where(custom_name: "First Producer").count

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

  test "authors are returned in the order the join model is created" do
    work = works(:no_authors)
    work.producers << producers(:three)
    work.producers << producers(:one)
    work.producers << producers(:two)

    work.save & work.reload

    assert_equal ["Epictetus1", "Plato1", "Voltaire1"], work.producers.pluck(:custom_name)
  end

  # no translators, editors, etc.
  test "authors scope" do
    work = works(:no_authors)
    work.work_producers.build producer: producers(:three), role: :author
    work.work_producers.build producer: producers(:two), role: :editor
    work.work_producers.build producer: producers(:one), role: :translator

    work.save & work.reload

    assert_equal ["Epictetus1"], work.authors.pluck(:custom_name)
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

  test "reading session aggregate minutes" do
    work = Work.create({ title: "aggregate counter" })

    _baseline = 1.year.ago

    rs1 = work.reading_sessions.create({
      pages: 10,
      started_at: _baseline,
      ended_at: _baseline + 10.minutes
    })

    rs2 = work.reading_sessions.create({
      pages: 10,
      started_at: _baseline + 1.day,
      ended_at: _baseline + 1.day + 10.minutes
    })

    assert_equal(20, work.reading_sessions_minutes)
  end

  # work_producer.rb :validate_parent_role_uniqueness
  test "same author can't be added to work twice" do
    work = Work.create({
      title: "test1"
    })
    producer = work.authors.create({ full_name: "test producer1" })

    assert_equal 1, work.authors.count
    assert_raises ActiveRecord::RecordInvalid do
      work.authors << producer
    end
    assert_equal 1, work.authors.count

    params = ActionController::Parameters.new(
      "work" => {
        "work_producers_attributes"=>{
          "0"=>{"id"=>"#{producer.id}", "_destroy"=>"0"},
          "1"=>{
            "producer_attributes"=>{
              "custom_name"=>"",
              "full_name"=>"test producer1"
            }
          }
        }
      }
    ).require("work").permit(work_producers_attributes: { producer_attributes: [:custom_name, :full_name]})

    work.assign_attributes(params)
    refute work.valid?
    expected = ["Work producers producer Name and Birth Year must be unique"]
    assert_equal expected, work.errors.full_messages
    assert_equal 1, work.authors.count
  end

  test "date_of_accession" do
    w1 = works(:with_date_of_accession)
    w2 = works(:without_date_of_accession)

    assert w1.in?(Work.collection)
    refute w2.in?(Work.collection)

    assert w2.in?(Work.wishlist)
    refute w1.in?(Work.wishlist)
  end

  test "sorting is case-insensitive" do
    w1 = Work.create(title: "asdf")
    w2 = Work.create(title: "Astronomy For Everyone")
    w3 = Work.create(title: "Be Here Now")

    result = Work.where(id: [w1.id, w2.id, w3.id]).order(Arel.sql("UPPER(title)")).pluck(:title)
    expected_bad_collation = ["Astronomy For Everyone", "Be Here Now", "asdf"]
    refute_equal expected_bad_collation, result

    expected = ["asdf", "Astronomy For Everyone", "Be Here Now"]
    assert_equal expected, result
  end
end
