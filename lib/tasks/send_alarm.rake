require "http"

namespace :send_alarm do
  desc "有効化されている点呼を対象ユーザーに通知する"
  task execute: :environment do
    now = Time.current
    days = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    wday = now.wday

    puts "タスク実行記録: #{now.strftime('%Y/%m/%d %H:%M:%S')} #{days[wday]}"

    alarms = Alarm.get_alarms(wday)
    puts "#{alarms.count}件の有効化されている点呼を確認しました。"

    if alarms.present?
      alarms.each do |alarm|
        # LINE通知の処理
        if alarm.line?
          url = "https://api.line.me/v2/bot/message/push"
          channel_access_token = ENV["CHANNEL_ACCESS_TOKEN"]
          uid = alarm.user.uid
          message_text = "#{now.strftime('%Y/%m/%d %H:%M')} #{days[wday]} 出勤前の点呼をお願いします。\n\n"
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

          response = HTTP.auth("Bearer #{channel_access_token}")
            .headers(content_type: "application/json", accept: "application/json")
            .post(url, body: body.to_json)

          if response.status.success?
            puts "#{now.strftime('%Y/%m/%d %H:%M:%S')} #{days[wday]} #{alarm.user.name}さんにLINEで点呼を送信完了"
          else
            puts "点呼の送信に失敗しました: #{response.body.to_s}"
          end
        end

        # Email通知の処理
        if alarm.email?
          AlarmMailer.send_alarm(alarm).deliver_now
          puts "#{now.strftime('%Y/%m/%d %H:%M:%S')} #{days[wday]} #{alarm.user.name}さんにメールを送信完了"
        end
      end
    else
      puts "この日時に通知する点呼はありません。"
    end
  end
end