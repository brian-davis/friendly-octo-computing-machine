class WorkProducer < ApplicationRecord
  belongs_to :work
  belongs_to :producer

  accepts_nested_attributes_for :producer
  accepts_nested_attributes_for :work

  enum role: %i[author co_author editor contributor translator]

  validate :validate_parent_role_uniqueness

private

  def validate_parent_role_uniqueness
    if self.new_record? && self.class.exists?({
      work_id: self.work_id,
      producer_id: self.producer_id,
      role: self.role
    })
      self.errors.add(:base, "Must be unique by role")
    end
  end
end
