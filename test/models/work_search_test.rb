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
    french_work = works(:foreign_character_title) # Astérix
    english_work = works(:without_foreign_character_title) # Asterix

    english_search = Work.search_title("Asterix")
    french_search = Work.search_title("Astérix")

    # POSTGRESQL unaccent excension provides this function
    # This is a simple string function which maps foreign accent characters to
    # the accentless English character.
    
    # In this version:
    like_search_french = Work.where("unaccent(title) LIKE unaccent(?)", "%Astérix%")
    # the second `unaccent()` reduces the user input search term accented e down to an English e,
    # and the first `unaccent()` reduces the saved column values accented e down to an English e

    # In this version:
    like_search_english = Work.where("unaccent(title) LIKE unaccent(?)", "%Asterix%")
    # the second `unaccent()` redundantly reduces the user input search term unaccented e down to an English e,
    # and the first `unaccent()` reduces the saved column values accented e down to an English e

    # This is what we want:
    assert french_work.in?(like_search_french)
    assert english_work.in?(like_search_french)
    assert french_work.in?(like_search_english)
    assert english_work.in?(like_search_english)

    # Can we avoid a LIKE query, and also use the extra pg_search gem functionality?
    pg_search_english = Work.search_title("Asterix")
    pg_search_french = Work.search_title("Astérix")
    
    # pg_search {ignoring: :accent} option gets us 1/2-way there.
    # Foreign character in search term param is reduced to English
    # character, English work will be found in both searches. 
    
    # This gem allows for defining multi-column searching, with other
    # special options.  With `against: {...}` we can define multiple
    # columns (which aren't being explicitly tested here, although :title is
    # included).  This will work:    
    
    assert english_work.in?(pg_search_french)
    assert english_work.in?(pg_search_english)

    # assert french_work.in?(pg_search_french)  # fails with original tsvector
    # assert french_work.in?(pg_search_english) # fails with original tsvector
    
    # Because the option is reducing the user input search term, then
    # doing the equivalent of a LIKE behind the scenes, also unaccenting there.

    # BUT if we are using the tsvector index options
    # for performance gains, then the results are dependent on the values
    # saved to the index (triggered on save or update).  The foreign
    # character must be indexed without accents, the equivalent of the
    # `unaccent(?)` part of the `LIKE` query above.  Enabling 
    # `{ tsvector_column: "searchable" }` option on the model will
    # fail the previous tests, essentially overriding the previous
    # option (assume you have built the same logic into a migration to
    # build the index).  The `unaccent()` function must be
    # built into the db/migrate/20240813213517_add_pg_search_indexes.rb
    # migration, or equivalent.
    
    # https://stackoverflow.com/a/50595181/21928926

    # TODO: implement above solution.
  end

  test "search_title pg_search_scope matches partial term" do
    term = subject1.title # save the object

    result1 = Work.search_title(term) # exact, full-string search
    assert subject1.in?(result1)

    result2 = Work.search_title("After")
    # refute subject1.in?(result2) # 'After' is a stop-word!

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