# == Schema Information
#
# Table name: publishers
#
#  id          :bigint           not null, primary key
#  location    :string
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
  has_many :works, dependent: :nullify

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

  def country_name
    return unless location.present?
    ISO3166::Country.find_country_by_alpha3(location).common_name
  end

  class << self
    def name_options
      order(:name).pluck(:name, :id)
    end

    def country_options
      top3 = group(:location)
              .count
              .except(nil)
              .sort_by { |k, c| c }
              .reverse
              .take(3)
              .map { |k, c| k }

      ISO3166::Country
      .all
      .map { |cc| [cc.common_name, cc.alpha3] }
      .sort_by do |cname, ccode|
        top3_i = top3.index(ccode)
        if top3_i
          "A" * (top3_i + 1)
        else
          ("A" * 4) + cname
        end
      end
      .map do |pair|
        if pair[1].in?(top3)
          pair + [{class: "bold"}]
        else
          pair
        end
      end
    end
  end
end
