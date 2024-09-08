module Citation
  class Base
    attr_reader :work

    def initialize(work)
      @work = work
    end

    # REFACTOR: avoid passing in work argument
    def alpha_producer_names(role = :authors)
      first_author_name = work.send(role).limit(1).pluck_alpha_name
      rest_author_names = work.send(role).offset(1).pluck_full_name
      author_names = (first_author_name + rest_author_names).to_sentence({ two_words_connector: ", and "})
    end

    def producer_names(role = :authors)
      work.send(role).pluck_full_name.to_sentence
    end

    def producer_last_names(role = :authors)
      work.send(role).pluck_last_name.to_sentence
    end
  end
end