#!/bin/zsh

bundle install

bin/rails db:prepare

echo "初期設定完了"
