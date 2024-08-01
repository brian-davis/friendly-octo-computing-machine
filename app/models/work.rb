class Work < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :producers, through: :work_producers
  accepts_nested_attributes_for :producers

  # Setter for `has_many :producers, through: :work_producers`.
  # Use Work form to build associated Producer models.
  # Accept multiple Producer attribute sets.  Ignore duplicate data.
  # Destroy or create only, no update.
  # e.g.:
  #   >> producers_attributes
  #   => {"0"=>{"id"=>"1", "_destroy"=>"0"}, "1"=>{"id"=>"2", "_destroy"=>"1"}, "2"=>{"name"=>"ccc"}}
  # #=> ignore 0, destroy 1, create 2
  def producers_attributes=(producers_attributes)
    producers_attributes.each do |_k, attrs|
      if (id = attrs.delete("id"))
        work_producer = work_producers.find_by(producer_id: id)
        # destroy the join record, not the associated producer (orphan producers OK)
        work_producer.destroy if work_producer && attrs["_destroy"] == "1"
      elsif attrs["name"].present?
        # TODO: attrs on join model
        producer = producers.find_or_create_by(name: attrs["name"]) # builds join model
      end
    end
  end
end