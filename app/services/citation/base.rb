module Citation
  class Base
    def alpha_producer_names(work, role = :authors)
      authors = work.send(role).select(:id, :custom_name, :given_name, :middle_name, :family_name).to_a
      first_author = authors.shift

      first_author_name = first_author.custom_name.presence || [
        first_author.family_name,
        [
          first_author.given_name,
          first_author.middle_name
        ].map(&:presence).compact.join(" ")
      ].map(&:presence).compact.join(", ")

      rest_author_names = authors.map { |a| a.custom_name.presence || [a.given_name, a.middle_name, a.family_name].map(&:presence).compact.join(" ") }
      author_names = ([first_author_name] + rest_author_names).to_sentence({ two_words_connector: ", and "})
    end

    def producer_names(work, role = :authors)
      work.send(role).pluck_full_name
    end

    def producer_last_names(work, role = :authors)
      work.send(role).select(:id, :custom_name, :given_name, :middle_name, :family_name).map { |a| a.custom_name.presence || a.family_name }.to_sentence
    end

    def short_title(work)
      work.title.sub("The ", "")
    end

    # TODO: DRY with works_helper.rb :title_line
    def long_title(work)
      [work.supertitle, work.title, work.subtitle].map(&:presence).compact.join(": ")
    end
  end
end