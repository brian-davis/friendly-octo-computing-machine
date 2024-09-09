module Citation
  class Base
    attr_reader :work

    def initialize(work)
      @work = work
    end

  protected

    # full names
    def producer_names(role = :author)
      role_method = role.to_s.pluralize
      work.send(role_method).pluck_full_name.to_sentence
    end

    # last names only
    def producer_last_names(role = :author)
      role_method = role.to_s.pluralize
      work.send(role_method).pluck_last_name.to_sentence
    end
  end
end