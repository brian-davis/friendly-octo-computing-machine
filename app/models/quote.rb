class Quote < ApplicationRecord
  belongs_to :work

  validates :text, presence: true
end
