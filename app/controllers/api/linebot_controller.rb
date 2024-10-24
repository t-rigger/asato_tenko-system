require "http"

class Api::LinebotController < Api::AlarmsController
  skip_before_action :verify_authenticity_token

  def webhook
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    # LINEからのリクエストを検証
    unless client.validate_signature(body, signature)
      head :bad_request
      return
    end

    events = client.parse_events_from(body)

    events.each do |event|
      if event.is_a?(Line::Bot::Event::Postback)
        # Postbackイベントの処理
        data = URI.decode_www_form(event['postback']['data']).to_h
        if data['action'] == 'complete_check'
          alarm_id = data['alarm_id']
          alarm = Alarm.find(alarm_id)

          # 点呼完了を記録
          logger.info "点呼完了: #{alarm.user.name}さん (ID: #{alarm.id}) が点呼完了しました。"
          send_message(alarm)

        end
      end
    end

    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['CHANNEL_SECRET']
      config.channel_token = ENV['CHANNEL_TOKEN']
    }
  end

  def send_message(alarm)
    # pushメッセージに必要な情報も用意しておく
    url = "https://api.line.me/v2/bot/message/push"
    channel_access_token = ENV["CHANNEL_ACCESS_TOKEN"]

    # LINE IDを取得
    uid = alarm.user.uid
    # 通知するメッセージ
    message_text = "点呼を完了しました。本日も安全運転でよろしくお願いいたします。"

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
      logger.info "#{now.strftime('%Y/%m/%d %H:%M:%S')} #{days[wday]} #{alarm.user.name}さんに点呼を送信完了"
    else
      logger.error "点呼の送信に失敗しました: #{response.body.to_s}"
    end

  end
end
