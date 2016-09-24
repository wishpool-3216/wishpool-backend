class Gift < ActiveRecord::Base
  belongs_to :recipient, class_name: 'User'
  has_many :contributions, dependent: :destroy

  validates :recipient, :name, :creator,
            :publicity, presence: true
  validates :expected_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validate :valid_expiry_date, on: :create

  alias_attribute :giver, :creator

  ##
  # The publicity status of a gift
  # Public -> Recipient can see
  # Private -> Recipient will be unaware
  # Note: Started from 1 instead of 0 cos we lazy with validations
  enum publicity: {
    'Public' => 1,
    'Private' => 2
  }

  stampable

  def to_json(options = {})
    options[:include] ||= [:recipient, :contributions]
    options[:methods] ||= [:sum_contributions]
    super(options)
  end

  def serializable_hash(options = nil)
    options ||= {}
    options[:methods] ||= [:sum_contributions]
    super(options)
  end

  def valid_expiry_date
    errors.add(:expiry, 'must be after today') if expiry && expiry > Date.today
  end

  def sum_contributions
    contributions.pluck(:amount).sum
  end
end
