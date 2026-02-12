# Tenko System - シフト管理システム

Google Apps Script (GAS) バックエンドと連携したシフト管理システムです。

## システム構成

- **フロントエンド**: Rails 7.2 (HTML/CSS/JavaScript)
- **バックエンド**: Google Apps Script
- **データベース**: 
  - 管理者情報: PostgreSQL (Rails)
  - ユーザー・シフトデータ: Google Spreadsheet (GAS)

## 主な機能

1. **QR表示ページ** (`/`)
   - 5つのLINEアカウントから空いているものを自動選択
   - QRコードを動的に表示

2. **管理者ダッシュボード** (`/admins/dashboard`)
   - シフトデータの閲覧
   - GASから取得したデータを表示

3. **管理者認証**
   - Deviseによるログイン
   - 招待制の管理者登録

## セットアップ

### 1. 環境変数の設定

`.env.example` をコピーして `.env` を作成:

\`\`\`bash
cp .env.example .env
\`\`\`

`.env` を編集してGAS APIのURLを設定:

\`\`\`
GAS_API_URL=https://script.google.com/macros/s/YOUR_SCRIPT_ID/exec
\`\`\`

### 2. Dockerで起動

\`\`\`bash
docker-compose up --build
\`\`\`

初回起動時は自動的に:
- データベース作成
- マイグレーション実行
- サーバー起動

### 3. 管理者アカウントの作成

コンテナ内でコンソールを開く:

\`\`\`bash
docker-compose exec web bundle exec rails console
\`\`\`

管理者を作成:

\`\`\`ruby
Admin.create!(email: 'admin@example.com', password: 'password123', password_confirmation: 'password123')
\`\`\`

### 4. アクセス

- QR表示ページ: http://localhost:3000
- 管理者ログイン: http://localhost:3000/admins/sign_in
- ダッシュボード: http://localhost:3000/admins/dashboard

## GAS側の設定

1. GASプロジェクトで `gas_backend_code_full.js` をデプロイ
2. Webアプリとして公開（アクセス権限: 全員）
3. 発行されたURLを `.env` の `GAS_API_URL` に設定
4. LINE Developers Consoleで各アカウントのWebhook URLを設定:
   - アカウント0: `{GAS_URL}?ch=0`
   - アカウント1: `{GAS_URL}?ch=1`
   - ...

## 削除された機能

以下の機能はGASに移行されました:

- ユーザー認証（LINE OAuth）
- アラーム/通知スケジューリング
- LINE Webhook処理
- シフトデータの永続化

## トラブルシューティング

### データベース接続エラー

\`\`\`bash
docker-compose down
docker-compose up --build
\`\`\`

### Gemのインストールエラー

\`\`\`bash
docker-compose run web bundle install
docker-compose up
\`\`\`

### マイグレーションエラー

\`\`\`bash
docker-compose exec web bundle exec rails db:reset
\`\`\`

## 開発

### ログの確認

\`\`\`bash
docker-compose logs -f web
\`\`\`

### コンソールの起動

\`\`\`bash
docker-compose exec web bundle exec rails console
\`\`\`

### テストの実行

\`\`\`bash
docker-compose exec web bundle exec rspec
\`\`\`