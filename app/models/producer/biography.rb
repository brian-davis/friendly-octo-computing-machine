class Producer::Biography < ActiveRecord::AssociatedObject
  include TimeFormatter

  extension do
    # Extend Producer here
  end

  def context
    lifetime = common_era_span(producer.year_of_birth, producer.year_of_death, { parenthesis: false })

    [producer.nationality, lifetime].map(&:presence).compact.join(", ")
  end
end
