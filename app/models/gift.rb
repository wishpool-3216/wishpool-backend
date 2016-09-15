class Gift < ActiveRecord::Base
  belongs_to :recipient, class_name: 'User'
  has_many :contributions

  validates :recipient, :name, :creator,
            :publicity, presence: true

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
end
