# rake "send_alarm:purge"で実行されるTask
require "http"

namespace :send_alarm do
  desc "有効化されている点呼を対象ユーザーに通知する"
  # タスク名(purge)を指定
  task execute: :environment do
    # 現在時刻の取得
    now = Time.current

    # 曜日の取得
    days = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    wday = now.wday

    puts "タスク実行記録: #{now.strftime('%Y/%m/%d %H:%M:%S')} #{days[wday]}"

    # 現在有効化されている点呼のうち、everydayがtrueか、該当曜日がtrueのものを取得
    @alarms = Alarm.get_alarms(wday)

    puts "#{@alarms.count}件の有効化されている点呼を確認しました。"

    if @alarms.present?
      @alarms.each do |alarm|

        # 点呼方法によって分岐
        if alarm.line?
          # pushメッセージに必要な情報も用意しておく
          url = "https://api.line.me/v2/bot/message/push"
          channel_access_token = ENV["CHANNEL_ACCESS_TOKEN"]

          # LINE IDを取得
          uid = alarm.user.uid
          # 通知するメッセージ
          message_text = "#{now.strftime('%Y/%m/%d %H:%M')} #{days[wday]} 出勤前の点呼をお願いします。\n\n"
          # LINEメッセージのボディ
          body = {
            to: uid,
            messages: [
              {
                "type": "template",
                "altText": "点呼のお願いです",
                "template": {
                  "type": "buttons",
                  "text": message_text,
                  "actions": [
                    {
                      "type": "postback",
                      "label": "点呼完了",
                      "data": "action=complete_check&alarm_id=#{alarm.id}"
                    }
                  ]
                }
              }
            ]
          }
          # LINE APIにリクエストを送信
          response = HTTP.auth("Bearer #{channel_access_token}")
          .headers(content_type: "application/json", accept: "application/json")
          .post(url, body: body.to_json)

          if response.status.success?
            puts "#{now.strftime('%Y/%m/%d %H:%M:%S')} #{days[wday]} #{alarm.user.name}さんに点呼を送信完了"
          else
            puts "点呼の送信に失敗しました: #{response.body.to_s}"
          end
        elsif alarm.email?
          AlarmMailer.send_alarm(alarm).deliver_now
        end
      end
    else
      puts "この日時に通知する点呼はありません。"
    end
  end
end