class Admins::SessionsController < ApplicationController

  def new
    if admin_signed_in?
      redirect_to root_path, notice: "すでにログインしています。"
    end
  end

  def create
    admin_email    = ENV['ADMIN_EMAIL'].to_s.strip
    admin_password = ENV['ADMIN_PASSWORD'].to_s.strip

    # 環境変数未設定はサーバーエラー
    if admin_email.empty? || admin_password.empty?
      render plain: "サーバー設定エラーです。", status: :internal_server_error
      return
    end

    # タイミング攻撃対策: 定数時間比較
    email_match    = ActiveSupport::SecurityUtils.secure_compare(params[:email].to_s, admin_email)
    password_match = ActiveSupport::SecurityUtils.secure_compare(params[:password].to_s, admin_password)

    if email_match && password_match
      session[:admin_id] = "admin"
      redirect_to root_path, notice: "ログインしました。"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが違います。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_path, notice: "ログアウトしました。", status: :see_other
  end
end

