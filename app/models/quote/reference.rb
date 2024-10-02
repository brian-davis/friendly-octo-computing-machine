class Quote::Reference < ActiveRecord::AssociatedObject
  # REFACTOR: bad pattern
  def chicago_note(length = :long)
    work = quote.work
    case length
    when :long
      @chicago_note_long ||= Citation::Chicago::Note.new(work, quote).long
    when :short
      @chicago_note_short ||= Citation::Chicago::Note.new(work, quote).short
    end
  end
end