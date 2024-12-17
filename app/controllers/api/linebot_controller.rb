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
      logger.info "#{@now.strftime('%Y/%m/%d %H:%M:%S')} #{@days[@wday]} #{@alarm.user.name}さんにLINE点呼完了通知を送信"
    else
      logger.error "LINE点呼完了通知の送信に失敗しました: #{response.body.to_s}"
      return false
    end
  end

  private

  def send_email_for_done_alarm(alarm)
    admins = Admin.all
    AlarmMailer.confirm_alarm(alarm, admins).deliver_now
  end

  def send_line_for_done_alarm(alarm)
    admin_url = "https://api.line.me/v2/bot/message/push"
    admin_channel_access_token = ENV["ADMIN_CHANNEL_ACCESS_TOKEN"]
    admin_uid = ENV["ADMIN_LINE_UID"]

    admin_now = Time.current
    # 曜日の取得
    admin_days = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    admin_wday = admin_now.wday

    # 通知するメッセージ
    admin_message_text = "#{admin_now.strftime('%Y/%m/%d %H:%M')} #{admin_days[admin_wday]} #{alarm.user.name}さんがLINE点呼を完了しました。"

    admin_body = {
      to: admin_uid,
      messages: [
        {
          "type": "text",
          "text": admin_message_text
        }
      ]
    }

    # LINE APIにリクエストを送信
    admin_response = HTTP.auth("Bearer #{admin_channel_access_token}")
      .headers(content_type: "application/json", accept: "application/json")
      .post(admin_url, body: admin_body.to_json)

    if admin_response.status.success?
      logger.info "#{admin_now.strftime('%Y/%m/%d %H:%M:%S')} #{admin_days[admin_wday]} 管理者にLINE点呼完了通知を送信"
    else
      logger.error "LINE点呼完了通知の送信に失敗しました: #{admin_response.body.to_s}"
      return false
    end
  end
end
