class Alarm < ApplicationRecord
  scope :enabled_alarms, -> { where(enabled: true)}

  belongs_to :user

  def self.get_alarms(wday)
    # 現在の曜日に対応するカラム名を設定
    day_column = case wday
      when 0 then :sunday
      when 1 then :monday
      when 2 then :tuesday
      when 3 then :wednesday
      when 4 then :thursday
      when 5 then :friday
      when 6 then :saturday
    end

    where(enabled: true).where(
      everyday: true
    ).or(
      where(enabled: true).where(day_column => true)
    )
  end
end
