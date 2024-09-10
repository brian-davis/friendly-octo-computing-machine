require "test_helper"

class WorkSearchTest < ActiveSupport::TestCase
  def subject1
    @subject1 ||= Work.create({
      title: "After The Ice",
      subtitle: "A Global Human History 20,000-5,000 BC",
      alternate_title: "",
      foreign_title: ""
    })
  end

  def subject2
    @subject2 ||= Work.create({
      title: "King Ottokar's Sceptre",
      supertitle: "The Adventures of Tintin",
    })
  end

  def subject3
    @subject3 ||= Work.create({
      title: "Les Aventures De Tintin",
      subtitle: "Tintin Au Tibet",
    })
  end

  def subject4
    @subject4 ||= Work.create({
      title: "The Mysterious Book",
      subtitle: "Tintin Example",
    })
  end

  test "accent-less search" do
    e1 = works(:with_date_of_accession) # Astérix
    e2 = works(:without_date_of_accession) # Asterix

    r1 = Work.search_title("Asterix") # start of title
    refute e1.in?(r1) # TODO: find foreign-character workaround
    assert e2.in?(r1)
  end

  test "search_title pg_search_scope matches partial term" do
    term = subject1.title # save the object

    result1 = Work.search_title(term) # exact, full-string search
    assert subject1.in?(result1)

    # 'After' is a stop-word!
    result2 = Work.search_title("After")
    refute subject1.in?(result2) # TODO: make this an exception?

    result3 = Work.search_title("Ice")
    assert subject1.in?(result3)
  end

  test "search is case insensitive" do
    term = subject1.title # save the object

    result1 = Work.search_title(term) # exact, full-string search
    assert subject1.in?(result1)

    result2 = Work.search_title(term.upcase) # exact, full-string search
    assert subject1.in?(result2)

    result3 = Work.search_title(term.downcase) # exact, full-string search
    assert subject1.in?(result2)

    result4 = Work.search_title("ice") # partial, case-insensitive search
    assert subject1.in?(result4)
  end

  test "search title, subtitle, supertitle" do
    result = Work.search_title("Tintin")
    subjects = [subject2, subject3, subject4]
    binding.irb
    subjects.each do |subject|
      assert subject.in?(result)
    end
  end
end



# https://github.com/Casecommons/pg_search?tab=readme-ov-file#dmetaphone-double-metaphone-soundalike-search

# https://www.freecodecamp.org/news/fuzzy-string-matching-with-postgresql/

# https://github.com/Casecommons/pg_search

# https://pganalyze.com/blog/full-text-search-ruby-rails-postgres

# https://www.freecodecamp.org/news/fuzzy-string-matching-with-postgresql/

# https://www.postgresql.org/docs/current/fuzzystrmatch.html

# https://github.com/Casecommons/pg_search?tab=readme-ov-file#pg_search_scope