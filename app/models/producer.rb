class Producer < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :works, through: :work_producers
  accepts_nested_attributes_for :works

  # Setter for `has_many :works, through: :work_producers`.
  # Use Producer form to build associated Work records, or
  # to remove existing WorkProducer records.
  # Accept multiple Work attribute sets.  Ignore duplicate data.
  # Destroy or create only, no update.
  # e.g.:
  #   >> works_attributes
  #   => {"0"=>{"id"=>"1", "_destroy"=>"0"}, "1"=>{"id"=>"2", "_destroy"=>"1"}, "2"=>{"title"=>"ccc"}}
  # #=> ignore 0, destroy 1, create 2
  def works_attributes=(works_attributes)
    works_attributes.each do |_k, attrs|
      if (id = attrs.delete("id"))
        work_producer = work_producers.find_by(work_id: id)
        # destroy the join record, not the associated producer (orphan works OK)
        work_producer.destroy if work_producer && attrs["_destroy"] == "1"
      elsif attrs["title"].present?
        work = Work.find_or_create_by(title: attrs["title"])
        joiner = work_producers.create(work: work)
      end
    end
  end
end
