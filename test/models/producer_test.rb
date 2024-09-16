# == Schema Information
#
# Table name: producers
#
#  id            :bigint           not null, primary key
#  bio_link      :string
#  custom_name   :string
#  foreign_name  :string
#  forename      :string
#  middle_name   :string
#  nationality   :string
#  searchable    :tsvector
#  surname       :string
#  works_count   :integer          default(0)
#  year_of_birth :integer
#  year_of_death :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_producers_on_searchable                    (searchable) USING gin
#  producers_forename_surname_year_of_birth_unique  (forename,surname,year_of_birth) UNIQUE
#
require "test_helper"

class ProducerTest < ActiveSupport::TestCase
  test "attribute presence validation" do
    pr1 = Producer.new({
      # empty
    })
    refute pr1.valid?

    expected = ["Custom Name or Forename and Surname must be present."]

    assert_equal expected, pr1.errors.full_messages
    pr1.custom_name = ""
    refute pr1.valid?
    assert_equal expected, pr1.errors.full_messages
  end

  test "either custom_name or forename and surname presence validation" do
    pr1 = Producer.new({
      custom_name: "OK",
      forename: "",
      surname: ""
    })
    assert pr1.valid?

    pr2 = Producer.new({
      custom_name: "",
      forename: "OK",
      surname: "OK"
    })
    assert pr2.valid?
  end

  test "build a new work_producer and link to existing work" do
    work = Work.create({
      title: "Physics"
    })

    producer = Producer.new({
      custom_name: "Aristotle",
      work_producers: [WorkProducer.new({
        role: "author",
        work: work
      })]
    })

    refute producer.works.include?(work)
    producer.save

    assert producer.works.include?(work)
    assert_equal "author", producer.work_producers.find_by(work: work).role
  end

  test "remove existing work_producer" do
    producer = producers(:one)
    work = works(:one)

    assert producer.works.include?(work) # fixture
    work_producer = producer.work_producers.find_by(work: work)

    params = ActionController::Parameters.new({
      producer: {
        custom_name: producer.custom_name,
        work_producers_attributes: {
          "0" => {
            :id => work_producer.id,
            :_destroy => true
          }
        }
      }
    }).require(:producer).permit(:custom_name, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :work_id,
      work_attributes: [:title]
    ])

    producer.update(params)
    refute producer.works.include?(work)
    assert Work.where(id: work.id).exists?
  end

  test "add similar work_producer" do
    producer = producers(:one)
    work = works(:one)
    assert producer.works.include?(work) # fixture
    work_producer = producer.work_producers.find_by(work: work)

    params = ActionController::Parameters.new({
      producer: {
        custom_name: producer.custom_name,
        work_producers_attributes: {
          "0" => {
            # no id
            role: "translator", # not author
            work_id: work.id
          }
        }
      }
    }).require(:producer).permit(:custom_name, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :work_id,
      work_attributes: [:title]
    ])

    producer.update(params)
    assert_equal 2, producer.work_producers.where(work_id: work.id).count
  end

  test "create a work through existing work_producer" do
    producer = producers(:one)
    new_title_param = "New Work"
    params = ActionController::Parameters.new({
      producer: {
        custom_name: producer.custom_name,
        work_producers_attributes: {
          "0" => {
            role: "editor",
            work_attributes: { # only one
              title: new_title_param
            }
          }
        }
      }
    }).require(:producer).permit(:custom_name, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :work_id,
      work_attributes: [:title]
    ])

    refute Work.where(title: new_title_param).exists?
    producer.update(params)
    assert Work.where(title: new_title_param).exists?
    assert producer.works.pluck(:title).include?(new_title_param)
  end

  test "create a work through new work_producer" do
    params = ActionController::Parameters.new({
      producer: {
        custom_name: "Plato",
        work_producers_attributes: {
          "0" => {
            role: "author",
            work_attributes: {
              title: "Republic"
            }
          },
          "1" => {
            role: "author",
            work_attributes: {
              title: "Apology"
            }
          }
        }
      }
    }).require(:producer).permit(:custom_name, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :work_id,
      work_attributes: [:title]
    ])

    producer = Producer.new(params)

    refute Producer.where(custom_name: "Plato").exists?
    refute Work.where(title: "Republic").exists?
    refute Work.where(title: "Apology").exists?

    producer.save

    assert Producer.where(custom_name: "Plato").exists?
    assert Work.where(title: "Republic").exists?
    assert Work.where(title: "Apology").exists?

    assert producer.works.pluck(:title).include?("Republic")
    assert producer.works.pluck(:title).include?("Apology")
  end

  test "validation on associated work_producer" do
    p1 = Producer.new({
      custom_name: "New Producer",
      work_producers: [
        WorkProducer.new({
          role: :author
        })
      ]
    })

    refute p1.valid?
    assert_equal ["Work producers work must exist"], p1.errors.full_messages
  end

  test "validation on associated work" do
    p1 = Producer.new({
      custom_name: "New Producer",
      work_producers: [
        WorkProducer.new({
          role: :author,
          work: Work.new({
            # empty
          })
        })
      ]
    })

    refute p1.valid?
    assert_equal ["Work producers work title can't be blank"], p1.errors.full_messages
  end

  test "works counter_cache" do
    p1 = Producer.create(custom_name: "Plutarch")
    assert_equal 0, p1.works.count
    assert_equal 0, p1.works_count # column default

    w1 = p1.works.create({ title: "Life of Dion" })
    assert_equal 1, p1.works.count
    assert_equal 1, p1.works_count

    w2 = p1.works.create({ title: "Life of Timoleon" })
    assert_equal 2, p1.works.count
    assert_equal 2, p1.works_count

    w2.destroy
    p1.reload
    assert_equal 1, p1.works.count
    assert_equal 1, p1.works_count
  end

  def subject1
    @subject1 ||= Producer.create(forename: "Jeff", surname: "Davis")
  end

  def subject2
    @subject2 ||= Producer.create(forename: "Geoff", surname: "Davis")
  end

  def subject3
    @subject3 ||= Producer.create(forename: "Elinor", surname: "Mason")
  end

  test "full-text indexed search with dmetaphone" do
    p1 = subject1
    p2 = subject2
    search1 = Producer.search_name("Jeff")

    assert p1.in?(search1)
    assert p2.in?(search1)


    # Trigrams
    p3 = Producer.create(forename: "Jeffrey", surname: "Davis")
    p4 = Producer.create(forename: "Geoffrey", surname: "Davis")
    p5 = Producer.create(forename: "George", surname: "Davis")

    assert p3.in?(search1) # prefix
    refute p4.in?(search1) # not smart about metaphone + prefix (OK)
    refute p5.in?(search1)

    search2 = Producer.search_name("Jeffrey")

    refute p1.in?(search2)
    refute p2.in?(search2)
    assert p3.in?(search2)
    assert p4.in?(search2)
    refute p5.in?(search2)
  end

  test "search by name is case-insensitive" do
    p1 = subject1
    search1 = Producer.search_name("Jeff")
    assert p1.in?(search1)

    search2 = Producer.search_name("jeff")
    assert p1.in?(search2)
  end

  test "search by partial name" do
    p3 = subject3
    search1 = Producer.search_name("Elinor")
    assert p3.in?(search1)

    search2 = Producer.search_name("Eli")
    assert p3.in?(search2)
  end

  test "unique by full name and year" do
    p1 = producers(:six)
    p2 = Producer.new(forename: p1.forename, surname: p1.surname, year_of_birth: p1.year_of_birth)
    refute p2.valid?
    assert_equal "Name and Birth Year must be unique", p2.errors.full_messages.to_sentence
    assert_raises ActiveRecord::RecordNotUnique do
      p2.save(validate: false)
    end
  end
end
