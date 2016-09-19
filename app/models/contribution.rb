##
# Records the contributions made to a particular gift
class Contribution < ActiveRecord::Base
  belongs_to :gift
  alias_attribute :contributor, :creator

  validates :gift, :amount, :creator, presence: true
  validates :amount, numericality: { greater_than: 0 }

  stampable

  def to_json(options = {})
    options[:include] ||= [:gift, :contributor]
    super(options)
  end
end
