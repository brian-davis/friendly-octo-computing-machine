# == Schema Information
#
# Table name: quotes
#
#  id              :bigint           not null, primary key
#  custom_citation :string
#  page            :string
#  searchable      :tsvector
#  text            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  work_id         :bigint           not null
#
# Indexes
#
#  index_quotes_on_searchable  (searchable) USING gin
#  index_quotes_on_work_id     (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#
require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  test "validates text" do
    q1 = works(:one).quotes.build({
      text: "",
      custom_citation: "1a",
      page: 1
    })
    refute q1.valid?
    assert_equal ["Text can't be blank"], q1.errors.full_messages
  end

  test "full-text indexed search" do
    work = Work.create(title: "Sandwich")
    quote1 = work.quotes.create(text: "lettuce")
    quote2 = work.quotes.create(text: "lettuce and bacon and more lettuce")
    quote3 = work.quotes.create(text: "lettuce and bacon and tomato")

    search1 = Quote.search_text("tomato")
    assert (quote3).in?(search1)
    refute (quote2).in?(search1)
    refute (quote1).in?(search1)

    search2 = Quote.search_text("lettuce")
    assert (quote3).in?(search2)
    assert (quote2).in?(search2)
    assert (quote1).in?(search2)

    # ranking
    assert search2.index(quote2) < search2.index(quote1)
    assert search2.index(quote2) < search2.index(quote3)
  end

  test "full-text indexed search by prefix" do
    work = Work.create(title: "Sandwich")
    quote1 = work.quotes.create(text: "lettuce")
    quote2 = work.quotes.create(text: "don't let me down")

    search1 = Quote.search_text("lettuce")
    assert (quote1).in?(search1)
    refute (quote2).in?(search1)

    search2 = Quote.search_text("let")
    assert (quote1).in?(search2)
    assert (quote2).in?(search2)
  end

  test "full-text indexed search with negation" do
    work = Work.create(title: "Sandwich")
    quote1 = work.quotes.create(text: "lettuce and tomato")
    quote2 = work.quotes.create(text: "lettuce and salt")

    search1 = Quote.search_text("lettuce")
    assert (quote1).in?(search1)
    assert (quote2).in?(search1)

    search2 = Quote.search_text("lettuce !tomato")
    refute (quote1).in?(search2)
    assert (quote2).in?(search2)
  end

  test "full-text indexed search with stemming" do
    work = Work.create(title: "Doing something")
    quote1 = work.quotes.create(text: "He is sleeping.")
    quote2 = work.quotes.create(text: "He sleeps.")
    quote3 = work.quotes.create(text: "Sleep is very important")

    search1 = Quote.search_text("sleeping")
    assert (quote1).in?(search1)
    assert (quote2).in?(search1)
    assert (quote3).in?(search1)
  end
end
