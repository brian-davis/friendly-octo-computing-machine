# == Schema Information
#
# Table name: work_producers
#
#  id          :bigint           not null, primary key
#  role        :enum             default("author")
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

  enum :role, {
    :author => "author",
    :editor => "editor",
    :contributor => "contributor",
    :translator => "translator",
    :illustrator => "illustrator",
  }, :prefix => :role

  validate :validate_parent_role_uniqueness

  class << self
    def role_options
      roles.keys.map { |k| [k.sub("_", "-").capitalize, k] }
    end
  end

private
  def validate_parent_role_uniqueness
    if self.new_record? &&
       self.class.exists?({
         work_id: self.work_id,
         producer_id: self.producer_id,
         role: self.role
       })

      self.errors.add(:base, "Must be unique by role")
    end
  end
end
