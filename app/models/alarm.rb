class Alarm < ApplicationRecord
  scope :enabled, -> { where(enabled: true)}

  def enable_weekdays
    
  end
end
