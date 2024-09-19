# == Schema Information
#
# Table name: publishers
#
#  id          :bigint           not null, primary key
#  name        :string
#  works_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  publishers_name_unique  (name) UNIQUE
#
class Publisher < ApplicationRecord
  has_many :works

  accepts_nested_attributes_for :works, allow_destroy: true

  validates :name, uniqueness: true

  # override to delete only the association, not the record
  def works_attributes=(attrs)
    simple_attrs = attrs.values
    destroy_attrs = simple_attrs.select { |attr| attr["_destroy"] == "1" }
    destroy_ids = destroy_attrs.map { |attr| attr["id"] }
    works_to_remove = self.works.where({ id: destroy_ids })
    self.works -= works_to_remove
  end

  class << self
    def name_options
      order(:name).pluck(:name, :id)
    end
  end
end
