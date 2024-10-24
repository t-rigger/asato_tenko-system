class AlarmMailer < ApplicationMailer

  def send_alarm(alarm)
    @alarm = alarm
    @user = @alarm.user

    mail(
      from: email_address_with_name('no-reply@yukimi-corp.com', '幸美商事点呼システム'),
      to: @user.email
      subject: "【重要】出勤前点呼のお願い"
    )
  end
end
