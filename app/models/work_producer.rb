class WorkProducer < ApplicationRecord
  belongs_to :work
  belongs_to :producer
  accepts_nested_attributes_for :producer

  enum role: %i[author co_author editor contributor translator]
end
