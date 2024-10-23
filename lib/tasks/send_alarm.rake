namespace :send_alarm do
  desc "有効化されている点呼を対象ユーザーに通知する"
  # タスク名(purge)を指定
  task purge: :environment do
    puts "Hello World!"
  end
end
