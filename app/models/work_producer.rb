# == Schema Information
#
# Table name: work_producers
#
#  id          :bigint           not null, primary key
#  role        :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  producer_id :bigint           not null
#  work_id     :bigint           not null
#
# Indexes
#
#  index_work_producers_on_producer_id             (producer_id)
#  index_work_producers_on_role                    (role)
#  index_work_producers_on_work_id                 (work_id)
#  work_producers_work_id_producer_id_role_unique  (work_id,producer_id,role) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (producer_id => producers.id)
#  fk_rails_...  (work_id => works.id)
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
