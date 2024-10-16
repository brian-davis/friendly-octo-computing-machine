class BookshelfMetrics
  extend ActionView::Helpers::TagHelper
  extend ActionView::Helpers::DateHelper
  extend WorksHelper
  extend ApplicationHelper

  class << self
    def summary
      base_metrics = [
        {
          label: "Total Books",
          result: books_count
        },
        {
          label: "Total Authors",
          result: authors_count
        },
        {
          label: "Total Publishers",
          result: publishers_count
        },
        {
          label: "Top Author",
          result: most_represented_author
        },
        {
          label: "Top Publisher",
          result: most_represented_publisher
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
      ]
      if Flipper.enabled?(:reading_sessions)
        reading_sessions_metrics = [
          {
            label: "Current Book",
            result: self.current_book
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
        base_metrics += reading_sessions_metrics
      end
      return base_metrics
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

    def books_count
      Work.publishing_format_book.collection.size
    end

    def authors_count
      WorkProducer.role_author.joins(:work).merge(Work.collection).pluck(:producer_id).uniq.size
    end

    def publishers_count
      Publisher.joins(:works).merge(Work.collection).distinct.size
    end

    def newest_book
      work = Work.collection.find_by({
        created_at: Work.collection.maximum(:created_at)
      })
      return unless work
      tag.i(work.reference.long_title) + ", #{time_ago_in_words(work.created_at)} ago"
    end

    def most_quoted_book
      id, count = Work
                    .collection
                    .joins(:quotes)
                    .group("quotes.work_id")
                    .count
                    .max_by { |w, c| c }
      work = Work.find_by({ id: id })
      return unless work
      tag.i(work.reference.long_title) + ", #{count} quotes"
    end

    def most_noted_book
      id, count = Work
                    .collection
                    .joins(:notes)
                    .group("notes.notable_id")
                    .count
                    .max_by { |w, c| c }
      work = Work.find_by({ id: id })
      return unless work
      tag.i(work.reference.long_title) + ", #{count} notes"
    end

    def most_represented_author
      id, count = Producer
                    .joins(work_producers: :work)
                    .merge(WorkProducer.role_author)
                    .merge(Work.collection)
                    .group("work_producers.producer_id")
                    .count
                    .max_by { |_p, c| c }
      producer = Producer.find_by({ id: id })
      return "no data" unless producer&.full_name&.present?
      producer.full_name + ", #{count} works" # IMPROVE: use helper for formatting
    end

    def most_represented_publisher
      id, count = Publisher
                    .joins(:works)
                    .merge(Work.collection)
                    .group("works.publisher_id")
                    .count
                    .max_by { |_p, c| c }
      publisher = Publisher.find_by({ id: id })
      return "no data" unless publisher&.name&.present?
      publisher.name + ", #{count} works" # IMPROVE: use helper for formatting
    end

    # toggled off

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
      tag.i(work.reference.long_title) + ", #{human_duration(sum)}"
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

      producer.full_name + ", #{human_duration(sum)}"
    end

    def current_book
      session = ReadingSession.find_by(ended_at: ReadingSession.maximum(:ended_at))
      return unless session
      work = session.work
      tag.i(work.reference.long_title) + ", #{time_ago_in_words(session.ended_at)} ago"
    end
  end
end