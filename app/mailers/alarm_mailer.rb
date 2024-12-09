class AlarmMailer < ApplicationMailer

  def send_alarm(alarm)
    @alarm = alarm
    @user = @alarm.user
    @url = "#{ENV["URL"]}/api/v1/email/webhook?alarm_id=#{@alarm.id}"

    mail(
      from: email_address_with_name('no-reply@yukimi-corp.com', '幸美商事点呼システム'),
      to: @user.email,
      subject: "【重要】出勤前点呼のお願い"
    )
  end

  def confirm_alarm(alarm, admins)
    @alarm = alarm
    @user = @alarm.user
    @admins = admins
    @now = Time.current
    # 曜日の取得
    @days = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    @wday = @now.wday

    mail(
      from: email_address_with_name('no-reply@yukimi-corp.com', '幸美商事点呼システム'),
      to: @admins.pluck(:email),
      subject: "【重要】#{@user.name}さん点呼完了の連絡"
    )
  end
end
