# == Schema Information
#
# Table name: work_producers
#
#  id          :bigint           not null, primary key
#  work_id     :bigint           not null
#  producer_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  role        :integer
#
class WorkProducer < ApplicationRecord
  belongs_to :work
  belongs_to :producer

  accepts_nested_attributes_for :producer
  accepts_nested_attributes_for :work

  enum role: %i[author co_author editor contributor translator]

  validate :validate_parent_role_uniqueness

  class << self
    def role_options
      roles.keys.map { |k| [k.sub("_", "-").capitalize, k] }
    end
  end

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
