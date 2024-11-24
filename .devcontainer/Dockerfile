# 最新のVS Code Dev Containerのベースイメージを使用
FROM mcr.microsoft.com/vscode/devcontainers/base:latest

# apt-getのインストール処理を自動で進行できるように
ENV DEBIAN_FRONTEND=noninteractive

# 必要パッケージのインストールと不要ファイルのクリーンアップ
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        git git-lfs libpq-dev openssh-client imagemagick libvips libvips42 graphviz vim less && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# インタラクティブプロンプト設定を元に戻す
ENV DEBIAN_FRONTEND=dialog
