class Api::EmailController < Api::ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    alarm_id = params[:alarm_id]
    @alarm = Alarm.find(alarm_id)

    # 点呼完了を記録
    logger.info "点呼完了: #{@alarm.user.name}さん (ID: #{@alarm.id}) が点呼完了しました。"

    @admins = Admin.all
    AlarmMailer.confirm_alarm(@alarm, @admins).deliver_now

    redirect_to alarms_confirmed_path
  end
end
