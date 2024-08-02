class Work < ApplicationRecord
  has_many :work_producers, dependent: :destroy
  has_many :producers, through: :work_producers

  accepts_nested_attributes_for :work_producers, allow_destroy: true
  # accepts_nested_attributes_for :producers

  # # Setter for `has_many :producers, through: :work_producers`.
  # # Use Work form to build associated Producer records, or
  # # to remove existing WorkProducer records.
  # # Accept multiple Producer attribute sets.  Ignore duplicate data.
  # # Destroy or create only, no update.
  # # e.g.:
  # #   >> producers_attributes
  # #   => {"0"=>{"id"=>"1", "_destroy"=>"0"}, "1"=>{"id"=>"2", "_destroy"=>"1"}, "2"=>{"name"=>"ccc"}}
  # # #=> ignore 0, destroy 1, create 2
  # def producers_attributes=(producers_attributes)
  #   # binding.irb
  #   producers_attributes.each do |_k, attrs|
  #     if (attrs.delete("_destroy") == "1")
  #       # destroy join record for existing, joined Producer record
  #       work_producers.destroy_by(producer_id: attrs["id"])
  #     elsif (id = attrs.delete("id"))
  #       # new or existing join record to existing Producer record
  #       work_producers.find_or_initialize_by({
  #         producer_id: id
  #         # TODO: role
  #       }) if Producer.exists?(id: id)
  #     else
  #       # new join record to new Producer record
  #       producers.build(attrs)
  #     end
  #   end
  # end
end