class BookshelfMetrics
  extend ActionView::Helpers::TagHelper
  extend ActionView::Helpers::DateHelper
  extend WorksHelper
  extend ApplicationHelper

  class << self
    def summary
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

    def chart_usage(scale, max = 100)
      scale ||= :week
      days_count = case scale.to_sym
      when :week
        7
      when :month
        31
      when :year
        366
      when :all
        (Time.now - (ReadingSession.minimum(:ended_at).to_datetime - 1.day)).to_i / 86400
      end

      days_template = (1..days_count).map { |i| [i.days.ago.to_date, 0] }.to_h
      results = ReadingSession
                  .where(ended_at: (days_count.days.ago..1.second.ago))
                  .group("DATE(ended_at)")
                  .sum(:duration)
      days_results = days_template.merge(results).sort_by { |a, b| a }

      days_results.downsample(max).to_h
    end

    private

    def current_book
      session = ReadingSession.find_by(ended_at: ReadingSession.maximum(:ended_at))
      return unless session
      work = session.work
      tag.i(title_line(work)) + ", #{time_ago_in_words(session.ended_at)} ago"
    end

    def newest_book
      work = Work.find_by(created_at: Work.maximum(:created_at))
      return unless work
      tag.i(title_line(work)) + ", #{time_ago_in_words(work.created_at)} ago"
    end

    def most_quoted_book
      id, count = Work
                    .joins(:quotes)
                    .group("quotes.work_id")
                    .count
                    .max_by { |w, c| c }
      work = Work.find_by({ id: id })
      return unless work
      tag.i(title_line(work)) + ", #{count} quotes"
    end

    def most_noted_book
      id, count = Work
                    .joins(:notes)
                    .group("notes.work_id")
                    .count
                    .max_by { |w, c| c }
      work = Work.find_by({ id: id })
      return unless work
      tag.i(title_line(work)) + ", #{count} notes"
    end

    def most_represented_author
      id, count = Producer
                    .joins(work_producers: :work)
                    .group("work_producers.producer_id")
                    .count
                    .max_by { |p, c| c }
      producer = Producer.find_by({ id: id })
      return unless producer.try(:name)

      # TODO: avoid cache column
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
      return unless id
      producer = Producer.find_by({ id: id })
      return unless producer.try(:name)

      # TODO: avoid cache column
      producer.name + ", #{human_duration(sum)}"
    end
  end
end