class Rack::Attack
  # 1. ログイン試行制限: 同一IPから1分間に5回まで
  # エラー時は429 (Too Many Requests) を返す
  throttle('login/ip', limit: 5, period: 1.minute) do |req|
    if req.path == '/admins/dashboard' && req.post?
      req.ip
    end
  end

  # Basic認証の場合も考慮（今回のケースはこちらが該当）
  throttle('admin_login/ip', limit: 5, period: 1.minute) do |req|
    # Basic認証ヘッダーがあるリクエスト全体を制限
    if req.env['HTTP_AUTHORIZATION']
      req.ip
    end
  end

  # 制限を超えた場合のレスポンス設定
  self.throttled_response = lambda do |env|
    [ 429,  # status
      {},   # headers
      ["Login limit exceeded. Please try again later.\n"] # body
    ]
  end
end
