#!/bin/zsh

# bundle install を静かに実行
bundle install

# データベースが存在するかどうかを確認
if ! bin/rails db:version > /dev/null 2>&1; then
  # データベースが存在しない場合、db:createを実行
  bin/rails db:create
fi

# db:prepareを実行（必要に応じてmigrateやseedを行う）
bin/rails db:prepare
