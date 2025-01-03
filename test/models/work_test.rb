# == Schema Information
#
# Table name: works
#
#  id                  :bigint           not null, primary key
#  accession_note      :text
#  alternate_title     :string
#  article_date        :date
#  article_page_span   :string
#  condition           :integer
#  cover               :integer
#  custom_citation     :string
#  date_of_accession   :date
#  date_of_completion  :date
#  foreign_title       :string
#  interviewer_name    :string
#  journal_issue       :integer
#  journal_name        :string
#  journal_volume      :integer
#  language            :string
#  media_date          :date
#  media_format        :string
#  media_source        :string
#  media_timestamp     :string
#  online_source       :string
#  original_language   :string
#  publishing_format   :enum             default("book")
#  rating              :integer
#  review_author       :string
#  review_title        :string
#  searchable          :tsvector
#  series_ordinal      :integer
#  subtitle            :string
#  supertitle          :string
#  tags                :string           default([]), is an Array
#  title               :string
#  url                 :string
#  wishlist            :boolean          default(FALSE)
#  year_of_composition :integer
#  year_of_publication :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  parent_id           :bigint
#  publisher_id        :bigint
#
# Indexes
#
#  index_works_on_parent_id          (parent_id)
#  index_works_on_publisher_id       (publisher_id)
#  index_works_on_publishing_format  (publishing_format)
#  index_works_on_searchable         (searchable) USING gin
#  index_works_on_tags               (tags) USING gin
#  index_works_on_wishlist           (wishlist)
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
    work1 = fixture_works_logic_vsi
    producer1 = fixture_producers_peter_meineck

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
    work1 = fixture_works_logic_vsi
    producer1 = fixture_works_logic_vsi.producers.first

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
    work1 = fixture_works_logic_vsi
    producer1 = fixture_works_logic_vsi.producers.first

    # work_producer1 = work1.work_producers.find_by(producer: producer1)

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
    work1 = fixture_works_logic_vsi
    new_name_param = "apoinvwljnawlk3tnq2l3kn"
    params1 = ActionController::Parameters.new({
      work: {
        title: work1.title,
        work_producers_attributes: {
          "0" => {
            role: "editor", # not author
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
    work1 = fixture_works_logic_vsi

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
    work = Work.create({
      title: "Example With No Authors"
    })
    work.producers << fixture_producers_epictetus
    work.producers << fixture_producers_plato
    work.producers << fixture_producers_voltaire

    work.save & work.reload

    assert_equal ["Epictetus", "Plato", "Voltaire"], work.producers.pluck(:custom_name)
  end

  # no translators, editors, etc.
  test "authors scope" do
    work = Work.create({
      title: "Example With No Authors"
    })
    work.work_producers.build({
      producer: fixture_producers_epictetus,
      role: :author
    })

    work.work_producers.build({
      producer: fixture_producers_plato,
      role: :editor
    })

    work.work_producers.build({
      producer: fixture_producers_voltaire,
      role: :translator
    })

    work.save && work.reload

    assert_equal ["Epictetus"], work.authors.pluck(:custom_name)
  end

  test "self-join" do
    parent = fixture_works_philosophy_for_everyone

    # TODO: :chapters alias and/or scope
    child1 = parent.children.first
    child2 = parent.children.second

    assert child1.in?(parent.children)
    assert_equal parent, child1.parent
    assert_equal parent, child2.parent
  end

  test "reading session aggregate minutes" do
    work = fixture_works_oedipus_at_colonus
    _baseline = 1.year.ago
    _rs1 = work.reading_sessions.create({
      pages: 10,
      started_at: _baseline,
      ended_at: _baseline + 10.minutes
    })
    _rs2 = work.reading_sessions.create({
      pages: 10,
      started_at: _baseline + 1.day,
      ended_at: _baseline + 1.day + 10.minutes
    })
    assert_equal(20, work.reading_sessions_minutes)
  end

  # work_producer.rb :validate_parent_role_uniqueness
  test "same author can't be added to work twice" do
    work = fixture_works_meet_me_in_atlantis
    producer = work.authors.first
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
              "full_name"=> producer.full_name
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

  test "order_by_title sorting is case-insensitive" do
    w1 = Work.create(title: "asdf")
    w2 = Work.create(title: "Astronomy For Everyone")
    w3 = Work.create(title: "Be Here Now")

    result = Work.where(id: [w1.id, w2.id, w3.id]).order_by_title.pluck(:title)
    expected_refute = ["Astronomy For Everyone", "Be Here Now", "asdf"]
    refute_equal expected_refute, result

    expected = ["asdf", "Astronomy For Everyone", "Be Here Now"]
    assert_equal expected, result
  end

  def tolkien1
    @tolkien1 ||= Work.create({
      title: "The Fellowship Of The Ring",
      supertitle: "The Lord Of The Rings",
      series_ordinal: 1
    })
  end

  def tolkien2
    @tolkien2 ||= Work.create({
      title: "The Two Towers",
      supertitle: "The Lord Of The Rings",
      series_ordinal: 2
    })
  end

  def tolkien3
    @tolkien3 ||= Work.create({
      title: "The Return Of The King",
      supertitle: "The Lord Of The Rings",
      series_ordinal: 3
    })
  end

  def tolkien4
    @tolkien4 ||= Work.create({
      title: "The Hobbit", subtitle: "Or There And Back Again"
    })
  end

  def tolkien5
    @tolkien5 ||= Work.create({
      title: "The Silmarilion"
    })
  end

  def tolkien_work_ids
    [tolkien1.id, tolkien2.id, tolkien3.id, tolkien4.id, tolkien5.id]
  end

  test "series_parts" do
    assert tolkien_work_ids # build data
    output = tolkien1.series_parts.pluck_full_title
    # ordered by series_ordinal
    expected = ["The Lord Of The Rings: The Fellowship Of The Ring", "The Lord Of The Rings: The Two Towers", "The Lord Of The Rings: The Return Of The King"]

    assert_equal expected, output
  end

  test "series_parts by subtitle" do
    # like Oxford VSI series
    w2 = Work.create(title: "Topic Two", subtitle: "A Very Short Introduction", series_ordinal: 345)
    w1 = Work.create(title: "Topic One", subtitle: "A Very Short Introduction", series_ordinal: 123)

    output = w1.series_parts.pluck_full_title
    # ordered by series_ordinal
    expected = [w1.reference.full_title, w2.reference.full_title]

    assert_equal expected, output
  end

  test "pluck_full_title" do
    result = Work.where(id: tolkien_work_ids).pluck_full_title.sort
    expected = ["The Hobbit: Or There And Back Again", "The Lord Of The Rings: The Fellowship Of The Ring", "The Lord Of The Rings: The Return Of The King", "The Lord Of The Rings: The Two Towers", "The Silmarilion"]
    assert_equal expected, result
  end

  test "order_by_title includes supertitle, subtitle" do
    w1 = tolkien1
    w2 = tolkien2
    w3 = tolkien3
    w4 = tolkien4
    w5 = tolkien5
    result = Work.where(id: tolkien_work_ids).order_by_title.pluck_full_title
    expected = ["The Hobbit: Or There And Back Again", "The Lord Of The Rings: The Fellowship Of The Ring", "The Lord Of The Rings: The Return Of The King", "The Lord Of The Rings: The Two Towers", "The Silmarilion"]
    assert_equal expected, result
  end

  test "order_by_title includes supertitle, subtitle DESC" do
    w1 = tolkien1
    w2 = tolkien2
    w3 = tolkien3
    w4 = tolkien4
    w5 = tolkien5
    result = Work.where(id: tolkien_work_ids).order_by_title("desc").pluck_full_title
    expected = ["The Silmarilion", "The Lord Of The Rings: The Two Towers", "The Lord Of The Rings: The Return Of The King", "The Lord Of The Rings: The Fellowship Of The Ring", "The Hobbit: Or There And Back Again"]
    assert_equal expected, result
  end

  test "extended_tags_cloud" do
    _subjects = [
      fixture_works_asterix_le_gaulois,
      fixture_works_meet_me_in_atlantis,
      fixture_works_philosophy_for_everyone
    ]
    result = Work.extended_tags_cloud
    
    # [["all", 12, "alt"], ["untagged", 0, "alt"], ["Modern", 10], ["Philosophy", 10], ["Atlantis", 1], ["Classics", 1], ["Comics", 1], ["Mythology", 1]]
    assert result[0][0] == "all"
    assert result[1][0] == "untagged"

    assert result.any? { |a,b,c| a == "Atlantis" }
    assert result.any? { |a,b,c| a == "Comics" }
    assert result.any? { |a,b,c| a == "Philosophy" }
  end

  test "rating_stars" do
    subject1 = Work.new({
      title: "A Work",
      rating: 3
    })
    expected = "★★★☆☆"
    result = subject1.rating_stars
    assert_equal expected, result
  end

  test "wishlist column" do
    w1 = Work.find_or_create_by(title: "defaults")
    refute w1.wishlist # defaults to false

    w2 = Work.find_or_create_by(title: "wishlist item", wishlist: true)
    assert w2.wishlist

    assert w1.in?(Work.collection) # queries wishlist column
    refute w2.in?(Work.collection) # queries wishlist column

    refute w1.in?(Work.wishlist) # queries wishlist column
    assert w2.in?(Work.wishlist) # queries wishlist column
  end

  test "cover enum" do
    expected = {"paperback"=>0, "hardcover"=>1, "large_paperback"=>2, "large_hardcover"=>3}
    output = Work.covers
    assert_equal expected, output
  end

  test "cover enum setter" do
    w1 = Work.create(title: "A Paperback Book", cover: :paperback)
    assert w1.cover_paperback?
    assert_equal "paperback", w1.cover
    assert w1.in?(Work.cover_paperback)

    w1.cover_large_paperback!
    assert w1.cover_large_paperback?
    assert_equal "large_paperback", w1.cover
    assert w1.in?(Work.cover_large_paperback)
  end

  test "condition enum" do
    expected = {"poor"=>0, "fair"=>1, "good"=>2, "very_good"=>3, "excellent"=>4, "mint"=>5}
    output = Work.conditions
    assert_equal expected, output
  end

  test "condition enum setter" do
    w1 = Work.create(title: "An Excellent Book", condition: :excellent)
    assert w1.condition_excellent?
    assert_equal "excellent", w1.condition
    assert w1.in?(Work.condition_excellent)

    w1.condition_very_good!
    assert w1.condition_very_good?
    assert_equal "very_good", w1.condition
    assert w1.in?(Work.condition_very_good)
  end
end
