require "http"

class Api::LinebotController < Api::ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    @now = Time.current
    # 曜日の取得
    @days = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    @wday = @now.wday
    @alarm = Alarm.find(params[:alarm_id])
    # 点呼完了を記録
    logger.info "点呼完了: #{@alarm.user.name}さん (ID: #{@alarm.id}) が点呼完了しました。"

    # 点呼した当人にもLINE通知を送る
    if @alarm.line?
      url = "https://api.line.me/v2/bot/message/push"
      channel_access_token = ENV["CHANNEL_ACCESS_TOKEN"]
      uid = @alarm.user.uid
      # 通知するメッセージ
      message_text = "#{@now.strftime('%Y/%m/%d %H:%M')} #{@days[@wday]} 点呼を完了しました。本日も安全運転でよろしくお願いいたします。"

      body = {
        to: uid,
        messages: [
          {
            "type": "text",
            "text": message_text
          }
        ]
      }

      # LINE APIにリクエストを送信
      response = HTTP.auth("Bearer #{channel_access_token}")
        .headers(content_type: "application/json", accept: "application/json")
        .post(url, body: body.to_json)

      if response.status.success?
        logger.info "#{@now.strftime('%Y/%m/%d %H:%M:%S')} #{@days[@wday]} #{@alarm.user.name}さんに点呼完了通知を送信"
      else
        logger.error "点呼完了通知の送信に失敗しました: #{response.body.to_s}"
      end
    end

    # 管理者にはメール通知
    @admins = Admin.all
    AlarmMailer.confirm_alarm(@alarm, @admins).deliver_now
  end
end
