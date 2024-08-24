class BookshelfMetrics
  extend ActionView::Helpers::TagHelper
  extend ActionView::Helpers::DateHelper
  extend WorksHelper
  extend ApplicationHelper

  class << self
    def all
      [
        {
          label: "Current Book",
          result: self.current_book
        },
        {
          label: "Newest Book",
          result: self.newest_book
        },
        {
          label: "Most Quoted Book",
          result: most_quoted_book
        },
        {
          label: "Most Noted Book",
          result: most_noted_book
        },
        {
          label: "Most Represented Author",
          result: most_represented_author
        },
        {
          label: "Total Reading Time",
          result: total_reading_time
        },
        {
          label: "Longest Book Reading Time",
          result: longest_book_reading_time
        },
        {
          label: "Longest Author Reading Time",
          result: longest_author_reading_time
        }
      ]
    end

    private

    def current_book
      session = ReadingSession.find_by(ended_at: ReadingSession.maximum(:ended_at))
      return "" unless session
      work = session.work
      tag.i(title_line(work)) + ", #{time_ago_in_words(session.ended_at)} ago"
    end

    def newest_book
      work = Work.find_by(created_at: Work.maximum(:created_at))
      return "" unless work
      tag.i(title_line(work)) + ", #{time_ago_in_words(work.created_at)} ago"
    end

    def most_quoted_book
      id, count = Work
                    .joins(:quotes)
                    .group("quotes.work_id")
                    .count
                    .max_by { |w, c| c }
      work = Work.find_by({ id: id })
      tag.i(title_line(work)) + ", #{count} quotes"
    end

    def most_noted_book
      id, count = Work
                    .joins(:notes)
                    .group("notes.work_id")
                    .count
                    .max_by { |w, c| c }
      work = Work.find_by({ id: id })
      tag.i(title_line(work)) + ", #{count} notes"
    end

    def most_represented_author
      id, count = Producer
                    .joins(work_producers: :work)
                    .group("work_producers.producer_id")
                    .count
                    .max_by { |p, c| c }
      producer = Producer.find_by({ id: id })
      producer.name + ", #{count} works"
    end

    def total_reading_time
      duration = ReadingSession.sum(:duration)
      human_duration(duration)
    end

    def longest_book_reading_time
      id, sum = Work
                  .joins(:reading_sessions)
                  .group("reading_sessions.work_id")
                  .sum("reading_sessions.duration")
                  .max_by { |w, d| d }
      work = Work.find_by({ id: id })
      return unless work
      tag.i(title_line(work)) + ", #{human_duration(sum)}"
    end

    def longest_author_reading_time
      id, sum = Producer
                  .joins(work_producers: { work: :reading_sessions })
                  .group("work_producers.producer_id")
                  .sum("reading_sessions.duration")
                  .max_by { |w, d| d }
      producer = Producer.find_by({ id: id })
      return unless producer
      producer.name + ", #{human_duration(sum)}"
    end
  end
end