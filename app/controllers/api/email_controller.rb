class Api::EmailController < Api::ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    @now = Time.current
    # 曜日の取得
    @days = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    @wday = @now.wday
    @alarm = Alarm.find(params[:alarm_id])
    # 点呼完了を記録
    logger.info "点呼完了: #{@alarm.user.name}さん (ID: #{@alarm.id}) が点呼完了しました。"
    @admins = Admin.all
    AlarmMailer.confirm_alarm(@alarm, @admins).deliver_now
  end
end
