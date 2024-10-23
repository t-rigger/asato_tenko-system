class Alarm < ApplicationRecord
  scope :enabled, -> { where(enabled: true)}

  belongs_to :user
end
