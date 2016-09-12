class Gift < ActiveRecord::Base
  belongs_to :recipient, class_name: 'User'

  validates :recipient, :name, :creator, presence: true

  stampable
end
