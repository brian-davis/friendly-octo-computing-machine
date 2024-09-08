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
  belongs_to :producer, counter_cache: :works_count

  accepts_nested_attributes_for :producer
  accepts_nested_attributes_for :work

  enum_accessor :role, %i[author editor contributor translator illustrator]

  before_validation :default_role

  validate :validate_parent_role_uniqueness

  scope :authors, -> {
    where_role(:author)
  }

  class << self
    def role_options
      roles.keys.map { |k| [k.sub("_", "-").capitalize, k] }
    end
  end

private
  def default_role
    self.role = :author if self.role.nil?
  end

  def validate_parent_role_uniqueness
    if self.new_record? &&
       self.class.exists?({
         work_id: self.work_id,
         producer_id: self.producer_id,
         role: self.class.roles[self.role] # "author" => 0
       })

      self.errors.add(:base, "Must be unique by role")
    end
  end
end
