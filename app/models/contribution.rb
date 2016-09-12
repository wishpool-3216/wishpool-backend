##
# Records the contributions made to a particular gift
class Contribution < ActiveRecord::Base
  belongs_to :gift

  validates :gift, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  stampable
end
