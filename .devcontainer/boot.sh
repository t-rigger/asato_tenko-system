#!/bin/zsh

sudo chown -R vscode:vscode /workspaces/tenko-system

bundle install

if ! bin/rails db:version > /dev/null 2>&1; then
  bin/rails db:prepare
fi
